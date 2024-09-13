//
//  OfflineMapViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import MapLibre
import RxCocoa
import RxSwift

class OfflineMapViewModel {
  // Inputs
  let didTapRequestPreciseLocation = PublishRelay<Void>()
  let didTapCreateSnapshot = PublishRelay<Void>()
  
  // Outputs
  let locationAccuracy = BehaviorRelay<LocationAccuracyState>(value: .unknown)
  let showTemporaryLocationAuthorization = BehaviorRelay<Bool>(value: false)
  let currentLocation = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
  let shouldShowRequestButton: Observable<Bool>
  let mapSnapshot = PublishRelay<MapSnapshot>()
  let isloadingSnapshot = BehaviorRelay<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  init() {
    shouldShowRequestButton = locationAccuracy.map { $0 == .reducedAccuracy }
    
    didTapRequestPreciseLocation
      .bind { [weak self] in
        self?.showTemporaryLocationAuthorization.accept(true)
      }
      .disposed(by: disposeBag)
  }
  
  func updateLocationAccuracy(_ accuracy: LocationAccuracyState) {
    DispatchQueue.main.async {
      self.locationAccuracy.accept(accuracy)
    }
  }
  
  func updateCurrentLocation(_ location: CLLocationCoordinate2D) {
    DispatchQueue.main.async {
      self.currentLocation.accept(location)
    }
  }
  
  func getMapTilerkey() -> String {
    guard let mapTilerKey = Bundle.main.object(forInfoDictionaryKey: "MAPTILER_API_KEY") as? String else {
      fatalError("Failed to read MapTiler key from info.plist")
    }
    validateKey(mapTilerKey)
    return mapTilerKey
  }
  
  private func validateKey(_ mapTilerKey: String) {
    if mapTilerKey.compare("placeholder", options: .caseInsensitive) == .orderedSame {
      fatalError("Please enter correct MapTiler key in info.plist[MAPTILER_API_KEY] property")
    }
  }
  
  func createSnapshot(with options: MLNMapSnapshotOptions) {
    print("Starting snapshot creation")
    isloadingSnapshot.accept(true)
    let snapshotter = MLNMapSnapshotter(options: options)
    snapshotter.start { [weak self] snapshot, error in
      print("Snapshot creation completed")
      self?.isloadingSnapshot.accept(false)
      if let error = error {
        print("맵 스냅샷 생성 불가: \(error.localizedDescription)")
      } else if let snapshot = snapshot {
        print("Snapshot created 성공")
        self?.mapSnapshot.accept(MapSnapshot(image: snapshot.image))
      }
    }
  }
}
