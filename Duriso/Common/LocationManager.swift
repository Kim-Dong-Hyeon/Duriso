//
//  LocationManager.swift
//  Duriso
//
//  Created by 김동현 on 9/4/24.
//

import Foundation
import CoreLocation

/// 위치 관리름 담당하는 싱글톤 클래스
class LocationManager: NSObject, CLLocationManagerDelegate {
  /// 싱글톤 인스턴스
  static let shared = LocationManager()
  
  /// Core Location 매니저 인스턴스
  private let locationManager = CLLocationManager()
  /// 현재 위치 정보
  var currentLocation: CLLocation?
  /// 위치 업데이트 시 호출될 클로저
  var onLocationUpdate: ((Double, Double) -> Void)?
  /// 위치 권한 상태 변경 시 호출될 클로저
  var onAuthorizationChange: ((CLAuthorizationStatus) -> Void)?
  
  /// 초기화 메서드
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  /// 위치 권한 요청
  func requestAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  /// 위치 업데이트 시작
  func startUpdatingLocation() {
    checkAuthorizationStatus()
    locationManager.startUpdatingLocation()
  }
  
  /// 위치 업데이트 중지
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  /// 위치 권한 상태 확인 및 처리
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
  
  // 위치 업데이트 시 호출되는 델리게이트 메서드
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    currentLocation = location
    print("현재 위치 업데이트: \(latitude), \(longitude)")
    onLocationUpdate?(latitude, longitude)
  }
  
  // 위치 권한 상태 변경 시 호출되는 델리게이트 메서드
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    onAuthorizationChange?(status)
    checkAuthorizationStatus()
  }
  
}
