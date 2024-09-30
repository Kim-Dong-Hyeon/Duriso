//
//  LocationModel.swift
//  Duriso
//
//  Created by 김동현 on 9/13/24.
//

import CoreLocation
import RxSwift
import RxCocoa

class LocationModel: NSObject {
  private let locationManager = CLLocationManager()
  
  // 사용자의 현재 위치를 방출하는 Observable
  let currentLocation = BehaviorRelay<CLLocation?>(value: nil)
  
  override init() {
    super.init()
    setupLocationManager()
  }
  
  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
}

extension LocationModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    currentLocation.accept(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("위치 업데이트 실패: \(error.localizedDescription)")
  }
}
