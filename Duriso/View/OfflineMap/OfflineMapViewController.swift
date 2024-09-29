//
//  OfflineMapViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import MapLibre
import RxCocoa
import RxSwift
import SnapKit
import Then

class OfflineMapViewController: UIViewController {
  let viewModel = OfflineMapViewModel()
  private var mapView: MLNMapView!
  private let disposeBag = DisposeBag()
  private var hasSetInitialZoom = false // 초기 줌 레벨 설정 여부를 추적
  
  // 현재 위치 버튼 추가
  private lazy var currentLocationButton = UIButton(type: .custom).then {
    $0.setImage(UIImage(named: "locationButton"), for: .normal) // 적절한 위치 아이콘 이미지 사용
    $0.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMapView()
    setupCurrentLocationButton()
    bindViewModel()
  }
  
  private func setupMapView() {
    
    mapView = MLNMapView().then {
      $0.styleURL = URL(string: "https://api.maptiler.com/maps/streets/style.json?key=\(Environment.mapTilerApiKey)") // 스타일 URL 설정
      $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      $0.setCenter(CLLocationCoordinate2D(latitude: 37.566535, longitude: 126.977969), zoomLevel: 13, animated: false)
      $0.showsUserLocation = true
      $0.delegate = self
    }
    
    [ mapView ].forEach { view.addSubview($0) }
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupCurrentLocationButton() {
    [ currentLocationButton ].forEach { view.addSubview($0) }
    
    currentLocationButton.snp.makeConstraints {
      $0.width.height.equalTo(40)
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(110)
    }
  }
  
  private func bindViewModel() {
    
    // AEDs 데이터 바인딩
    viewModel.aedAnnotations
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] annotations in
        self?.updateMapAnnotations(annotations: annotations, poiType: .aed)
      })
      .disposed(by: disposeBag)
    
    // CivilDefenseShelters 데이터 바인딩
    viewModel.civilDefenseAnnotations
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] annotations in
        self?.updateMapAnnotations(annotations: annotations, poiType: .civilDefenseShelter)
      })
      .disposed(by: disposeBag)
    
    // DisasterShelters 데이터 바인딩
    viewModel.disasterAnnotations
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] annotations in
        self?.updateMapAnnotations(annotations: annotations, poiType: .disasterShelter)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateMapAnnotations(annotations: [CustomPointAnnotation], poiType: POIType) {
    // 먼저 기존의 해당 POIType에 대한 Annotation을 제거
    mapView.annotations?.compactMap { $0 as? CustomPointAnnotation }
      .filter { $0.poiType == poiType }
      .forEach { mapView.removeAnnotation($0) }
    
    // 새로 추가된 Annotation을 지도에 표시
    annotations.forEach { mapView.addAnnotation($0) }
  }
  
  private func showAedDetails(annotation: CustomPointAnnotation) {
    // CoreData에서 AED 정보를 가져옴
    guard let aed = CoreDataManager.shared.searchAED(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude) else {
      print("AED 정보를 찾을 수 없습니다.")
      return
    }
    
    // AedViewController 인스턴스 생성 및 데이터 설정
    let aedViewController = OfflineAEDViewController()
    aedViewController.poiName = aed.buildPlace
    aedViewController.poiAddress = aed.buildAddress
    aedViewController.adminName = aed.manager
    aedViewController.adminNumber = aed.managerTel
    aedViewController.managementAgency = aed.org
    aedViewController.location = aed.buildPlace
    
    // BottomSheet로 표시
    presentBottomSheet(viewController: aedViewController)
  }
  
  private func showCivilDefenseShelterDetails(annotation: CustomPointAnnotation) {
    // CoreData에서 CivilDefenseShelters 정보를 가져옴
    guard let shelter = CoreDataManager.shared.searchCivilDefenseShelter(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude) else {
      print("Civil Defense Shelter 정보를 찾을 수 없습니다.")
      return
    }
    
    // ShelterViewController 인스턴스 생성 및 데이터 설정
    let shelterViewController = OfflineCivilDefenseShelterViewController()
    shelterViewController.poiName = shelter.fcltNm
    shelterViewController.poiAddress = shelter.fcltAddrLotno
    shelterViewController.typeStackView.layer.borderColor = UIColor.CYellow.cgColor
    shelterViewController.typeStackView.distribution = .fillProportionally
    shelterViewController.typeLogo.image = UIImage(systemName: "figure.run")
    shelterViewController.typeLogo.tintColor = .CYellow
    shelterViewController.typeLabel.text = "민방위대피소"
    shelterViewController.typeLabel.textColor = .CYellow
    shelterViewController.poiType = "민방위대피소"
    shelterViewController.poiLat = shelter.latitude
    shelterViewController.poiLon = shelter.longitude
    shelterViewController.poiScale = Int(shelter.fcltScl)
    shelterViewController.poiUnit = shelter.sclUnit
    shelterViewController.poiUsualType = shelter.ortmUtlzType
    shelterViewController.poiInstName = shelter.mngInstNm
    shelterViewController.poiInstTel = shelter.mngInstTelno
    
    
    
    // BottomSheet로 표시
    presentBottomSheet(viewController: shelterViewController)
  }
  
  private func showDisasterShelterDetails(annotation: CustomPointAnnotation) {
    // CoreData에서 DisasterShelters 정보를 가져옴
    guard let shelter = CoreDataManager.shared.searchDisasterShelter(lat: annotation.coordinate.latitude, lon: annotation.coordinate.longitude) else {
      print("Disaster Shelter 정보를 찾을 수 없습니다.")
      return
    }
    
    // ShelterViewController 인스턴스 생성 및 데이터 설정
    let shelterViewController = OfflineDisasterShelterViewController()
    shelterViewController.poiName = shelter.reareNm
    shelterViewController.poiAddress = shelter.ronaDaddr
    shelterViewController.poiType = shelter.shltSeNm
    shelterViewController.poiLat = shelter.lat
    shelterViewController.poiLon = shelter.lot
    
    // BottomSheet로 표시
    presentBottomSheet(viewController: shelterViewController)
  }
  
  private func presentBottomSheet(viewController: UIViewController) {
    let bottomSheetVC = MapBottomSheetViewController()
    bottomSheetVC.configureContentViewController(viewController)
    present(bottomSheetVC, animated: true)
  }
  
  @objc private func didTapCurrentLocationButton() {
    guard let coordinate = viewModel.currentLocation.value else {
      print("현재 위치를 가져올 수 없습니다.")
      return
    }
    
    // 버튼을 눌렀을 때 현재 위치로 카메라 이동
    mapView.setCenter(coordinate, zoomLevel: 16, animated: false)
  }
}

