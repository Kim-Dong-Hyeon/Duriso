//
//  PaneltContentsViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import SnapKit
import Then

class PaneltContentsViewController: UIViewController {
  
  internal let poiViewTitle = UILabel().then {
    $0.text = "서울시청 무더위 대피소"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head2.font()
  }
  
  private let poiViewType = UILabel().then {
    $0.text = "대피소 종류"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.sub2.font()
  }
  
  private let poiViewAddress = UILabel().then {
    $0.text = "서울특별시 00구 00동 00로 000"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body2.font()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
  }
  
  func setupView() {
    [
      poiViewTitle,
      poiViewType,
      poiViewAddress
    ].forEach { view.addSubview($0) }
  }
  
  func setupConstraints() {
    poiViewTitle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    poiViewAddress.snp.makeConstraints {
      $0.top.equalTo(poiViewTitle.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    poiViewType.snp.makeConstraints{
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(poiViewTitle.snp.trailing).offset(24)

    }
  }
  
  func updatePoiData(with poiData: PoiData) {
    // 공통된 속성 업데이트
    poiViewTitle.text = poiData.id
    poiViewAddress.text = poiData.address
    
    // 타입에 따라 적절한 추가 정보를 설정합니다.
    if let shelter = poiData as? Shelter {
      poiViewType.text = "Shelter - Capacity: \(shelter.capacity)"
    } else if let aed = poiData as? Aed {
      poiViewType.text = "AED - Capacity: \(aed.capacity)"
    } else if let notification = poiData as? Notification {
      poiViewType.text = "Notification - Capacity: \(notification.capacity)"
    } else {
      poiViewType.text = "Unknown Type"
    }
  }
}


@available(iOS 17.0, *)
#Preview { PaneltContentsViewController() }
