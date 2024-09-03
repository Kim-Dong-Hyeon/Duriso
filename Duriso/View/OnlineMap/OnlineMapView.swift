//
//  OnlineMapView.swift
//  Duriso
//
//  Created by 이주희 on 9/1/24.
//

import UIKit

import KakaoMapsSDK

class OnlineMapView: UIViewController, MapControllerDelegate {
  
  var mapContainer: KMViewContainer?
  var mapController: KMController?
  var _observerAdded: Bool
  var _auth: Bool
  var _appear: Bool
  private var shelters = ShelterData.shared.setShelters()
  
  init() {
    _observerAdded = false
    _auth = false
    _appear = false
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    _observerAdded = false
    _auth = false
    _appear = false
    super.init(coder: aDecoder)
  }
  
  override func loadView() {
    let kmViewContainer = KMViewContainer(frame: UIScreen.main.bounds)
    self.view = kmViewContainer
    self.mapContainer = kmViewContainer
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let mapContainer = mapContainer {
      mapController = KMController(viewContainer: mapContainer)
      mapController?.delegate = self
      mapController?.prepareEngine()
      mapController?.activateEngine()
    }
    
    addViews()
    addObservers()
    createLabelLayer()
    createPoiStyle()
    createPoi()
  }
  
  deinit {
    mapController?.pauseEngine()
    mapController?.resetEngine()
    removeObservers()
    print("deinit")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _appear = true
    
    if mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    _appear = false
    mapController?.pauseEngine()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    mapController?.resetEngine()
    removeObservers()
  }
  
  func authenticationFailed(_ errorCode: Int, desc: String) {
    print("error code: \(errorCode)")
    print("desc: \(desc)")
    _auth = false
    switch errorCode {
    case 400:
      showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
    case 401:
      showToast(self.view, message: "지도 종료(API인증 키 오류)")
    case 403:
      showToast(self.view, message: "지도 종료(API인증 권한 오류)")
    case 429:
      showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
    case 499:
      showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        print("retry auth...")
        self.mapController?.prepareEngine()
      }
    default:
      break
    }
  }
  
  func addViews() {
    let defaultPosition = MapPoint(longitude: 126.9780, latitude: 37.5665)
    let mapviewInfo = MapviewInfo(
      viewName: "mapview",
      viewInfoName: "map",
      defaultPosition: defaultPosition,
      defaultLevel: 17
    )
    
    guard mapController != nil else {
      print("Error: mapController is nil.")
      return
    }
    
    guard let mapView = mapController?.addView(mapviewInfo) else {
      print("Error: Failed to add map view. Check if the engine is initialized and active.")
      return
    }
    
    print("Map view added with default position: \(defaultPosition) and level: 17")
  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    print("Map view added successfully with viewName: \(viewName), viewInfoName: \(viewInfoName)")
    moveToCurrentLocation()
    createLabelLayer()
    createPoiStyle()
    createPoi()
  }
  
  func addViewFailed(_ viewName: String, viewInfoName: String) {
    print("Failed to add map view with viewName: \(viewName), viewInfoName: \(viewInfoName)")
  }
  
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
  }
  
  func viewWillDestroyed(_ view: ViewBase) {
    // 필요한 경우 추가 작업
  }
  
  func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    _observerAdded = true
  }
  
  func removeObservers() {
    NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    _observerAdded = false
  }
  
  @objc func willResignActive() {
    mapController?.pauseEngine()
  }
  
  @objc func didBecomeActive() {
    mapController?.activateEngine()
  }
  
  func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 150, y: view.frame.size.height - 100, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center
    view.addSubview(toastLabel)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds = true
    
    UIView.animate(withDuration: 0.4,
                   delay: duration - 0.4,
                   options: UIView.AnimationOptions.curveEaseOut,
                   animations: {
      toastLabel.alpha = 0.0
    },
                   completion: { (finished) in
      toastLabel.removeFromSuperview()
    })
  }
  
  func createLabelLayer() {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil.")
      return
    }
    let labelManager = mapView.getLabelManager()
    let layer = LabelLayerOptions(layerID: "shelterLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 20000)
    let _ = labelManager.addLabelLayer(option: layer)
    print("Label layer created successfully.")
  }
  
  func createPoiStyle() {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil.")
      return
    }
    let labelManager = mapView.getLabelManager()
    
    if let image = UIImage(named: "ShelterMarker.png") {
      let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
      let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
      let poiStyle = PoiStyle(styleID: "shelterStyle", styles: [perLevelStyle])
      labelManager.addPoiStyle(poiStyle)
      print("Success: Image loaded and POI style created.")
    } else {
      print("Error: ShelterMarker.png 이미지 로드 실패")
    }
  }
  
  func createPoi() {
    shelters = ShelterData.shared.setShelters()
    
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil.")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    guard let layer = labelManager.getLabelLayer(layerID: "shelterLayer") else {
      print("Error: Failed to get label layer.")
      return
    }
    
    layer.clearAllItems()  // 기존 마커들을 삭제하여 초기화
    
    for shelter in shelters {
      let options = PoiOptions(styleID: "shelterStyle", poiID: "\(shelter.id)")
      let point = MapPoint(longitude: shelter.longitude, latitude: shelter.latitude)
      
      if let poi = layer.addPoi(option: options, at: point) {
        poi.clickable = true
        poi.show()  // 마커를 지도에 표시
        print("Success: POI added for Shelter ID: \(shelter.id)")
      } else {
        print("Error: Failed to add POI for Shelter ID: \(shelter.id)")
      }
    }
  }
  
  func moveToCurrentLocation() {
    // 현재 위치로 이동하는 로직 추가 (옵션)
    // 현재 사용자의 위치로 지도 카메라를 이동합니다.
  }
}
