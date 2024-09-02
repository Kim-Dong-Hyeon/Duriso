//
//  MyPageViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
  let viewModel = MyPageViewModel()
  let disposeBag = DisposeBag()
  
  let noticeViewController = NoticeViewController()
  
  
  private let profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 40
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray // 테스트용 배경색
    return imageView
  }()
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "조수환" // 테스트용 텍스트
    label.textColor = .black
    label.font = CustomFont.Body.font()
    return label
  }()
  
  private let profileButton: UIButton = {
    let button = UIButton()
    button.setTitle("내 정보", for: .normal)
    button.backgroundColor = .CLightBlue
    button.titleLabel?.font = CustomFont.Body3.font()
    button.layer.cornerRadius = 10
    return button
  }()
  
  private let myPageTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell")
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  private let infoLabel: UILabel = {
    let label = UILabel()
    label.text = "두리소 \n관리자: 김신이조 \n사업자 번호: \n전화번호"   // 테스트용
    label.font = CustomFont.Body3.font()
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
  }()
  
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
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.width.height.equalTo(80)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
      $0.leading.equalTo(profileImage.snp.trailing).offset(40)
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(profileImage.snp.bottom).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    myPageTableView.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(24)
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
    return 48
  }
}
