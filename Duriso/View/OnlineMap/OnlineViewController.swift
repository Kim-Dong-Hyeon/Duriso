//
//  OnlineViewController.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import KakaoMapsSDK

class OnlineViewController: UIViewController, PoiViewModelDelegate {
  
  private let poiViewModel = PoiViewModel.shared
  private let disposeBag = DisposeBag()
  private let onlineMapViewController = KakaoMapViewController()
  private let viewModel = OnlineViewModel()
  
  private var mapBottomSheetViewController: MapBottomSheetViewController?
  var mapContainer: KMViewContainer?
  
  let addressView = UIStackView().then {
    $0.backgroundColor = .CWhite
    $0.axis = .horizontal
    $0.distribution = .fill
//    $0.layer.borderColor = UIColor.CBlack.cgColor
//    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 20
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowOpacity = 0.15
    $0.layer.shadowColor = UIColor.CBlack.cgColor
    $0.layer.shadowRadius = 4
    $0.layer.masksToBounds = false
  }
  
  let addressLabel = UILabel().then {
    $0.backgroundColor = .CWhite
    $0.text = "위치 확인 중..."
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.adjustsFontSizeToFitWidth = true
    $0.font = CustomFont.Head3.font()
  }
  
  let addressRefreshButton = UIButton().then {
    $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
    $0.tintColor = .CBlack
  }
  
