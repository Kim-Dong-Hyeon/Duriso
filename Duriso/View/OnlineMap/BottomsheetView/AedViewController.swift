//
//  AedViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import SnapKit
import Then

class AedViewController: UIViewController {
  
  // MARK: - Properties
  
  var poiName: String?
  var poiAddress: String?
  var adminName: String?
  var adminNumber: String?
  var managementAgency: String?
  var location: String?
  
  // AED 타입 스택 뷰 (로고와 라벨)
  private let typeStackView = UIStackView().then {
    $0.backgroundColor = .CWhite
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .center
    $0.layer.borderColor = UIColor.CRed.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 13
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowOpacity = 0.2
    $0.layer.shadowColor = UIColor.CBlack.cgColor
    $0.layer.shadowRadius = 4
    $0.layer.masksToBounds = false
  }
  
  private let typeLogo = UIImageView().then {
    $0.image = UIImage(named: "bolt.heart.fill")
    $0.contentMode = .scaleAspectFit
  }
  
  private let typeLabel = UILabel().then {
    $0.text = "AED"
    $0.textColor = .CRed
    $0.textAlignment = .center
    $0.font = CustomFont.Deco4.font()
  }
  
  private let aedName = UILabel().then {
    $0.text = "AED 위치"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head2.font()
    $0.numberOfLines = 0
  }
  
  private let aedAddress = UILabel().then {
    $0.text = "위치 정보 받아오는 중..."
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body2.font()
    $0.numberOfLines = 0
  }
  
  private let adminInfoLabel = UILabel().then {
    $0.text = "관리자 정보"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head3.font()
  }
  
  private let adminNameLabel = UILabel().then {
    $0.text = "관리자 이름"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body2.font()
  }
  
  private let adminNumberLabel = UILabel().then {
    $0.text = "관리자 전화번호"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body2.font()
  }
  
//  private let cancelButton = UIButton().then {
//    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//    $0.tintColor = .CLightBlue
//    $0.contentMode = .scaleAspectFit
//    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
//  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
    
    updatePoiData()
  }
  
  // MARK: - View Setup
  
  func setupView() {
    [
      typeLogo,
      typeLabel
    ].forEach { typeStackView.addSubview($0) }
    
    [
      aedName,
      typeStackView,
      aedAddress,
      adminInfoLabel,
      adminNameLabel,
      adminNumberLabel,
//      cancelButton
    ].forEach { view.addSubview($0) }
  }
  
  // MARK: - Constraints Setup
  
  func setupConstraints() {
    typeStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.width.equalTo(85)
      $0.height.equalTo(26)
    }
    
    typeLogo.snp.makeConstraints {
      $0.leading.equalTo(typeStackView.snp.leading).offset(4)
      $0.bottom.equalTo(typeStackView.snp.bottom)
      $0.height.equalTo(22)
    }
    
    typeLabel.snp.makeConstraints {
      $0.leading.equalTo(typeLogo.snp.trailing)
    }
    
    aedName.snp.makeConstraints {
      $0.top.equalTo(typeStackView.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
    }
    
    aedAddress.snp.makeConstraints {
      $0.top.equalTo(aedName.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
    }
    
    adminInfoLabel.snp.makeConstraints {
      $0.top.equalTo(aedAddress.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
    }
    
    adminNameLabel.snp.makeConstraints {
      $0.top.equalTo(adminInfoLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
    }
    
    adminNumberLabel.snp.makeConstraints {
      $0.centerY.equalTo(adminNameLabel.snp.centerY)
      $0.leading.equalTo(adminNameLabel.snp.trailing)
    }
    
//    cancelButton.snp.makeConstraints {
//      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
//      $0.width.height.equalTo(32)  
//    }
  }
  
  // MARK: - POI Data Update
  
  // 전달받은 POI 데이터를 UI에 반영
  func updatePoiData() {
    aedName.text = "\(location ?? "제공된 데이터가 없습니다.")"
    
    if let poiAddress = poiAddress {
      let formattedAddress = poiAddress.replacingOccurrences(of: "(", with: "\n(")
      aedAddress.text = "주소: \(formattedAddress)"
    } else {
      aedAddress.text = "주소: 제공된 데이터가 없습니다."
    }
    
    adminInfoLabel.text = "관리기관: \(managementAgency ?? "제공된 데이터가 없습니다.")"
    adminNameLabel.text = "관리자 이름: \(adminName ?? "제공된 데이터가 없습니다.")"
    adminNumberLabel.text = " (\(adminNumber ?? "제공된 데이터가 없습니다."))"
  }
  
  // MARK: - Actions
  
  // 취소 버튼 클릭 시 호출되는 함수
//  @objc func didTapCancelButton() {
//    dismiss(animated: true)
//  }
}
