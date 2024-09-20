//
//  OnlineViewModel.swift
//  Duriso
//
//  Created by 이주희 on 9/6/24.
//

import KakaoMapsSDK
import RxCocoa
import RxSwift

class OnlineViewModel {
  
  // MARK: - Properties
  
  private let disposeBag = DisposeBag()
  private let poiViewModel = PoiViewModel.shared  // 싱글톤 인스턴스 사용
  private var mapController = KakaoMapViewController()  // Kakao 지도 컨트롤러
  
  // 버튼 상태를 나타내는 변수
  let shelterButtonSelected = BehaviorRelay<Bool>(value: true)
  let aedButtonSelected = BehaviorRelay<Bool>(value: true)
  let emergencyReportSelected = BehaviorRelay<Bool>(value: true)
  
  // MARK: - Shelter 버튼 처리
  
  /// Shelter 버튼 클릭 시 상태를 토글하고 POI를 표시하거나 숨김
  /// - Parameter mapController: 현재 활성화된 Kakao 지도 컨트롤러
  func toggleShelterButton(mapController: KMController?) {
    guard let mapController = mapController else { return }
    
    // 버튼 상태 토글
    let isSelected = !shelterButtonSelected.value
    shelterButtonSelected.accept(isSelected)
    
    // 상태에 따라 Shelter POI 표시/숨김 처리
    if isSelected {
      poiViewModel.showShelters(mapController: mapController)
    } else {
      poiViewModel.hideShelters(mapController: mapController)
    }
  }
  
  // MARK: - AED 버튼 처리
  
  /// AED 버튼 클릭 시 상태를 토글하고 POI를 표시하거나 숨김
  /// - Parameter mapController: 현재 활성화된 Kakao 지도 컨트롤러
  func toggleAedButton(mapController: KMController) {
    // 버튼 상태 토글
    let isSelected = !aedButtonSelected.value
    aedButtonSelected.accept(isSelected)
    
    // 상태에 따라 AED POI 표시/숨김 처리
    if isSelected {
      poiViewModel.showAeds(mapController: mapController)
    } else {
      poiViewModel.hideAeds(mapController: mapController)
    }
  }
  
  // MARK: - 긴급제보 버튼 처리
  
  /// 긴급제보 버튼 클릭 시 상태를 토글하고 POI를 표시하거나 숨김
  /// - Parameter mapController: 현재 활성화된 Kakao 지도 컨트롤러
  func toggleEmergencyReportButton(mapController: KMController) {
    // 버튼 상태 토글
    let isSelected = !emergencyReportSelected.value
    emergencyReportSelected.accept(isSelected)
    
    // 상태에 따라 긴급제보 POI 표시/숨김 처리
    if isSelected {
      poiViewModel.showEmergencyReport(mapController: mapController)
    } else {
      poiViewModel.hideEmergencyReport(mapController: mapController)
    }
  }
}
