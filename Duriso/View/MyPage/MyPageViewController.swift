//
//  MyPageViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class MyPageViewController: UIViewController {
  private let viewModel = MyPageViewModel()
  private let disposeBag = DisposeBag()
  
  let noticeViewController = NoticeViewController()
  let legalNoticeViewController = LegalNoticeViewController()
  let copyrightViewController = CopyrightViewController()
  let modifyInformationViewController = ModifyInformationViewController()
  let muteViewController = MuteViewController()
  
  private let titleLabel = UILabel().then {
    $0.text = "마이페이지"
    $0.font = CustomFont.Head.font()
  }
  
  private let profileImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 40
    $0.clipsToBounds = true
    $0.image = UIImage(named: "AppIcon")
  }
  
  private let nickNameLabel = UILabel().then {
    $0.font = CustomFont.Body.font()
    $0.textColor = .CBlack
  }
  
  private let postCountLabel = UILabel().then {
    $0.text = "게시글 수"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let postCount = UILabel().then {
    $0.text = "0"
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let profileButton = UIButton().then {
    $0.setTitle("내 정보", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Head3.font()
    $0.layer.cornerRadius = 10
  }
  
  private let loginGuideLabel = UILabel().then {
    $0.text = "로그인 후 사용 가능합니다."
    $0.font = CustomFont.Body3.font()
    $0.textColor = .CBlack
  }
  
  private let loginGuideButton = UIButton().then {
    $0.setTitle("로그인 및 회원가입 페이지로 이동하기", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Head3.font()
    $0.layer.cornerRadius = 10
  }
  
  private let myPageTableView = UITableView().then {
    $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    $0.isScrollEnabled = true
  }
  
  private let contactLabel = UILabel().then {
    $0.text = "문의: durisoapp@gmail.com \n개발자: 김동현, 신상규, 이주희, 조수환"
    $0.font = CustomFont.Body4.font()
    $0.numberOfLines = 0
    $0.textAlignment = .left
    $0.textColor = .lightGray
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    self.navigationItem.titleView = titleLabel
    myPageTableView.rowHeight = 56
    
    configureUI()
    bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    
    updateUIBasedOnAuthState()
  }
  
  private func configureUI() {
    [
      profileImage,
      nickNameLabel,
      postCountLabel,
      postCount,
      profileButton,
      loginGuideLabel,
      loginGuideButton,
      myPageTableView,
      contactLabel
    ].forEach { view.addSubview($0) }
    
    profileImage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.width.height.equalTo(80)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImage.snp.top)
      $0.leading.equalTo(profileImage.snp.trailing).offset(40)
    }
    
    postCountLabel.snp.makeConstraints {
      $0.top.equalTo(nickNameLabel.snp.bottom).offset(20)
      $0.leading.equalTo(nickNameLabel.snp.leading)
    }
    
    postCount.snp.makeConstraints {
      $0.centerY.equalTo(postCountLabel)
      $0.leading.equalTo(postCountLabel.snp.trailing).offset(32)
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(profileImage.snp.bottom).offset(30)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    loginGuideLabel.snp.makeConstraints{
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
    }
    
    loginGuideButton.snp.makeConstraints {
      $0.top.equalTo(loginGuideLabel).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    myPageTableView.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(20)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.bottom.equalTo(contactLabel.snp.top).offset(-10)
    }
    
    contactLabel.snp.makeConstraints{
//      $0.top.equalTo(myPageTableView.snp.bottom)      // 삭제 예정: 중복되는 제약조건 (디버깅 Warning)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
    }
  }
  
  private func bindViewModel() {
    
    viewModel.nickname
      .bind(to: nickNameLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.postcount
      .map { "\($0)" }
      .bind(to: postCount.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.items
      .bind(
        to: myPageTableView.rx.items(
          cellIdentifier: "MyPageCell",
          cellType: MyPageTableViewCell.self)
      ) { row, item, cell in
        cell.configure(with: item)
        cell.selectionStyle = item.selected ? .default : .none
      }
      .disposed(by: disposeBag)
    
    myPageTableView.rx.modelSelected(MyPageModel.self)
      .subscribe(onNext: { [weak self] item in
        self?.handleItemSelection(item)
      })
      .disposed(by: disposeBag)
    
    loginGuideButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigateToLoginScreen()
      })
      .disposed(by: disposeBag)
    
    profileButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigateToModifyInformation()
      })
      .disposed(by: disposeBag)
    
    viewModel.logoutResult
      .subscribe(onNext: { [weak self] result in
        switch result {
        case .success:
          self?.handleLogoutSuccess()
        case .failure(let error):
          self?.showAlert(title: "로그아웃 실패", message: error.localizedDescription)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.deleteAccountResult
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] result in
        switch result {
        case .success:
          print("MyPageViewController: 회원탈퇴 성공")
          self?.handleDeleteAccountSuccess()
        case .failure(let error):
          print("MyPageViewController: 회원탈퇴 실패 - \(error.localizedDescription)")
          self?.showAlert(title: "계정 삭제 실패", message: error.localizedDescription)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func updateUIBasedOnAuthState() {
    if FirebaseAuthManager.shared.getCurrentUser() == nil {
      hideProfileSection(isHidden: true)
      hideloginGuideSection(isHidden: false)
    } else {
      hideProfileSection(isHidden: false)
      hideloginGuideSection(isHidden: true)
    }
  }
  
  private func hideProfileSection(isHidden: Bool) {
    profileImage.isHidden = isHidden
    nickNameLabel.isHidden = isHidden
    postCountLabel.isHidden = isHidden
    postCount.isHidden = isHidden
    profileButton.isHidden = isHidden
  }
  
  private func hideloginGuideSection(isHidden: Bool) {
    loginGuideLabel.isHidden = isHidden
    loginGuideButton.isHidden = isHidden
  }
  
  private func handleItemSelection(_ item: MyPageModel) {
    switch item.title {
    case "로그아웃":
      showLogoutConfirmation()
    case "회원탈퇴":
      showDeleteAccountConfirmation()
    case "공지사항":
      navigateTo(viewController: noticeViewController, title: item.title)
    case "법적고지":
      navigateTo(viewController: legalNoticeViewController, title: item.title)
    case "저작권 표시":
      navigateTo(viewController: copyrightViewController, title: item.title)
    case "차단 목록":
      navigateTo(viewController: muteViewController, title: item.title)
    default:
      break
    }
  }
  
  private func showLogoutConfirmation() {
    showConfirmationAlert(title: "로그아웃", message: "정말로 로그아웃 하시겠습니까?") { [weak self] in
      self?.viewModel.logoutTrigger.onNext(())
    }
  }
  
  private func showDeleteAccountConfirmation() {
    showConfirmationAlert(title: "회원탈퇴", message: "정말로 회원탈퇴 하시겠습니까?") { [weak self] in
      self?.viewModel.deleteAccountTrigger.onNext(())
    }
  }
  
  private func showConfirmationAlert(title: String, message: String, action: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in action() })
    alert.addAction(UIAlertAction(title: "취소", style: .cancel))
    present(alert, animated: true)
  }
  
  private func handleLogoutSuccess() {
    UserDefaults.standard.removeObject(forKey: "autoLogin")
    DispatchQueue.main.async { [weak self] in
      self?.navigateToLoginScreen()
    }
  }
  
  private func handleDeleteAccountSuccess() {
    print("MyPageViewController: 회원탈퇴 성공 처리 시작")
    UserDefaults.standard.removeObject(forKey: "autoLogin")
    
    DispatchQueue.main.async { [weak self] in
      print("MyPageViewController: 로그인 화면으로 이동")
      
      // 기존 모든 뷰 컨트롤러 스택 제거 후 로그인 화면으로 이동
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let window = windowScene.windows.first {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        // 기존 화면을 모두 제거하고 로그인 화면으로 전환
        window.rootViewController = navController
        window.makeKeyAndVisible()
      }
    }
  }
  
  private func navigateToLoginScreen() {
    // 기존 모든 뷰 컨트롤러 스택 제거 후 로그인 화면으로 이동
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first {
      let loginVC = LoginViewController()
      let navController = UINavigationController(rootViewController: loginVC)
      
      // 기존 화면을 모두 제거하고 로그인 화면으로 전환
      window.rootViewController = navController
      window.makeKeyAndVisible()
    }
  }
  
  private func navigateTo(viewController: UIViewController, title: String) {
    viewController.title = title
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  private func navigateToModifyInformation() {
    navigationController?.pushViewController(modifyInformationViewController, animated: true)
  }
  
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true)
  }
}
