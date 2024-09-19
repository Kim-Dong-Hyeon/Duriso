//
//  OfflineDetailViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/19/24.
//

import UIKit

import SnapKit
import Then

class DetailViewController: UIViewController {
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 10
    $0.alignment = .fill
    $0.distribution = .fillProportionally
  }
  
  init(item: Any) {
    super.init(nibName: nil, bundle: nil)
    setupUI()
    configureContent(with: item)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    [ scrollView ].forEach { view.addSubview($0) }
    [ contentView ].forEach { scrollView.addSubview($0) }
    [ stackView ].forEach { contentView.addSubview($0) }
    
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(20)
    }
  }
  
  private func configureContent(with item: Any) {
    switch item {
    case let aed as OfflineAED:
      addInfoRow("설치기관", aed.org, isTitle: true)
      addInfoRow("설치위치", aed.buildPlace)
      addInfoRow("주소", aed.buildAddress)
      addInfoRow("관리자", aed.manager)
      addInfoRow("연락처", aed.managerTel)
      addInfoRow("위도", String(aed.latitude))
      addInfoRow("경도", String(aed.longitude))
    case let civilDefenseShelter as OfflineCivilDefenseShelter:
      addInfoRow("시설명", civilDefenseShelter.placeName, isTitle: true)
      addInfoRow("주소", civilDefenseShelter.ronaAddress)
      addInfoRow("평상시 활용", civilDefenseShelter.normalUsageType)
      addInfoRow("규모", "\(civilDefenseShelter.scale) \(civilDefenseShelter.scaleUnit)")
      addInfoRow("수용 인원", String(civilDefenseShelter.personCapability))
      addInfoRow("위도", String(civilDefenseShelter.latitude))
      addInfoRow("경도", String(civilDefenseShelter.longitude))
    case let disasterShelter as OfflineDisasterShelter:
      addInfoRow("시설명", disasterShelter.placeName, isTitle: true)
      addInfoRow("주소", disasterShelter.ronaAddress)
      addInfoRow("대피소 코드", String(disasterShelter.shelterCode))
      addInfoRow("위도", String(disasterShelter.latitude))
      addInfoRow("경도", String(disasterShelter.longitude))
    default:
      addInfoRow("정보", "알 수 없는 항목입니다.")
    }
  }
  
  private func addInfoRow(_ title: String, _ value: String, isTitle: Bool = false) {
    let label = UILabel()
    label.numberOfLines = 0
    label.text = "\(title): \(value)"
    if isTitle {
      label.font = CustomFont.Head2.font()
    } else {
      label.font = CustomFont.Body2.font()
    }
    stackView.addArrangedSubview(label)
  }
}
