//
//  ChangePasswordViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/19/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import RxSwift
import SnapKit

class ChangePasswordViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
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
    $0.text = "새 비밀번호"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let newPasswordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "새 비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
    $0.isSecureTextEntry = true
    $0.autocapitalizationType = .none
  }
  
  private let checkPasswordLabel = UILabel().then {
    $0.text = "새 비밀번호 확인"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let checkPasswordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "새 비밀번호를 입력하세요"
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
    bindUi()
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
  
  private func bindUi() {
    saveButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.changePassword()
      })
      .disposed(by: disposeBag)
  }
  
  private func changePassword() {
    guard let currentUser = Auth.auth().currentUser else { return }
    guard let nowPassword = nowPasswordTextField.text, !nowPassword.isEmpty else {
      showAlert(title: "오류", message: "현재 비밀번호를 입력해주세요.")
      return
    }
    guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
      showAlert(title: "오류", message: "새 비밀번호를 입력해주세요.")
      return
    }
    guard let checkPassword = checkPasswordTextField.text, !checkPassword.isEmpty else {
      showAlert(title: "오류", message: "비밀번호 확인을 입력해주세요.")
      return
    }
    guard newPassword == checkPassword else {
      showAlert(title: "오류", message: "새 비밀번호가 일치하지 않습니다.")
      return
    }
    guard nowPassword != newPassword else {
      showAlert(title: "오류", message: "현재 비밀번호와 같은 비밀번호를 사용할 수 없습니다.")
      return
    }
    
    let credential = EmailAuthProvider.credential(withEmail: currentUser.email ?? "", password: nowPassword)
    currentUser.reauthenticate(with: credential) { [weak self] authResult, error in
      if let error = error {
        self?.showAlert(title: "오류", message: "현재 비밀번호가 일치하지 않습니다.")
      } else {
        currentUser.updatePassword(to: newPassword) { error in
          if let error = error {
            self?.showAlert(title: "오류", message: "비밀번호 변경에 실패했습니다.")
          } else {
            self?.showAlert(title: "성공", message: "비밀번호가 성공적으로 변경되었습니다.")
          }
        }
      }
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
      if title == "성공" {
        self?.navigationController?.popViewController(animated: true)
      }
    }
    alert.addAction(confirmAction)
    self.present(alert, animated: true, completion: nil)
  }
}