  let buttonStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.axis = .horizontal
    $0.spacing = 8
  }
  
  lazy var currentLocationButton = UIButton().then {
    $0.setImage(UIImage(named: "locationButton"), for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
  }
  
  let writingButton = UIButton().then {
    $0.setImage(UIImage(named: "writingButton"), for: .normal)
    $0.addTarget(self, action: #selector(didTapWritingButton), for: .touchUpInside)
  }
  
  lazy var shelterButton: UIButton = createButton(
    title: "대피소",
    symbolName: "figure.run",
    baseColor: .CLightBlue,
    selectedColor: .CGreen
  )
  
  lazy var aedButton: UIButton = createButton(
    title: "제세동기",
    symbolName: "bolt.heart.fill",
    baseColor: .CLightBlue,
    selectedColor: .CRed
  )
  
  lazy var emergencyReportButton: UIButton = createButton(
    title: "긴급제보",
    symbolName: "megaphone.fill",
    baseColor: .CLightBlue,
    selectedColor: .CBlue
  )
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
    setupConstraints()
    setupButtonBindings()
    
    poiViewModel.delegate = self
    print("OnlineViewController initialized with PoiViewModel: \(Unmanaged.passUnretained(poiViewModel).toOpaque())")
    
    
    // 위치 업데이트 콜백 설정
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.updatePlaceNameLabel(latitude: latitude, longitude: longitude)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // 위치 업데이트 시작
    LocationManager.shared.startUpdatingLocation()
    
  }
  
  
  func setupViews() {
    
    addChild(onlineMapViewController)
    view.addSubview(onlineMapViewController.view)
    onlineMapViewController.didMove(toParent: self)
    
    [
      addressView,
      currentLocationButton,
      buttonStackView,
      writingButton
    ].forEach { view.addSubview($0) }
    
    [
      shelterButton,
      aedButton,
      emergencyReportButton
    ].forEach { buttonStackView.addArrangedSubview($0) }
    
    [
      addressLabel,
      addressRefreshButton
    ].forEach { addressView.addSubview($0) }
  }
  
  func setupConstraints() {
    onlineMapViewController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addressView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(80)
      $0.width.equalTo(280)
      $0.height.equalTo(40)
    }
    
    addressLabel.snp.makeConstraints {
      $0.centerY.equalTo(addressView)
      $0.leading.equalTo(addressView).offset(8)
      $0.trailing.equalTo(addressRefreshButton.snp.leading).offset(-8)
    }
    
    addressRefreshButton.snp.makeConstraints {
      $0.centerY.equalTo(addressView)
      $0.trailing.equalTo(addressView).offset(-10)
      $0.width.height.equalTo(16)
    }
    
    currentLocationButton.snp.makeConstraints{
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(writingButton.snp.top).offset(-8)
      $0.width.height.equalTo(40)
    }
    writingButton.snp.makeConstraints{
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(buttonStackView.snp.top).offset(-16)
      $0.width.height.equalTo(40)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-96)
    }
    
    shelterButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
    
    aedButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
    
    emergencyReportButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
  }
  
  
  
  func createButton(title: String, symbolName: String, baseColor: UIColor, selectedColor: UIColor)
  -> UIButton {
    
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: symbolName), for: .normal)
    button.tintColor = .CWhite
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = CustomFont.Body3.font()
    button.setTitleColor(.CWhite, for: .normal)
    button.backgroundColor = selectedColor
    
    button.isSelected = false
    button.layer.cornerRadius = 17
    
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 4)
    button.layer.shadowRadius = 4
    button.layer.shadowOpacity = 0.2
    button.layer.masksToBounds = false
    
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    
    button.isSelected = false
    return button
  }
  
  // 위치에 따라 주소 레이블을 업데이트하는 메서드
  func updatePlaceNameLabel(latitude: Double, longitude: Double) {
    let regionFetcher = RegionFetcher()
    regionFetcher.fetchRegion(longitude: longitude, latitude: latitude) {
      [weak self] documents, error in guard let self = self else { return }
      if let document = documents?.first {
        DispatchQueue.main.async {
          self.addressLabel.text = document.addressName
        }
        print("Your Location is: \(document.addressName)")
      }
      if let error = error {
        print("Error fetching region: \(error)")
        return
      }
    }
  }
  
  private func setupButtonBindings() {
    
    // Shelter 버튼
    bindButtonTap(for: shelterButton) { [weak self] in
      guard let self = self else { return }
      self.viewModel.toggleShelterButton(mapController: self.onlineMapViewController.mapController!)
    }
    
    // AED 버튼
    bindButtonTap(for: aedButton) { [weak self] in
      guard let self = self else { return }
      self.viewModel.toggleAedButton(mapController: self.onlineMapViewController.mapController!)
    }
    
    // emergencyReportButton
    bindButtonTap(for: emergencyReportButton) { [weak self] in
      guard let self = self else { return }
      self.viewModel.toggleEmergencyReportButton(mapController: self.onlineMapViewController.mapController!)
    }
  }
  
  /// 버튼의 tap 이벤트와 액션을 바인딩하는 함수
  /// - Parameters:
  ///   - button: Rx 이벤트를 바인딩할 UIButton
  ///   - toggleAction: 버튼이 눌렸을 때 실행할 액션
  private func bindButtonTap(for button: UIButton, toggleAction: @escaping () -> Void) {
    button.rx.tap
      .bind {
        toggleAction()
      }
      .disposed(by: disposeBag)
  }
  
  @objc private func didTapCurrentLocationButton() {
    // Handle the writing button tap action here
    print("CurrentLocation button tapped")
    // 현재 위치로 이동하는 메서드
    if let currentLocation = LocationManager.shared.currentLocation {
      let latitude = currentLocation.coordinate.latitude
      let longitude = currentLocation.coordinate.longitude
      onlineMapViewController.updateCurrentLocation(latitude: latitude, longitude: longitude)
      onlineMapViewController.moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
      updatePlaceNameLabel(latitude: latitude, longitude: longitude)
    } else {
      LocationManager.shared.startUpdatingLocation()
    }
  }
  
  @objc private func didTapWritingButton() {
    presentMapBottomSheet(with: .emergencyReport)
    print("Writing button tapped")
  }
  
  func presentMapBottomSheet(with type: BottomSheetType) {
    print("Presenting BottomSheet of type: \(type)")  // 바텀시트 타입 로그 출력
    
    // BottomSheetViewController를 타입과 함께 초기화
    let bottomSheetVC = MapBottomSheetViewController(type: type)
    
    // BottomSheet 표시
    if let sheetPresentationController = bottomSheetVC.sheetPresentationController {
      if #available(iOS 16.0, *) {
        // Custom detent 설정
        if type == .emergencyReport {
          let customDetent = UISheetPresentationController.Detent.custom(identifier: UISheetPresentationController.Detent.Identifier("uniqueCustomIdentifier")) { context in
            let value = context.maximumDetentValue * 0.3
            print("Custom detent 높이: \(value)")
            return value
          }
          sheetPresentationController.detents = [customDetent]  // custom만 사용
          print("Custom detent 설정됨")
        } else {
          sheetPresentationController.detents = [.medium()]
          print("Medium detent 설정됨")
        }
      } else {
        sheetPresentationController.detents = [.medium()]
        print("Medium detent 설정됨 (iOS 16.0 미만)")
      }
      
      sheetPresentationController.prefersGrabberVisible = true
      sheetPresentationController.preferredCornerRadius = 15.0
    }
    
    present(bottomSheetVC, animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  OnlineViewController()
}
