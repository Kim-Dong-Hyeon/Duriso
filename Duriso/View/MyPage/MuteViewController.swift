//
//  MuteViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/27/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import RxCocoa
import RxSwift
import SnapKit

class MuteViewController: UIViewController {
  
  private let viewModel: MuteViewModel
  private let disposeBag = DisposeBag()
  
  private let muteTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(MuteTableViewCell.self, forCellReuseIdentifier: "MuteTableViewCell")
    return tableView
  }()
  
  lazy var editButton = UIBarButtonItem().then {
    $0.title = "편집"
    $0.style = .plain
  }
  
  init(viewModel: MuteViewModel = MuteViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    bindViewModel()
    fetchBlockedUsers()
  }
  
  private func configureUI() {
    view.backgroundColor = .white
    self.navigationItem.title = "차단 사용자"
    self.navigationItem.rightBarButtonItem = editButton
    view.addSubview(muteTableView)
    
    muteTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindViewModel() {
    viewModel.blockedUserNicknames
      .bind(to: muteTableView.rx.items(cellIdentifier: "MuteTableViewCell", cellType: MuteTableViewCell.self)) { row, nickname, cell in
        cell.configure(with: nickname)
        self.viewModel.isEditing
          .subscribe(onNext: { isEditing in
            cell.isEditingMode = isEditing
          })
          .disposed(by: cell.disposeBag)
      }
      .disposed(by: disposeBag)
    
    editButton.rx.tap
      .bind(to: viewModel.editButtonTapped)
      .disposed(by: disposeBag)
    
    muteTableView.rx.itemDeleted
      .subscribe(onNext: { indexPath in
        self.viewModel.deleteBlockedUser(at: indexPath.row)
      })
      .disposed(by: disposeBag)
    
    viewModel.isEditing
      .subscribe(onNext: { isEditing in
        self.editButton.title = isEditing ? "완료" : "편집"
        self.muteTableView.setEditing(isEditing, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchBlockedUsers() {
    guard let user = Auth.auth().currentUser else { return }
    let uid = user.uid
    
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(uid)
    
    userRef.getDocument { [weak self] (document, error) in
      if let document = document, document.exists {
        if let blockedUsers = document.data()?["blockedusers"] as? [String] {
          let validBlockedUsers = blockedUsers.filter { !$0.isEmpty }
          print("유효한 차단된 사용자 목록: \(validBlockedUsers)")
          self?.viewModel.blockedUserIDs = validBlockedUsers
          self?.fetchNicknames(for: validBlockedUsers)
        } else {
          print("blockedusers 필드가 없습니다.")
        }
      } else {
        print("문서를 찾을 수 없습니다: \(error?.localizedDescription ?? "")")
      }
    }
  }
  
  private func fetchNicknames(for blockedUserIDs: [String]) {
    let db = Firestore.firestore()
    
    let nicknameObservables: [Observable<String>] = blockedUserIDs.map { userID in
      return Observable.create { observer in
        db.collection("users").document(userID).getDocument { documentSnapshot, error in
          if let document = documentSnapshot, document.exists,
             let nickname = document.data()?["nickname"] as? String {
            observer.onNext(nickname)
          } else {
            observer.onNext("Unknown")
          }
          observer.onCompleted()
        }
        return Disposables.create()
      }
    }
    
    Observable.zip(nicknameObservables)
      .subscribe(onNext: { [weak self] nicknames in
        self?.viewModel.blockedUserNicknames.onNext(nicknames)
        print("차단된 사용자 닉네임 목록: \(nicknames)")
      }, onError: { error in
        print("닉네임을 가져오는 중 오류 발생: \(error)")
      })
      .disposed(by: disposeBag)
  }
}
