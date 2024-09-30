//
//  OfflineMapViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import CoreLocation

import RxCocoa
import RxSwift

class OfflineMapViewModel: NSObject {
  private let coreDataManager = CoreDataManager.shared
  private let disposeBag = DisposeBag()
  
  // CLLocationManager 인스턴스 추가
  private let locationManager = CLLocationManager()
  
  // View에 노출할 POI 데이터
  // 각각의 POI 데이터
  private let originalAedAnnotations = BehaviorRelay<[CustomPointAnnotation]>(value: [])
  private let originalCivilDefenseAnnotations = BehaviorRelay<[CustomPointAnnotation]>(value: [])
  private let originalDisasterAnnotations = BehaviorRelay<[CustomPointAnnotation]>(value: [])
  
  let aedAnnotations = BehaviorRelay<[CustomPointAnnotation]>(value: [])
  let civilDefenseAnnotations = BehaviorRelay<[CustomPointAnnotation]>(value: [])
  let disasterAnnotations = BehaviorRelay<[CustomPointAnnotation]>(value: [])
  
  // 현재 위치를 저장하는 BehaviorRelay
  let currentLocation = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
  
  // POI 표시 여부를 제어하는 Relay
  let aedVisible = BehaviorRelay<Bool>(value: true)
  let civilDefenseVisible = BehaviorRelay<Bool>(value: true)
  let disasterVisible = BehaviorRelay<Bool>(value: true)
  
  override init() {
    super.init()
    bindPOIVisibility()
    fetchPOIData()
    setupLocationManager()
  }
  
  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  private func fetchPOIData() {
    coreDataManager.fetchAEDs()
      .map { aeds -> [CustomPointAnnotation] in
        return aeds.map { aed in
          let annotation = CustomPointAnnotation()
          annotation.coordinate = CLLocationCoordinate2D(latitude: aed.wgs84Lat, longitude: aed.wgs84Lon)
          annotation.title = aed.buildPlace
          annotation.subtitle = aed.buildAddress
          annotation.poiType = .aed
          return annotation
        }
      }
      .subscribe(onNext: { [weak self] annotations in
        self?.originalAedAnnotations.accept(annotations)
        self?.aedAnnotations.accept(annotations)
      })
      .disposed(by: disposeBag)
    
    coreDataManager.fetchCivilDefenseShelters()
      .map { shelters -> [CustomPointAnnotation] in
        return shelters.map { shelter in
          let annotation = CustomPointAnnotation()
          annotation.coordinate = CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude)
          annotation.title = shelter.fcltNm
          annotation.subtitle = shelter.fcltAddrLotno
          annotation.poiType = .civilDefenseShelter
          return annotation
        }
      }
      .subscribe(onNext: { [weak self] annotations in
        self?.originalCivilDefenseAnnotations.accept(annotations)
        self?.civilDefenseAnnotations.accept(annotations)
      })
      .disposed(by: disposeBag)
    
    coreDataManager.fetchDisasterShelters()
      .map { shelters -> [CustomPointAnnotation] in
        return shelters.map { shelter in
          let annotation = CustomPointAnnotation()
          annotation.coordinate = CLLocationCoordinate2D(latitude: shelter.lat, longitude: shelter.lot)
          annotation.title = shelter.reareNm
          annotation.subtitle = shelter.ronaDaddr
          annotation.poiType = .disasterShelter
          return annotation
        }
      }
      .subscribe(onNext: { [weak self] annotations in
        self?.originalDisasterAnnotations.accept(annotations)
        self?.disasterAnnotations.accept(annotations)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindPOIVisibility() {
    aedVisible
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] visible in
        if visible {
          self?.aedAnnotations.accept(self?.originalAedAnnotations.value ?? [])
        } else {
          self?.aedAnnotations.accept([])
        }
      })
      .disposed(by: disposeBag)
    
    civilDefenseVisible
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] visible in
        if visible {
          self?.civilDefenseAnnotations.accept(self?.originalCivilDefenseAnnotations.value ?? [])
        } else {
          self?.civilDefenseAnnotations.accept([])
        }
      })
      .disposed(by: disposeBag)
    
    disasterVisible
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] visible in
        if visible {
          self?.disasterAnnotations.accept(self?.originalDisasterAnnotations.value ?? [])
        } else {
          self?.disasterAnnotations.accept([])
        }
      })
      .disposed(by: disposeBag)
  }
}

extension OfflineMapViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else { return }
    self.currentLocation.accept(currentLocation.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("위치 업데이트 실패: \(error.localizedDescription)")
  }
}