extension OfflineMapViewController: MLNMapViewDelegate {
  // 커스텀 이미지로 POI 표시
  func mapView(_ mapView: MLNMapView, imageFor annotation: MLNAnnotation) -> MLNAnnotationImage? {
    guard let customAnnotation = annotation as? CustomPointAnnotation,
          let poiType = customAnnotation.poiType else {
      return nil
    }
    
    var imageName: String
    
    switch poiType {
    case .aed:
      imageName = "AEDMarker"
    case .civilDefenseShelter:
      imageName = "CivilDefenseMarker"
    case .disasterShelter:
      imageName = "ShelterMarker"
    }
    
    var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: imageName)
    
    if annotationImage == nil {
      if let image = UIImage(named: imageName)?.resized(to: CGSize(width: 37, height: 50)) {
        annotationImage = MLNAnnotationImage(image: image, reuseIdentifier: imageName)
      }
    }
    
    return annotationImage
  }
  
  func mapView(_ mapView: MLNMapView, didSelect annotation: MLNAnnotation) {
    guard let customAnnotation = annotation as? CustomPointAnnotation else { return }
    
    switch customAnnotation.poiType {
    case .aed:
      showAedDetails(annotation: customAnnotation)
    case .civilDefenseShelter:
      showCivilDefenseShelterDetails(annotation: customAnnotation)
    case .disasterShelter:
      showDisasterShelterDetails(annotation: customAnnotation)
    default:
      break
    }
  }
  
  // 사용자의 위치 업데이트 시 호출되는 메서드
  func mapView(_ mapView: MLNMapView, didUpdate userLocation: MLNUserLocation?) {
    guard let location = userLocation?.location?.coordinate, !hasSetInitialZoom else { return }
    
    // 초기 줌 레벨을 16으로 설정
    mapView.setCenter(location, zoomLevel: 16, animated: false)
    hasSetInitialZoom = true // 초기 줌 레벨이 설정되었음을 기록
  }
}
