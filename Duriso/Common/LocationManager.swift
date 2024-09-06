//
//  LocationManager.swift
//  Duriso
//
//  Created by 김동현 on 9/4/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
  static let shared = LocationManager()
  
  private let locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var onLocationUpdate: ((Double, Double) -> Void)?
  var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  // 위치 권한 요청
  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  // 위치 업데이트 시작
  func startUpdatingLocation() {
    checkAuthorizationStatus()
    locationManager.startUpdatingLocation()
  }
  
  // 위치 업데이트 중지
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  // 위치 권한 상태 확인
  private func checkAuthorizationStatus() {
    let status = locationManager.authorizationStatus
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      locationManager.startUpdatingLocation()
    case .notDetermined:
      requestAuthorization()
    case .restricted, .denied:
      // Handle restricted/denied status by showing an alert or other appropriate actions
      print("Location access denied.")
    @unknown default:
      break
    }
  }
  
  // 위치 업데이트 콜백
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    currentLocation = location
    print("현재 위치 업데이트: \(latitude), \(longitude)")
    onLocationUpdate?(latitude, longitude)
  }
  
  // 위치 권한 변경 콜백
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    onAuthorizationChange?(status)
    checkAuthorizationStatus()
  }
  
}
