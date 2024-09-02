//
//  ModifyInformationViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit
import SnapKit

class ModifyInformationViewController: UIViewController {
  
  private let profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    imageView.layer.cornerRadius = 80
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let changeImageButton: UIButton = {
    let button = UIButton()
    button.setTitle("사진 변경", for: .normal)
    button.titleLabel?.font = CustomFont.Body3.font()
    button.titleLabel?.textColor = .CWhite
    button.backgroundColor = .CBlue
    button.layer.cornerRadius = 10
    return button
  }()
  
  private let changeNickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "닉네임 변경"
    label.font = CustomFont.Body3.font()
    label.textColor = .CBlack
    return label
  }()
  
  private let nickNameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "변경할 닉네임을 입력해주세요"
    textField.font = CustomFont.Body3.font()
    textField.backgroundColor = .lightGray
    textField.autocorrectionType = .no
    return textField
  }()
  
  private let changePassWordLabel: UILabel = {
    let label = UILabel()
    label.text = "비밀번호 변경"
    label.font = CustomFont.Body3.font()
    label.textColor = .CBlack
    return label
  }()
  
  private let passWordTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "변경할 비밀번호를 입력해주세요"
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
    ].forEach { view.addSubview( $0 ) }
    
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
