//
//  LoginViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class LoginViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  private let viewModel = LoginViewModel()
  
  private let titleLabel = UILabel().then {
    $0.text = "반갑습니다! \n로그인 및 가입하기"
    $0.font = CustomFont.Head.font()
    $0.textColor = .CBlack
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }
  
  private let idLabel = UILabel().then {
    $0.text = "이메일"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let idTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "이메일을 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
  }
  
  private let passwordLabel = UILabel().then {
    $0.text = "비밀번호"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let passwordTextField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.placeholder = "비밀번호를 입력하세요"
    $0.font = CustomFont.Body3.font()
    $0.backgroundColor = .lightGray
    $0.autocorrectionType = .no
    $0.isSecureTextEntry = true
    $0.autocapitalizationType = .none
  }
  
  private let checkboxButton = UIButton().then {
    $0.setImage(UIImage(systemName: "square"), for: .normal)
    $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let autoLoginLabel = UILabel().then {
    $0.text = "자동 로그인"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
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
    $0.isHidden = true // 기능 구현 후 제거
  }
  
  private let appleLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "appleLogin"), for: .normal)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
    $0.isHidden = true // 기능 구현 후 제거
  }
  
  private let signUpButton = UIButton().then {
    $0.setTitle("회원가입  |", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.backgroundColor = .CWhite
    $0.setTitleColor(.CBlack, for: .normal)
  }
  
  private let nonMemeberButton = UIButton().then {
    $0.setTitle("비회원으로 둘러보기", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.backgroundColor = .CWhite
    $0.setTitleColor(.CBlack, for: .normal)
  }
  
  private let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .fill
    //      $0.distribution = .fillEqually
    $0.spacing = 8
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .CWhite
    
    configureUI()
    bindUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    let isAutoLogin = UserDefaults.standard.bool(forKey: "autoLogin")
    checkboxButton.isSelected = isAutoLogin
    
    if isAutoLogin {
      let mainTabBarViewModel = MainTabBarViewModel()
      let mainTabBarVC = MainTabBarViewController(viewModel: mainTabBarViewModel)
      self.navigationController?.setViewControllers([mainTabBarVC], animated: false)
    }
  }
  
  private func configureUI() {
    
    [
      signUpButton,
      nonMemeberButton
    ].forEach { buttonStackView.addArrangedSubview($0) }
    
    
    [
      titleLabel,
      idLabel,
      idTextField,
      passwordLabel,
      passwordTextField,
      kakaoLoginButton,
      appleLoginButton,
      idLoginButton,
      checkboxButton,
      autoLoginLabel,
      buttonStackView
    ].forEach { view.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    idLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(48)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    idTextField.snp.makeConstraints {
      $0.top.equalTo(idLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    passwordLabel.snp.makeConstraints {
      $0.top.equalTo(idTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    checkboxButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(64)
    }
    
    autoLoginLabel.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(16)
      $0.leading.equalTo(checkboxButton.snp.trailing).offset(16)
    }
    
    idLoginButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(checkboxButton.snp.bottom).offset(32)
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
    
    buttonStackView.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
  }
  
  private func bindUI() {
    idTextField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    idLoginButton.rx.tap
      .bind(to: viewModel.loginTap)
      .disposed(by: disposeBag)
    
    checkboxButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.checkboxButton.isSelected.toggle()
        UserDefaults.standard.set(self.checkboxButton.isSelected, forKey: "autoLogin")
      })
      .disposed(by: disposeBag)
    
    viewModel.loginSuccess
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        if self.checkboxButton.isSelected {
          UserDefaults.standard.set(true, forKey: "autoLogin")
        } else {
          UserDefaults.standard.set(false, forKey: "autoLogin")
        }
        
        let mainTabBarViewModel = MainTabBarViewModel()
        let mainTabBarVC = MainTabBarViewController(viewModel: mainTabBarViewModel)
        
        self.navigationController?.setViewControllers([mainTabBarVC], animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.loginError
      .subscribe(onNext: { [weak self] errorMessage in
        let alert = UIAlertController(
          title: "로그인 실패",
          message: errorMessage, preferredStyle: .alert
        )
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        self?.present(alert, animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    signUpButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
      })
      .disposed(by: disposeBag)
    
    nonMemeberButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        let mainTabBarViewModel = MainTabBarViewModel()
        let mainTabBarVC = MainTabBarViewController(viewModel: mainTabBarViewModel)
        
        self.navigationController?.setViewControllers([mainTabBarVC], animated: true)
      })
      .disposed(by: disposeBag)
  }
}
