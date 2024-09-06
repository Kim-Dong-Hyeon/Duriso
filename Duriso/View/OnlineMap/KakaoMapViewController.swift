//
//  OnlineMapView.swift
//  Duriso
//
//  Created by 이주희 on 9/1/24.
//

import UIKit

import RxCocoa
import RxSwift
import KakaoMapsSDK


/** -KakaoMapViewController : KakaoMap의 뷰트롤러 관리
 지도 생성 및 초기화, poi 생성 및 관리를 담당함
 */
class KakaoMapViewController: UIViewController, MapControllerDelegate {
  
  
  // MARK: - PROPERTIES
  var mapContainer: KMViewContainer?
  var mapController: KMController?
  var _observerAdded: Bool
  var _auth: Bool
  var _appear: Bool
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
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
  
  //MARK: - view Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let mapContainer = mapContainer {
      mapController = KMController(viewContainer: mapContainer)
      mapController?.delegate = self
      mapController?.prepareEngine()
      mapController?.activateEngine()
    }
    
    if mapController == nil {
      return
    }
    
    addViews()
    addObservers()
  }
  
  deinit {
    mapController?.pauseEngine()
    mapController?.resetEngine()
    removeObservers()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
    _appear = true
    if mapController?.isEnginePrepared == false {
      mapController?.prepareEngine()
    }
    
    if mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
    mapContainer?.isUserInteractionEnabled = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    _appear = false
    mapController?.pauseEngine()
  }
  
  // MARK: - MapControllerDelegate Methods
  func authenticationSucceeded() {
    if _auth == false {
      _auth = true
    }
    
    if _appear && mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
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
  
  // MARK: - View Management
  func addViews() {
    let defaultPosition = MapPoint(longitude: 126.977969, latitude: 37.566535)
    let mapviewInfo = MapviewInfo(
      viewName: "mapview",
      viewInfoName: "map",
      defaultPosition: defaultPosition,
      defaultLevel: 17)
    mapController?.addView(mapviewInfo)
  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      return
    }
    
    createLabelLayer()
    bindViewModel()
  }
  
  func addViewFailed(_ viewName: String, viewInfoName: String) {
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
  
  // MARK: -Toast
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
  
  // MARK: - poi management
  /// func
  /// createLabelLayer(): LabelLayer 생성,  POI 관련 작업을 위한 준비 단계
  /// poiVisible(): POI의 가시성을 제어하는 함수로, 레이어가 이미 생성된 상태에서 POI를 보여주거나 숨기는 기능을 담당
  /// createPoiStyle(): poi 스타일 생성
  /// creatPoi(): poi데이터에 레이어를 추가하는 함수 = poi를 시각적 표시
  /// setupPoi(): poi 스타일, 데이터 설정해주는 함수 = creatPoi호출해서 Poi설정
  /// bindViewModel(): setupPoi를 호출해서 실제 Poi 호출
  ///
  func createLabelLayer() {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
    let labelManager = mapView.getLabelManager()
    
    // Shelter 레이어 생성
    let shelterLayer = LabelLayerOptions(
      layerID: "shelterLayer",
      competitionType: .none,
      competitionUnit: .symbolFirst,
      orderType: .rank,
      zOrder: 20000)
    if let shelterLayerResult = labelManager.addLabelLayer(option: shelterLayer) {
      print("Shelter label layer created successfully: \(shelterLayerResult)")
    } else {
      print("Failed to create Shelter label layer.")
    }
    
    // AED 레이어 생성
    let aedLayer = LabelLayerOptions(
      layerID: "aedLayer",
      competitionType: .none,
      competitionUnit: .symbolFirst,
      orderType: .rank,
      zOrder: 20001)
    if let aedLayerResult = labelManager.addLabelLayer(option: aedLayer) {
      print("AED label layer created successfully: \(aedLayerResult)")
    } else {
      print("Failed to create AED label layer.")
    }
    
    let notificationLayer = LabelLayerOptions(
      layerID: "notificationLayer",
      competitionType: .none,
      competitionUnit: .symbolFirst,
      orderType: .rank,
      zOrder: 20002)
    if let notificationLayerResult = labelManager.addLabelLayer(option: notificationLayer) {
      print("notification label layer created successfully: \(notificationLayerResult)")
    } else {
      print("Failed to create notification label layer.")
    }
  }
  
  func poiVisible(_ state: Bool) {
    let mapView: KakaoMap = mapController?.getView("mapview") as! KakaoMap
    let labelManager = mapView.getLabelManager()
    let layer = labelManager.getLabelLayer(layerID: "poiLayer")
    
    // POI들 가져와서 이벤트 적용
    if state {
      layer?.showAllPois()
    } else {
      layer?.hideAllPois()
    }
  }
  
  private func createPoiStyle(styleID: String, imageName: String) {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil.")
      return
    }
    let labelManager = mapView.getLabelManager()
    
    if let image = UIImage(named: imageName) {
      let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
      let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
      let poiStyle = PoiStyle(styleID: styleID, styles: [perLevelStyle])
      labelManager.addPoiStyle(poiStyle)
      print("POI Style created with styleID: \(styleID) and imageName: \(imageName)")
    } else {
      print("Error: \(imageName) 이미지 로드 실패")
    }
  }
  
  private func createPoi(poiData: [PoiData], layerID: String, styleID: String) {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      return
    }
    
    let labelManager = mapView.getLabelManager()
    
    guard let layer = labelManager.getLabelLayer(layerID: layerID) else {
      return
    }
    
    layer.clearAllItems()
    
    for poi in poiData {
      let options = PoiOptions(styleID: styleID, poiID: "\(poi.id)")
      let point = MapPoint(longitude: poi.longitude, latitude: poi.latitude)
      
      if let poiItem = layer.addPoi(option: options, at: point) {
        poiItem.clickable = true
        poiItem.show()
        print("Success: POI added for \(styleID) ID: \(poi.id) at (\(poi.longitude), \(poi.latitude))")
      } else {
        print("Error: Failed to add POI for \(styleID) ID: \(poi.id) at (\(poi.longitude), \(poi.latitude))")
      }
    }
  }
  
  private func setupPoi(styleID: String, imageName: String, layerID: String, poiData: [any PoiData]) {
    createPoiStyle(styleID: styleID, imageName: imageName)
    createPoi(poiData: poiData, layerID: layerID, styleID: styleID)
  }
  
  private func bindViewModel() {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil in bindViewModel.")
      return
    }
    
    guard let _ = mapView.getLabelManager().getLabelLayer(layerID: "shelterLayer"),
          let _ = mapView.getLabelManager().getLabelLayer(layerID: "aedLayer"),
          let _ = mapView.getLabelManager().getLabelLayer(layerID: "notificationLayer") else {
      return
    }
    
    // POI 스타일 설정
    setupPoi(styleID: "shelterStyle", imageName: "ShelterMarker.png", layerID: "shelterLayer", poiData: ShelterData.shared.setShelters().map { $0 as any PoiData })
    setupPoi(styleID: "aedStyle", imageName: "AEDMarker.png", layerID: "aedLayer", poiData: AedData.shared.setAeds().map { $0 as any PoiData })
    setupPoi(styleID: "notificationStyle", imageName: "NotificationMarker.png", layerID: "notificationLayer", poiData: NotificationData.shared.setNotifications().map { $0 as any PoiData })
  }

}

class PoiViewModel {
  private let disposeBag = DisposeBag()
  //Input : poi 클릭 이벤트
  let poiTappedHandler = PublishSubject<PoiData>()
  
  //Output : poi 클릭시 뷰 전환
  var poiBottomSheet: Observable<PoiData> {
    return poiTappedHandler.asObservable()
  }
  
  init() {
    poiBottomSheet
      .subscribe(onNext: { poiData in
        //        self.showPoiBottomSheet(poiData)
      })
      .disposed(by: disposeBag)
  }
  
  func showPoiBottomSheet(_ poiData: PoiData) {
    // MapBottomSheetViewController 인스턴스 생성
    let mapBottomSheet = MapBottomSheetViewController()
    
    // panelContentsViewController의 인스턴스를 가져옵니다.
    if let panelContentsViewController = mapBottomSheet.panelContentsViewController {
      // POI 데이터 업데이트
      panelContentsViewController.updatePoiData(with: poiData)
    }
    
    // 최상위 뷰 컨트롤러를 가져와서 mapBottomSheet을 표시합니다.
    guard let topViewController = UIApplication.shared.windows.first?.rootViewController else {
      return
    }
    topViewController.present(mapBottomSheet, animated: true, completion: nil)
  }
}
