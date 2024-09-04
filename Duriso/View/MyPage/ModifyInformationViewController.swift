//
//  ModifyInformationViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit

import SnapKit

class ModifyInformationViewController: UIViewController {
  
  private let profileImage = UIImageView().then {
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 80
    $0.clipsToBounds = true
  }
  
  private let changeImageButton = UIButton().then {
    $0.setTitle("사진 변경", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.titleLabel?.textColor = .CWhite
    $0.backgroundColor = .CBlue
    $0.layer.cornerRadius = 10
  }
  
  private let changeNickNameLabel = UILabel().then {
    $0.text = "닉네임 변경"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let nickNameTextField = UITextField().then {
    $0.placeholder = "변경할 닉네임을 입력해주세요"
    $0.font = CustomFont.Body3.font()
    $0.borderStyle = .roundedRect
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let changePassWordLabel = UILabel().then {
    $0.text = "비밀번호 변경"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let passWordTextField = UITextField().then {
    $0.placeholder = "변경할 비밀번호를 입력해주세요"
    $0.font = CustomFont.Body3.font()
    $0.borderStyle = .roundedRect
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let saveButton = UIButton().then {
    $0.setTitle("저장", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 10
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    configureUI()
  }
  
  private func configureUI(){
    [
      profileImage,
      changeImageButton,
      changeNickNameLabel,
      nickNameTextField,
      changePassWordLabel,
      passWordTextField,
      saveButton
    ].forEach { view.addSubview($0) }
    
    profileImage.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
      $0.width.height.equalTo(160)
    }
    
    changeImageButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(profileImage.snp.bottom).offset(16)
      $0.width.equalTo(80)
    }
    
    changeNickNameLabel.snp.makeConstraints {
      $0.top.equalTo(changeImageButton.snp.bottom).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    nickNameTextField.snp.makeConstraints {
      $0.top.equalTo(changeNickNameLabel.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    changePassWordLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameTextField.snp.bottom).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    passWordTextField.snp.makeConstraints {
      $0.top.equalTo(changePassWordLabel.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
  }
}
