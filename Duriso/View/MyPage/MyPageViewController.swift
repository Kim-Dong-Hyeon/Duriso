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
  
  
  private let profileImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 40
    $0.clipsToBounds = true
    $0.backgroundColor = .lightGray // 테스트용 배경색
  }
  
  private let nickNameLabel = UILabel().then {
    $0.text = "조수환" // 테스트용 텍스트
    $0.font = CustomFont.Body.font()
    $0.textColor = .CBlack
  }
  
  private let profileButton = UIButton().then {
    $0.setTitle("내 정보", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.layer.cornerRadius = 10
  }
  
  private let myPageTableView = UITableView().then {
    $0.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    $0.isScrollEnabled = false
  }
  
  private let infoLabel = UILabel().then {
    $0.text = "두리소 \n관리자: 김신이조 \n사업자 번호: \n전화번호"   // 테스트용
    $0.font = CustomFont.Body3.font()
    $0.textColor = .lightGray
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    configureUI()
    bindViewModel()
  }
  
  private func configureUI() {
    [
      profileImage,
      nickNameLabel,
      profileButton,
      myPageTableView,
      infoLabel
    ].forEach { view.addSubview($0) }
    
    myPageTableView.delegate = self
    
    
    profileImage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(-16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.width.height.equalTo(80)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
      $0.leading.equalTo(profileImage.snp.trailing).offset(40)
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(profileImage.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    myPageTableView.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.bottom.equalTo(infoLabel.snp.top).offset(-16)
    }
    
    infoLabel.snp.makeConstraints {
      $0.top.equalTo(myPageTableView.snp.bottom).offset(16)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
  }
  private func bindViewModel() {
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
          return self.handleLogout()
        case "공지사항":
          noticeViewController.title = item.title
          navigationController?.pushViewController(noticeViewController, animated: true)
          return .just(())
        case "법적고지":
          legalNoticeViewController.title = item.title
          navigationController?.pushViewController(legalNoticeViewController, animated: true)
          return .just(())
        default:
          return .empty()
        }
      }
      .subscribe()
      .disposed(by: disposeBag)
  }
  
  // 로그아웃 처리 메서드
  private func handleLogout() -> Observable<Void> {
    return Observable.create { observer in
      let alert = UIAlertController(
        title: "로그아웃",
        message: "정말로 로그아웃 하시겠습니까?",
        preferredStyle: .alert
      )
      
      let logoutAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
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
}

extension MyPageViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56
  }
}
