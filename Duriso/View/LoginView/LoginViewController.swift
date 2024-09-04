//
//  LoginViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/26/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
  
  private let titleLabel = UILabel().then {
    $0.text = "반갑습니다! \n로그인 및 가입하기"
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
  
  private let idLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "idLogin"), for: .normal)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let kakaoLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "kakaoLogin"), for: .normal)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let appleLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "appleLogin"), for: .normal)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let signUpButton = UIButton().then {
    $0.setTitle("회원가입", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.backgroundColor = .CWhite
    $0.setTitleColor(.CBlack, for: .normal)
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
      passWordLabel,
      passWordTextField,
      kakaoLoginButton,
      appleLoginButton,
      idLoginButton,
      signUpButton
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
    
    passWordLabel.snp.makeConstraints {
      $0.top.equalTo(idTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    passWordTextField.snp.makeConstraints {
      $0.top.equalTo(passWordLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    idLoginButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(passWordTextField.snp.bottom).offset(48)
      $0.width.equalTo(320)
      $0.height.equalTo(48)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(idLoginButton.snp.bottom).offset(24)
      $0.width.equalTo(320)
      $0.height.equalTo(48)
    }
    
    appleLoginButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(24)
      $0.width.equalTo(320)
      $0.height.equalTo(48)
    }
    
    signUpButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
  }
}
