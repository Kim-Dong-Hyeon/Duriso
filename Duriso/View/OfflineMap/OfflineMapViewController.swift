//
//  OfflineMapViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import MapLibre
import Photos
import RxCocoa
import RxSwift
import Then

class OfflineMapViewController: UIViewController {
  
  private var mapView: MLNMapView!
  private let viewModel: OfflineMapViewModel
  private var pannedToUserLocation = false
  private let disposeBag = DisposeBag()
  
//  private let requestButton = UIButton(type: .system).then {
//    $0.setTitle("Request Precise Location", for: .normal)
//    $0.backgroundColor = .CBlue
//    $0.setTitleColor(.CWhite, for: .normal)
//    $0.layer.cornerRadius = 8
//  }
  
  private let snapshotButton = UIButton(type: .system).then {
    $0.backgroundColor = .CWhite
    $0.isUserInteractionEnabled = true
    $0.layer.borderColor = UIColor.CBlack.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 10
    $0.setImage(UIImage(systemName: "camera"), for: .normal)
    $0.tintColor = .CBlack
  }
  
  private let imageView = UIImageView().then {
    $0.backgroundColor = .CBlack
    $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private let activityIndicator = UIActivityIndicatorView(style: .large).then {
    $0.hidesWhenStopped = true
  }
  
  init(viewModel: OfflineMapViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMapView()
    setupUI()
    setupBindings()
  }
  
  private func setupUI() {
    [
      mapView,
//      requestButton,
      snapshotButton,
      imageView,
      activityIndicator
    ].forEach { view.addSubview($0) }
    
//    requestButton.snp.makeConstraints {
//      $0.centerX.equalToSuperview()
//      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
//      $0.width.equalTo(200)
//      $0.height.equalTo(44)
//    }
    
    snapshotButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(mapView.snp.bottom).offset(-150)
      $0.width.height.equalTo(40)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    activityIndicator.snp.makeConstraints {
      $0.center.equalTo(imageView)
    }
    
    snapshotButton.frame(forAlignmentRect: CGRect(x: mapView.bounds.width / 2 - 40, y: mapView.bounds.height - 40, width: 80, height: 30))
    
    imageView.frame(forAlignmentRect: CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2))
    
    activityIndicator.center = imageView.center
  }
  
  private func setupMapView() {
    let mapTilerKey = viewModel.getMapTilerkey()
    let styleURL = URL(string: "https://api.maptiler.com/maps/streets/style.json?key=\(mapTilerKey)")
    
    mapView = MLNMapView(frame: view.bounds, styleURL: styleURL)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.delegate = self
    mapView.setCenter(CLLocationCoordinate2D(latitude: 37.566535, longitude: 126.977969), zoomLevel: 6, animated: false)
    mapView.showsUserLocation = true
  }
  
  private func setupBindings() {
//    viewModel.shouldShowRequestButton
//      .observe(on: MainScheduler.asyncInstance)
//      .bind(to: requestButton.rx.isHidden)
//      .disposed(by: disposeBag)
    
//    requestButton.rx.tap
//      .observe(on: MainScheduler.asyncInstance)
//      .bind(to: viewModel.didTapRequestPreciseLocation)
//      .disposed(by: disposeBag)
    
    snapshotButton.rx.tap
      .observe(on: MainScheduler.asyncInstance)
      .do(onNext: { [weak self] in
        print("Snapshot button tapped")
        self?.view.endEditing(true)
      })
      .bind(to: viewModel.didTapCreateSnapshot)
      .disposed(by: disposeBag)
    
    viewModel.showTemporaryLocationAuthorization
      .observe(on: MainScheduler.asyncInstance)
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        self?.requestTemporaryFullAccuracyAuthorization()
      })
      .disposed(by: disposeBag)
    
    viewModel.currentLocation
      .observe(on: MainScheduler.asyncInstance)
      .compactMap { $0 }
      .take(1)
      .subscribe(onNext: { [weak self] location in
        self?.mapView.setCenter(location, zoomLevel: 14, animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.didTapCreateSnapshot
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] in
        print("Creating snapshot")
        guard let self = self else { return }
        let options = MLNMapSnapshotOptions(styleURL: self.mapView.styleURL, camera: self.mapView.camera, size: self.mapView.bounds.size)
        options.zoomLevel = self.mapView.zoomLevel
        self.viewModel.createSnapshot(with: options)
      })
      .disposed(by: disposeBag)
    
    viewModel.isloadingSnapshot
      .observe(on: MainScheduler.asyncInstance)
      .bind(to: activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    viewModel.mapSnapshot
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] snapshot in
        print("Updating image view with new snapshot")
        self?.imageView.image = snapshot.image
        self?.imageView.isHidden = false
        self?.saveSnapshotToPhotos(snapshot.image)
      })
      .disposed(by: disposeBag)
  }
  
  private func requestTemporaryFullAccuracyAuthorization() {
    let purposeKey = "MLNAccuracyAuthorizationDescription"
    mapView.locationManager?.requestTemporaryFullAccuracyAuthorization!(withPurposeKey: purposeKey)
    viewModel.showTemporaryLocationAuthorization.accept(false)
  }
  
  func saveSnapshotToPhotos(_ image: UIImage) {
    PHPhotoLibrary.requestAuthorization { status in
      guard status == .authorized else {
        print("사진 라이브러리 접근 권한이 없습니다.")
        return
      }
      
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {
      print("스냅샷 저장 중 오류 발생: \(error.localizedDescription)")
    } else {
      print("스냅샷이 사진 앱에 성공적으로 저장되었습니다.")
    }
  }
}

extension OfflineMapViewController: MLNMapViewDelegate {
  func mapView(_: MLNMapView, didFinishLoading style: MLNStyle) {
    let point = MLNPointAnnotation()
    point.coordinate = mapView.centerCoordinate
    
    let shapeSource = MLNShapeSource(identifier: "marker-source", shape: point, options: nil)
    let shapeLayer = MLNSymbolStyleLayer(identifier: "marker-style", source: shapeSource)
    
    if let image = UIImage(named: "house-icon") {
      style.setImage(image, forName: "home-symbol")
    }
    
    shapeLayer.iconImageName = NSExpression(forConstantValue: "home-symbol")
    
    style.addSource(shapeSource)
    style.addLayer(shapeLayer)
  }
  
  func mapView(_ mapView: MLNMapView, didUpdate userLocation: MLNUserLocation?) {
    guard let location = userLocation?.location?.coordinate else { return }
    viewModel.updateCurrentLocation(location)
  }
  
  func mapView(_ mapView: MLNMapView, didChangeLocationManagerAuthorization manager: MLNLocationManager) {
    guard let accuracyAuthorization = manager.accuracyAuthorization else { return }
    
    let newAccuracy: LocationAccuracyState
    switch accuracyAuthorization() {
    case .fullAccuracy:
      newAccuracy = .fullAccuracy
    case .reducedAccuracy:
      newAccuracy = .reducedAccuracy
    @unknown default:
      newAccuracy = .unknown
    }
    
    viewModel.updateLocationAccuracy(newAccuracy)
  }
}
