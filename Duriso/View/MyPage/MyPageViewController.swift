//
//  MyPageViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import FirebaseAuth
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
  
  private let titleLabel = UILabel().then {
    $0.text = "마이페이지"
    $0.font = CustomFont.Head.font()
  }
  
  private let profileImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 40
    $0.clipsToBounds = true
//    $0.backgroundColor = .lightGray // 테스트용 배경색
    $0.image = UIImage(named: "AppIcon")
  }
  
  private let nickNameLabel = UILabel().then {
    $0.text = "test" // 테스트용 텍스트
    $0.font = CustomFont.Body.font()
    $0.textColor = .CBlack
  }
  
  private let postCountLabel = UILabel().then {
    $0.text = "게시글 수"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .CBlack
  }
  
  private let postCount = UILabel().then {
    $0.text = "0"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .CBlack
  }
  
  private let profileButton = UIButton().then {
    $0.setTitle("내 정보", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Head5.font()
    $0.layer.cornerRadius = 10
  }
  
  private let myPageTableView = UITableView().then {
    $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    $0.isScrollEnabled = true
  }
  
  private let contactLabel = UILabel().then {
    $0.text = "문의: durisoapp@gmail.com"
    $0.font = CustomFont.Body3.font()
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
    bindProfileButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  private func configureUI() {
    [
      profileImage,
      nickNameLabel,
      postCountLabel,
      postCount,
      profileButton,
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
    
    myPageTableView.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(20)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.bottom.equalTo(contactLabel.snp.top).offset(-10)
    }
    
    contactLabel.snp.makeConstraints{
      $0.top.equalTo(myPageTableView.snp.bottom)
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
      .flatMap { [weak self] item -> Observable<Void> in
        guard let self = self else { return .empty() }
        
        switch item.title {
        case "로그아웃":
          return self.tappedLogout()
        case "회원탈퇴":
          return self.tappedWithdrawal()
        case "공지사항":
          noticeViewController.title = item.title
          navigationController?.pushViewController(noticeViewController, animated: true)
          return .just(())
        case "법적고지":
          legalNoticeViewController.title = item.title
          navigationController?.pushViewController(legalNoticeViewController, animated: true)
          return .just(())
        case "저작권 표시":
          copyrightViewController.title = item.title
          navigationController?.pushViewController(copyrightViewController, animated: true)
          return .just(())
        default:
          return .empty()
        }
      }
      .subscribe()
      .disposed(by: disposeBag)
  }
  
  private func bindProfileButton() {
    profileButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.navigationController?.pushViewController(self.modifyInformationViewController, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func tappedLogout() -> Observable<Void> {
    return Observable.create { observer in
      let alert = UIAlertController(
        title: "로그아웃",
        message: "정말로 로그아웃 하시겠습니까?",
        preferredStyle: .alert
      )
      
      let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          if Auth.auth().currentUser == nil {
            print("현재 로그인 된 사용자가 없습니다")
          } else {
            print("현재 로그인 된 사용자가 있습니다")
          }
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          let window = windowScene.windows.first
          window?.rootViewController = navController
          window?.makeKeyAndVisible()
        }
        observer.onNext(())
        observer.onCompleted()
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        observer.onCompleted()
      }
      alert.addAction(logoutAction)
      alert.addAction(cancelAction)
      
      self.present(alert, animated: true, completion: nil)
      return Disposables.create()
    }
  }
  
  private func tappedWithdrawal() -> Observable<Void> {
    return Observable.create { observer in
      let alert = UIAlertController(
        title: "회원탈퇴",
        message: "정말로 회원탈퇴 하시겠습니까?",
        preferredStyle: .alert
      )
      
      let withdrawAction = UIAlertAction(title: "회원탈퇴", style: .destructive) { _ in
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
          let window = windowScene.windows.first
          window?.rootViewController = navController
          window?.makeKeyAndVisible()
        }
        observer.onNext(())
        observer.onCompleted()
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        observer.onCompleted()
      }
      alert.addAction(withdrawAction)
      alert.addAction(cancelAction)
      
      self.present(alert, animated: true, completion: nil)
      return Disposables.create()
    }
  }
}
