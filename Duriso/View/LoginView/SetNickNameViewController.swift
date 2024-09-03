//
//  SetNickNameViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit
import SnapKit

class SetNickNameViewController: UIViewController {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "환영합니다! \n닉네임 등록"
    label.font = CustomFont.Head.font()
    label.textColor = .CBlack
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
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
    
    ConfigureUI()
  }
  
  private func ConfigureUI() {
    [
      titleLabel,
      nickNameLabel,
      nickNameTextField,
      saveButton
    ].forEach { view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.bottom.equalTo(nickNameTextField.snp.top).offset(-8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    nickNameTextField.snp.makeConstraints {
      $0.bottom.equalTo(saveButton.snp.top).offset(-32)
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
