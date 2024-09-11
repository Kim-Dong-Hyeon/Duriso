//
//  ShelterViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/9/24.
//

import UIKit

import SnapKit
import Then

class ShelterViewController: UIViewController {
  
  private var shelterData: Shelter? {
    didSet {
      print("shelterData didSet called with: \(shelterData?.shelterName ?? "No Data")")
      if isViewLoaded {  // view가 이미 로드된 상태라면 UI 업데이트
        updateUI()
      }
    }
  }
  
  private let typeStackView = UIStackView().then {
    //타입 로고 및 타입명
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
  
  private let typeLogo = UIImageView().then {
    $0.image = UIImage(named: "figure.run")
    $0.contentMode = .scaleAspectFit
  }
  
  private let typeLabel = UILabel().then {
    $0.text = "대피소"
    $0.textColor = .CGreen
    $0.textAlignment = .center
    $0.font = CustomFont.Deco4.font()
  }
  
  private let shelterName = UILabel().then {
    $0.text = "대피소 이름"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head2.font()
  }
  
  private let shelterAddress = UILabel().then {
    $0.text = "00도 00시 00구 00동"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body2.font()
  }
  
  private let shelterType = UILabel().then {
    $0.text = "000 대피소"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body3.font()
  }
  
  private let cancelButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    $0.tintColor = .black  // 아이콘 색상 설정
    $0.contentMode = .scaleAspectFit  // 이미지 모드 설정
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  //  private let messageInputText = UITextField().then {
  //    $0.backgroundColor = UIColor.CLightBlue
  //    $0.font = CustomFont.Body2.font()
  //    $0.placeholder = "꼭 필요한 긴급 정보만 남겨주세요!"
  //    $0.layer.cornerRadius = 16
  //    $0.layer.masksToBounds = true
  //    $0.clearButtonMode = .always
  //  }
  //
  //  private let addPostButton = UIButton().then {
  //    $0.setTitle("완료", for: .normal)
  //    $0.titleLabel?.font = CustomFont.Body3.font()
  //    $0.setTitleColor(.CWhite, for: .normal)
  //    $0.backgroundColor = .CBlue
  //    $0.layer.cornerRadius = 12
  //    $0.layer.masksToBounds = true
  //    $0.addTarget(self, action: #selector(didTapAddPostButton), for: .touchUpInside)
  //  }
  
  // MARK: - view Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupView()
    setupConstraints()
    print("viewDidLoad: \(shelterData?.shelterTypeName)")
    if shelterData != nil {
      updateUI()  // view가 로드될 때 바로 UI 업데이트
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if shelterData != nil {
      print("viewWillAppear: shelterData is \(shelterData?.shelterName ?? "No Data")")
      updateUI()  // 화면에 나타나기 전 UI 업데이트
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if shelterData != nil {
      print("viewDidAppear: shelterData is \(shelterData?.shelterName ?? "No Data")")
      updateUI()  // 화면에 나타난 후 UI 업데이트
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // 캐시된 데이터 초기화
    self.shelterData = nil
    print("Shelter data cleared")
  }
  
  func setupView() {
    [
      typeLogo,
      typeLabel
    ].forEach { typeStackView.addSubview($0) }
    
    [
      shelterName,
      typeStackView,
      shelterAddress,
      shelterType,
      cancelButton,
      //      messageInputText,
      //      addPostButton
    ].forEach { view.addSubview($0) }
  }
  
  func setupConstraints() {
    
    typeStackView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.width.equalTo(85)  // 적절한 너비 설정
      $0.height.equalTo(26)  // 적절한 높이 설정
    }
    
    typeLogo.snp.makeConstraints {
      $0.leading.equalTo(typeStackView.snp.leading).offset(4)
      $0.bottom.equalTo(typeStackView.snp.bottom)
      $0.height.equalTo(22)
    }
    
    typeLabel.snp.makeConstraints {
      //      $0.centerY.equalTo(typeStackView)
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
    
    cancelButton.snp.makeConstraints {
      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.width.height.equalTo(32)
    }
    
    //    messageInputText.snp.makeConstraints {
    //      $0.centerX.equalTo(view.safeAreaLayoutGuide)
    //      $0.top.equalTo(shelterAddress.snp.bottom).offset(16)
    //      $0.width.equalTo(350)
    //      $0.height.equalTo(38)
    //    }
    //
    //    addPostButton.snp.makeConstraints {
    //      $0.centerX.equalTo(view.safeAreaLayoutGuide)
    //      $0.top.equalTo(messageInputText.snp.bottom).offset(16)
    //      $0.width.equalTo(60)
    //      $0.height.equalTo(24)
    //    }
  }
  
  private func updateUI() {
    guard let shelter = shelterData else {
      print("updateUI: shelterData is nil")
      return
    }
    
    print("updateUI: Updating UI with shelter: \(shelter.shelterName)")
    
    DispatchQueue.main.async {
      self.shelterName.text = shelter.shelterName
      self.shelterType.text = shelter.shelterTypeName
      self.shelterAddress.text = shelter.address
      
      print("UI Updated with shelter: \(shelter.shelterName)")
      
      // 레이아웃 강제 갱신
      self.view.setNeedsLayout()
      self.view.layoutIfNeeded()
    }
  }
  
  func shelterupdatePoiData(with shelter: Shelter) {
    print("updatePoiData called with shelter: \(shelter.shelterName)")
    self.shelterData = shelter  // shelter 데이터를 설정하면 didSet에서 UI 업데이트
    if isViewLoaded {  // 뷰가 이미 로드된 상태면 즉시 UI 업데이트
      updateUI()
    }
  }
  
  @objc func didTapCancelButton() {
    dismiss(animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  ShelterViewController()
}

