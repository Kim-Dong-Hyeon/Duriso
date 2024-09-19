//
//  OnlineViewModel.swift
//  Duriso
//
//  Created by 이주희 on 9/6/24.
//

import RxCocoa
import RxSwift
import KakaoMapsSDK

class OnlineViewModel {
  
  private let disposeBag = DisposeBag()
  private let poiViewModel = PoiViewModel.shared  // 싱글톤 인스턴스 사용
  
  
  private var mapController = KakaoMapViewController()
  
  // 버튼 상태를 나타내는 변수
  let shelterButtonSelected = BehaviorRelay<Bool>(value: true)
  let aedButtonSelected = BehaviorRelay<Bool>(value: true)
  let emergencyReportSelected = BehaviorRelay<Bool>(value: true)
  
  // Shelter 버튼 클릭 처리
  // 버튼 색상 처리 필요
  func toggleShelterButton(mapController: KMController?) {
    guard let mapController = mapController else { return }
    
    // 버튼 상태 토글
    let isSelected = !shelterButtonSelected.value
    shelterButtonSelected.accept(isSelected)
    
    // 상태에 따라 POI 표시/숨김
    if isSelected {
      poiViewModel.showShelters(mapController: mapController)
    } else {
      poiViewModel.hideShelters(mapController: mapController)
    }
  }
  
  // AED 버튼 클릭 처리
  // 버튼 색상 처리 필요
  func toggleAedButton(mapController: KMController) {
    // 버튼 상태 토글
    let isSelected = !aedButtonSelected.value
    aedButtonSelected.accept(isSelected)
    
    // 상태에 따라 POI 표시/숨김
    if isSelected {
      poiViewModel.showAeds(mapController: mapController)
    } else {
      poiViewModel.hideAeds(mapController: mapController)
    }
  }
  
  // 긴급제보 버튼 클릭 처리
  // 버튼 색상 처리 필요
  func toggleEmergencyReportButton(mapController: KMController) {
    // 버튼 상태 토글
    let isSelected = !emergencyReportSelected.value
    emergencyReportSelected.accept(isSelected)
    
    // 상태에 따라 POI 표시/숨김
    if isSelected {
      poiViewModel.showEmergencyReport(mapController: mapController)
    } else {
      poiViewModel.hideEmergencyReport(mapController: mapController)
    }
  }
}
