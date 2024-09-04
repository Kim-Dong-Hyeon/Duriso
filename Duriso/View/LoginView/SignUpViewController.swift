//
//  SingUpViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
  
  private let titleLabel = UILabel().then {
    $0.text = "환영합니다! \n회원가입"
    $0.font = CustomFont.Head.font()
    $0.textColor = .CBlack
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }
  
  private let idLabel = UILabel().then {
    $0.text = "아이디"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let idTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "아이디를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let nickNameLabel = UILabel().then {
    $0.text = "닉네임"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let nickNameTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "닉네임을 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let passWordLabel = UILabel().then {
    $0.text = "비밀번호"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let passWordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let checkPassWordLabel = UILabel().then {
    $0.text = "비밀번호 확인"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let checkPassWordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let saveButton = UIButton().then {
    $0.setTitle("저장", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.layer.cornerRadius = 10
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .CWhite
    
    configureUI()
  }
  
  private func configureUI() {
    
    [
      titleLabel,
      idLabel,
      idTextField,
      nickNameLabel,
      nickNameTextField,
      passWordLabel,
      passWordTextField, 
      checkPassWordLabel,
      checkPassWordTextField,
      saveButton
    ].forEach { view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    idLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(64)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    idTextField.snp.makeConstraints {
      $0.top.equalTo(idLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(idTextField.snp.bottom).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    nickNameTextField.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    passWordLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameTextField.snp.bottom).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    passWordTextField.snp.makeConstraints {
      $0.top.equalTo(passWordLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    checkPassWordLabel.snp.makeConstraints {
      $0.top.equalTo(passWordTextField.snp.bottom).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    checkPassWordTextField.snp.makeConstraints {
      $0.top.equalTo(checkPassWordLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
  }
}
