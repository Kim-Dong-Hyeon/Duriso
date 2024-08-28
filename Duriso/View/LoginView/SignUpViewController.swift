//
//  SingUpViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "환영합니다! \n회원가입"
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
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "닉네임"
    label.font = CustomFont.Body3.font()
    label.textColor = .CBlack
    return label
  }()
  
  private let nickNameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "닉네임을 입력하세요"
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
  
  private let checkPassWordLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호 확인"
    label.font = CustomFont.Body3.font()
    label.textColor = .CBlack
    return label
  }()
  
  private let checkPassWordTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "비밀번호를 입력하세요"
    textField.font = CustomFont.Body3.font()
    textField.backgroundColor = .lightGray
    textField.autocorrectionType = .no
    return textField
  }()
  
  private let saveButton: UIButton = {
    let button = UIButton()
    button.setTitle("저장", for: .normal)
    button.backgroundColor = .CLightBlue
    button.titleLabel?.font = CustomFont.Body3.font()
    button.layer.cornerRadius = 10
    return button
  }()
  
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
