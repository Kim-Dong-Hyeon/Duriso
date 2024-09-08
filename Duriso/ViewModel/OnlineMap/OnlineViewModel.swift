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
  private let poiViewModel = PoiViewModel()
  
  // 버튼 상태를 나타내는 변수
  let shelterButtonSelected = BehaviorRelay<Bool>(value: true)
  let aedButtonSelected = BehaviorRelay<Bool>(value: true)
  let emergencyReportSelected = BehaviorRelay<Bool>(value: true)
  
  // UI 요소에 바인딩할 변수 (예: 상태 텍스트를 표시하는 레이블)
  let toggleLabel = BehaviorRelay<String>(value: "버튼 상태")
  
  // Shelter 버튼 클릭 처리
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
    
    // 버튼 상태를 레이블에 바인딩
    toggleLabel.accept("Shelter 버튼이 현재 선택되어있는지? -> \(isSelected)")
  }
  
  // AED 버튼 클릭 처리
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
    
    // 버튼 상태를 레이블에 바인딩
    toggleLabel.accept("AED 버튼이 현재 선택되어있는지? -> \(isSelected)")
  }
  
  // 긴급제보 버튼 클릭 처리
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
    
    // 버튼 상태를 레이블에 바인딩
    toggleLabel.accept("Emergency Report 버튼이 현재 선택되어있는지? -> \(isSelected)")
  }
}
