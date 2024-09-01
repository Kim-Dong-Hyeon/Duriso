//
//  OnlineMapView.swift
//  Duriso
//
//  Created by 이주희 on 9/1/24.
//


import UIKit
import KakaoMapsSDK

// ViewController 클래스는 UIViewController를 상속하고 MapControllerDelegate 프로토콜을 채택합니다.
class OnlineMapView: UIViewController, MapControllerDelegate {
  
  // 지도 컨테이너를 관리하는 변수, Kakao Maps SDK에서 제공하는 KMViewContainer 타입입니다.
  var mapContainer: KMViewContainer?
  
  // 지도 컨트롤러를 관리하는 변수, Kakao Maps SDK에서 제공하는 KMController 타입입니다.
  var mapController: KMController?
  
  // 옵저버가 추가되었는지를 나타내는 플래그 변수
  var _observerAdded: Bool
  
  // 인증 상태를 나타내는 플래그 변수
  var _auth: Bool
  
  // 뷰가 화면에 나타났는지를 나타내는 플래그 변수
  var _appear: Bool
  
  init() {
    _observerAdded = false
    _auth = false
    _appear = false
    super.init(nibName: nil, bundle: nil)
  }
  
  // 초기화 메서드, NSCoder로부터 초기화가 필요할 때 호출됩니다.
  required init?(coder aDecoder: NSCoder) {
    // 플래그 변수 초기화
    _observerAdded = false
    _auth = false
    _appear = false
    super.init(coder: aDecoder)
  }
  
  // loadView는 UIViewController의 뷰를 수동으로 설정할 때 사용됩니다.
  override func loadView() {
    // KMViewContainer의 프레임을 화면 크기로 설정하여 초기화합니다.
    let kmViewContainer = KMViewContainer(frame: UIScreen.main.bounds)
    
    // 뷰 컨트롤러의 뷰를 kmViewContainer로 설정합니다.
    self.view = kmViewContainer
    
    // mapContainer에 kmViewContainer를 할당합니다.
    self.mapContainer = kmViewContainer
  }
  
  // viewDidLoad는 뷰가 메모리에 로드된 후 호출되는 메서드입니다.
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // mapContainer가 nil이 아닌 경우, KMController를 생성하고 초기화합니다.
    if let mapContainer = mapContainer {
      // KMController 객체 생성 및 초기화
      mapController = KMController(viewContainer: mapContainer)
      mapController?.delegate = self  // 현재 클래스(ViewController)를 델리게이트로 설정
      mapController?.prepareEngine()  // 엔진을 준비합니다 (초기화 작업)
    }
    
    // 앱 상태 변화에 대한 옵저버 추가
    addObservers()
  }
  
  // deinit은 객체가 메모리에서 해제될 때 호출됩니다.
  deinit {
    mapController?.pauseEngine()  // 엔진을 일시 정지합니다.
    mapController?.resetEngine()  // 엔진을 리셋합니다.
    removeObservers()  // 앱 상태 변화에 대한 옵저버 제거
    print("deinit")
  }
  
  // viewWillAppear는 뷰가 화면에 나타나기 직전에 호출됩니다.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _appear = true  // 뷰가 나타났음을 표시
    
    // 엔진이 활성화되어 있지 않다면 활성화합니다.
    if mapController?.isEngineActive == false {
      mapController?.activateEngine()
    }
  }
  
  // viewWillDisappear는 뷰가 화면에서 사라지기 직전에 호출됩니다.
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    _appear = false  // 뷰가 사라졌음을 표시
    mapController?.pauseEngine()  // 엔진을 일시 정지합니다.
  }
  
  // viewDidDisappear는 뷰가 화면에서 완전히 사라진 후에 호출됩니다.
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    mapController?.resetEngine()  // 엔진을 리셋합니다.
    removeObservers()  // 앱 상태 변화에 대한 옵저버 제거
  }
  
  // 인증 실패 시 호출되는 메서드
  func authenticationFailed(_ errorCode: Int, desc: String) {
    print("error code: \(errorCode)")  // 오류 코드 출력
    print("desc: \(desc)")  // 오류 설명 출력
    _auth = false  // 인증 상태를 실패로 설정
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
      
      // 인증 실패 후 5초 뒤에 재시도합니다.
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        print("retry auth...")
        self.mapController?.prepareEngine()
      }
    default:
      break
    }
  }
  
  // 지도 뷰를 추가하는 메서드
  func addViews() {
    // 기본 위치 설정
    let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
    
    // 지도 뷰를 그리기 위한 정보 생성
    let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
    
    // 지도 뷰를 추가
    mapController?.addView(mapviewInfo)
  }
  
  // addView 성공 이벤트 delegate 메서드
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    print("OK")  // 뷰 추가 성공 시 메시지 출력
  }
  
  // addView 실패 이벤트 delegate 메서드
  func addViewFailed(_ viewName: String, viewInfoName: String) {
    print("Failed")  // 뷰 추가 실패 시 메시지 출력
  }
  
  // Container 뷰가 리사이즈 되었을 때 호출되는 메서드
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)  // 지도뷰의 크기를 리사이즈된 크기로 지정
  }
  
  // 뷰가 제거될 때 호출되는 메서드
  func viewWillDestroyed(_ view: ViewBase) {
    // 필요한 경우 추가 작업
  }
  
  // 앱 상태 변화에 대한 옵저버를 추가하는 메서드
  func addObservers(){
    NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    
    _observerAdded = true  // 옵저버가 추가되었음을 표시
  }
  
  // 앱 상태 변화에 대한 옵저버를 제거하는 메서드
  func removeObservers(){
    NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    
    _observerAdded = false  // 옵저버가 제거되었음을 표시
  }
  
  // 앱이 비활성화될 때 호출되는 메서드
  @objc func willResignActive(){
    mapController?.pauseEngine()  // 앱이 inactive 상태로 전환되는 경우 엔진을 일시 정지
  }
  
  // 앱이 활성화될 때 호출되는 메서드
  @objc func didBecomeActive(){
    mapController?.activateEngine()  // 앱이 active 상태가 되면 엔진을 활성화
  }
  
  // 메시지를 보여주는 토스트 메서드
  func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
    let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
    toastLabel.backgroundColor = UIColor.black
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center
    view.addSubview(toastLabel)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds  =  true
    
    // 토스트 메시지를 서서히 사라지게 애니메이션 처리
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

}

