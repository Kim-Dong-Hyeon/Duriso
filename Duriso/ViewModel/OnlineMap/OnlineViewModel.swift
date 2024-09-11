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
    guard let mapController = mapController else {
      print("mapController is nil")
      return
    }
    
    // 버튼 상태 토글
    let isSelected = !shelterButtonSelected.value
    shelterButtonSelected.accept(isSelected)
    
    // 상태에 따라 POI 표시/숨김
    if isSelected {
      print("Shelter POIs 표시 중")
      poiViewModel.showShelters(mapController: mapController)
    } else {
      print("Shelter POIs 숨김")
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
      print("AED POIs 표시 중")
      poiViewModel.showAeds(mapController: mapController)
    } else {
      print("AED POIs 숨김")
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
      print("Emergency Report POIs 표시 중")
      poiViewModel.showEmergencyReport(mapController: mapController)
    } else {
      print("Emergency Report POIs 숨김")
      poiViewModel.hideEmergencyReport(mapController: mapController)
    }
  }
}
