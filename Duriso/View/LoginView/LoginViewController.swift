//
//  LoginViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/26/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
  let idLogin = UIImage(named: "idLogin")
  let kakaoLogin = UIImage(named: "kakaoLogin")
  let appleLogin = UIImage(named: "appleLogin")
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "반갑습니다! \n로그인 및 가입하기"
    label.font = CustomFont.Head.font()
    label.textColor = .CBlack
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
  }()
  
  private let idLabel: UILabel = {
    let label = UILabel()
    label.text = "아이디"
    label.font = CustomFont.Body3.font()
    label.textColor = .CBlack
    return label
  }()
  
  private let idTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "아이디를 입력하세요"
    textField.font = CustomFont.Body3.font()
    textField.backgroundColor = .lightGray
    textField.autocorrectionType = .no
    return textField
  }()
  
  private let passWordLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호"
    label.font = CustomFont.Body3.font()
    label.textColor = .CBlack
    return label
  }()
  
  private let passWordTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "비밀번호를 입력하세요"
    textField.font = CustomFont.Body3.font()
    textField.backgroundColor = .lightGray
    textField.autocorrectionType = .no
    return textField
  }()
  
  private let idLoginButton = UIButton()
  private let kakaoLoginButton = UIButton()
  private let appleLoginButton = UIButton()
  
  private let signUpButton: UIButton = {
    let button = UIButton()
    button.setTitle("회원가입", for: .normal)
    button.titleLabel?.font = CustomFont.Body3.font()
    button.backgroundColor = .CWhite
    button.setTitleColor(.CBlack, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .CWhite
    
    configureUI()
  }
  private func configureUI() {
    idLoginButton.setImage(idLogin, for: .normal)
    kakaoLoginButton.setImage(kakaoLogin, for: .normal)
    appleLoginButton.setImage(appleLogin, for: .normal)
    
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
