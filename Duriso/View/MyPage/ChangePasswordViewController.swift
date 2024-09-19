//
//  ChangePasswordViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/19/24.
//

import UIKit

import FirebaseFirestore
import SnapKit

class ChangePasswordViewController: UIViewController {
  
  private let nowPasswordLabel = UILabel().then {
    $0.text = "현재 비밀번호"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let nowPasswordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "현재 비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
    $0.isSecureTextEntry = true
    $0.autocapitalizationType = .none
  }
  
  private let newPasswordLabel = UILabel().then {
    $0.text = "현재 비밀번호"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let newPasswordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "현재 비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
    $0.isSecureTextEntry = true
    $0.autocapitalizationType = .none
  }
  
  private let checkPasswordLabel = UILabel().then {
    $0.text = "현재 비밀번호"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let checkPasswordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "현재 비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
    $0.isSecureTextEntry = true
    $0.autocapitalizationType = .none
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
  
  private func configureUI() {
    [
      nowPasswordLabel,
      nowPasswordTextField,
      newPasswordLabel,
      newPasswordTextField,
      checkPasswordLabel,
      checkPasswordTextField,
      saveButton
    ].forEach { view.addSubview($0) }
    
    nowPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    nowPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(nowPasswordLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    newPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(nowPasswordTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    newPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(newPasswordLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    checkPasswordLabel.snp.makeConstraints {
      $0.top.equalTo(newPasswordTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    checkPasswordTextField.snp.makeConstraints {
      $0.top.equalTo(checkPasswordLabel.snp.bottom).offset(8)
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
