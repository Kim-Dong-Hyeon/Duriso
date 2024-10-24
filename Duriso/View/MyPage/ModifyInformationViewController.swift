//
//  ModifyInformationViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import RxSwift
import SnapKit

class ModifyInformationViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let changePasswordViewController = ChangePasswordViewController()
  
  private let profileImage = UIImageView().then {
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 80
    $0.clipsToBounds = true
    $0.image = UIImage(named: "AppIcon")
  }
  
  //  private let changeImageButton = UIButton().then {
  //    $0.setTitle("사진 변경", for: .normal)
  //    $0.titleLabel?.font = CustomFont.Body3.font()
  //    $0.titleLabel?.textColor = .CWhite
  //    $0.backgroundColor = .CBlue
  //    $0.layer.cornerRadius = 10
  //  }
  
  private let changenicknameLabel = UILabel().then {
    $0.text = "닉네임 변경"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let nicknameTextField = UITextField().then {
    $0.placeholder = "변경할 닉네임을 입력해주세요"
    $0.font = CustomFont.Body3.font()
    $0.borderStyle = .roundedRect
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
  }
  
  private let checkNicknameDuplicationButton = UIButton().then {
    $0.setTitle("중복 확인", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 10
  }
  
  private let changePasswordButton = UIButton().then {
    $0.setTitle("비밀번호 변경", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.layer.cornerRadius = 10
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
    self.tabBarController?.tabBar.isHidden = true
    
    configureUI()
    updateUIBasedOnAuthProvider() // 인증 제공자에 따라 UI 업데이트
    bindUi()
  }
  
  private func configureUI(){
    [
      profileImage,
      //      changeImageButton,
      changenicknameLabel,
      nicknameTextField,
      checkNicknameDuplicationButton,
      changePasswordButton,
      saveButton
    ].forEach { view.addSubview($0) }
    
    profileImage.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
      $0.width.height.equalTo(160)
    }
    
    //    changeImageButton.snp.makeConstraints {
    //      $0.centerX.equalTo(view.safeAreaLayoutGuide)
    //      $0.top.equalTo(profileImage.snp.bottom).offset(16)
    //      $0.width.equalTo(80)
    //    }
    
    changenicknameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImage.snp.bottom).offset(48)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    nicknameTextField.snp.makeConstraints {
      $0.top.equalTo(changenicknameLabel.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(checkNicknameDuplicationButton.snp.leading).offset(-16)
      $0.height.equalTo(48)
    }
    
    checkNicknameDuplicationButton.snp.makeConstraints{
      $0.top.equalTo(changenicknameLabel.snp.bottom).offset(16)
      $0.leading.equalTo(nicknameTextField.snp.trailing).offset(16)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    changePasswordButton.snp.makeConstraints {
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(32)
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
    changePasswordButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.navigationController?.pushViewController(self.changePasswordViewController, animated: true)
      })
      .disposed(by: disposeBag)
    
    saveButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let alert = UIAlertController(title: "저장 완료", message: "변경 사항이 저장되었습니다.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
          self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
  }
  
  // 인증 제공자에 따라 비밀번호 변경 버튼 숨기기
  private func updateUIBasedOnAuthProvider() {
    guard let currentUser = Auth.auth().currentUser else { return }
    
    // Apple ID로 로그인한 경우 비밀번호 변경 버튼을 숨김
    let providerData = currentUser.providerData
    let isAppleSignIn = providerData.contains { $0.providerID == "apple.com" }
    
    changePasswordButton.isHidden = isAppleSignIn
  }
}
