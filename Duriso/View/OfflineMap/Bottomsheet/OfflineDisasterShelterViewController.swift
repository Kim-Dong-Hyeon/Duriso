//
//  OfflineDisasterShelterViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/29/24.
//

import UIKit

import SnapKit
import Then

class OfflineDisasterShelterViewController: ShelterViewController {
  
  var poiLat: Double?
  var poiLon: Double?
  
  private let latLabel = UILabel().then {
    $0.text = "위도 정보 받아오는 중.."
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body2.font()
    $0.numberOfLines = 1
  }
  
  private let lonLabel = UILabel().then {
    $0.text = "경도 정보 받아오는 중.."
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body2.font()
    $0.numberOfLines = 1
  }
  
  override func setupView() {
    super.setupView()
    [
      latLabel,
      lonLabel
    ].forEach { view.addSubview($0) }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    latLabel.snp.makeConstraints {
      $0.top.equalTo(shelterAddress.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    lonLabel.snp.makeConstraints {
      $0.top.equalTo(latLabel.snp.bottom).offset(10)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
  }
  
  override func updatePoiData() {
    super.updatePoiData()
    latLabel.text = "위도: \(poiLat ?? 0.0)"
    lonLabel.text = "경도: \(poiLon ?? 0.0)"
  }
}
