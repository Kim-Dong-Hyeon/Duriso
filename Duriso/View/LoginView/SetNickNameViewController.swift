//
//  SetNickNameViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/27/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class SetNickNameViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let viewModel = SetNickNameViewModel() // ViewModel 추가
  
  private let titleLabel = UILabel().then {
    $0.text = "환영합니다! \n닉네임 등록"
    $0.font = CustomFont.Head.font()
    $0.textColor = .CBlack
    $0.numberOfLines = 0
    $0.textAlignment = .left
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
    $0.autocapitalizationType = .none
  }
  
  // 닉네임 중복 여부를 표시할 메시지 레이블
  private let nicknameStatusLabel = UILabel().then {
    $0.font = CustomFont.Body3.font()
    $0.textColor = .clear  // 초기에는 숨겨진 상태로 시작
  }
  
  private let checkboxButton = UIButton().then {
    $0.setImage(UIImage(systemName: "square"), for: .normal)
    $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
    $0.translatesAutoresizingMaskIntoConstraints = false
//    $0.isHidden = true
  }
  
  private let autoLoginLabel = UILabel().then {
    $0.text = "자동 로그인"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
//    $0.isHidden = true
  }
  
  private let saveButton = UIButton().then {
    $0.setTitle("저장", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.layer.cornerRadius = 10
    $0.isEnabled = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .CWhite
    
    configureUI()
    bindUI()
  }
  
  private func configureUI() {
    [
      titleLabel,
      nickNameLabel,
      nickNameTextField,
      nicknameStatusLabel,
      checkboxButton,
      autoLoginLabel,
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
      $0.bottom.equalTo(saveButton.snp.top).offset(-96)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    nicknameStatusLabel.snp.makeConstraints {
      $0.bottom.equalTo(nickNameTextField.snp.top).offset(-8)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    checkboxButton.snp.makeConstraints {
      $0.top.equalTo(nickNameTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    autoLoginLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameTextField.snp.bottom).offset(16)
      $0.leading.equalTo(checkboxButton.snp.trailing).offset(16)
    }
    
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
  }
  
  private func bindUI() {
    // TextField 입력 값이 변경될 때마다 ViewModel에 전달
    nickNameTextField.rx.text.orEmpty
      .bind(to: viewModel.nicknameText)
      .disposed(by: disposeBag)
    
    // 닉네임 중복 여부에 따른 상태 메시지 업데이트
    viewModel.nicknameStatusMessage
      .subscribe(onNext: { [weak self] status in
        guard let self = self else { return }
        switch status {
        case .available:
          self.nicknameStatusLabel.text = "사용 가능한 닉네임입니다."
          self.nicknameStatusLabel.textColor = .CBlue
        case .unavailable:
          self.nicknameStatusLabel.text = "이미 사용 중인 닉네임입니다."
          self.nicknameStatusLabel.textColor = .CRed
        case .empty:
          self.nicknameStatusLabel.text = ""
          self.nicknameStatusLabel.textColor = .clear
        }
      })
      .disposed(by: disposeBag)
    
    // 닉네임이 유효할 때만 저장 버튼 활성화
    viewModel.isNicknameValid
      .bind(to: saveButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    viewModel.isNicknameValid
      .map { $0 ? UIColor.CBlue : UIColor.CLightBlue }
      .bind(to: saveButton.rx.backgroundColor)
      .disposed(by: disposeBag)
    
    // 체크박스 버튼 탭 이벤트 처리
    checkboxButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.checkboxButton.isSelected.toggle()
        UserDefaults.standard.set(self.checkboxButton.isSelected, forKey: "autoLogin")
      })
      .disposed(by: disposeBag)
    
    // 저장 버튼 눌렀을 때 ViewModel 호출
    saveButton.rx.tap
      .bind(to: viewModel.saveButtonTapped)
      .disposed(by: disposeBag)
    
    // 저장 완료 후 다음 동작
    viewModel.saveResult
      .subscribe(onNext: { [weak self] result in
        switch result {
        case .success:
          print("닉네임 저장 성공 후 화면 전환.")
          self?.goToMainScreen() // 저장 후 메인 화면으로 이동
        case .failure(let error):
          print("닉네임 저장 실패: \(error.localizedDescription)")
          self?.showErrorAlert(message: error.localizedDescription) // 닉네임 저장 실패 시 에러 메시지 표시
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func showErrorAlert(message: String) {
    let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func goToMainScreen() {
    let mainTabBarViewModel = MainTabBarViewModel()
    let mainTabBarVC = MainTabBarViewController(viewModel: mainTabBarViewModel)
    
    // rootViewController 변경
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      window.rootViewController = mainTabBarVC
      window.makeKeyAndVisible()
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  SetNickNameViewController()
}
