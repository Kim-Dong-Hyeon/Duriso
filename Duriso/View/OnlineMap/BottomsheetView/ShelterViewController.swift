//
//  ShelterViewController.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/9/24.
//

import UIKit

import SnapKit
import Then

class ShelterViewController: UIViewController {
  
  // MARK: -property
  
  // POI 데이터를 저장할 변수
  var poiName: String?
  var poiAddress: String?
  var poiType: String?
  
  // UI 요소들
  let typeStackView = UIStackView().then {
    
    $0.backgroundColor = .CWhite
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .center
    $0.layer.borderColor = UIColor.CGreen.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 13
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowOpacity = 0.2
    $0.layer.shadowColor = UIColor.CBlack.cgColor
    $0.layer.shadowRadius = 4
    $0.layer.masksToBounds = false
  }
  
  let typeLogo = UIImageView().then {
    $0.image = UIImage(named: "figure.run")
    $0.contentMode = .scaleAspectFit
  }
  
  let typeLabel = UILabel().then {
    $0.text = "대피소"
    $0.textColor = .CGreen
    $0.textAlignment = .center
    $0.font = CustomFont.Deco4.font()
  }
  
  let shelterName = UILabel().then {
    $0.text = "대피소 이름"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head2.font()
  }
  
  let shelterAddress = UILabel().then {
    $0.text = "위치 정보 받아오는 중..."
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body2.font()
    $0.numberOfLines = 0
    $0.adjustsFontSizeToFitWidth = true
  }
  
  let shelterType = UILabel().then {
    $0.text = "000 대피소"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body3.font()
  }
  
  // 닫기 버튼 비활성화
  //  let cancelButton = UIButton().then {
  //    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
  //    $0.tintColor = .CLightBlue
  //    $0.contentMode = .scaleAspectFit
  //    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  //  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
    
    updatePoiData()
  }
  
  // MARK: - View Setup
  
  // UI 요소들을 서브뷰에 추가하는 함수
  func setupView() {
    // 타입 로고와 라벨을 스택 뷰에 추가
    [
      typeLogo,
      typeLabel
    ].forEach { typeStackView.addSubview($0) }
    
    // 스택 뷰와 라벨들을 메인 뷰에 추가
    [
      shelterName,
      typeStackView,
      shelterAddress,
      shelterType,
      //      cancelButton
    ].forEach { view.addSubview($0) }
  }
  
  // MARK: - Constraints Setup
  
  // UI 요소들의 제약 조건 설정 함수
  func setupConstraints() {
    typeStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.width.equalTo(85)   // 스택 뷰 너비 설정
      $0.height.equalTo(26)  // 스택 뷰 높이 설정
    }
    
    typeLogo.snp.makeConstraints {
      $0.leading.equalTo(typeStackView.snp.leading).offset(4)
      $0.bottom.equalTo(typeStackView.snp.bottom)
      $0.height.equalTo(22)
    }
    
    typeLabel.snp.makeConstraints {
      $0.leading.equalTo(typeLogo.snp.trailing)
    }
    
    shelterName.snp.makeConstraints {
      $0.top.equalTo(typeStackView.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    shelterType.snp.makeConstraints {
      $0.top.equalTo(shelterName.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    shelterAddress.snp.makeConstraints {
      $0.top.equalTo(shelterType.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    //    cancelButton.snp.makeConstraints {
    //      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
    //      $0.width.height.equalTo(32)  // 취소 버튼 크기 설정
    //    }
  }
  
  // MARK: - POI Data Update
  
  // 전달받은 POI 데이터를 UI에 반영하는 함수
  func updatePoiData() {
    shelterName.text = poiName ?? "제공받은 데이터가 없습니다."
    
    if let poiAddress = poiAddress {
      let formattedAddress = poiAddress.replacingOccurrences(of: "(", with: "\n(")
      shelterAddress.text = "주소: \(formattedAddress)"
    } else {
      shelterAddress.text = "주소: 제공받은 데이터가 없습니다."
    }
    
    shelterType.text = poiType ?? "제공받은 데이터가 없습니다."
  }
  
  // MARK: - Actions
  
  //  // 취소 버튼 클릭 시 호출되는 함수
  //  @objc func didTapCancelButton() {
  //    dismiss(animated: true)
  //  }
}


