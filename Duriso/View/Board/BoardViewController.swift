//
//  BoardViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BoardViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let tableItems = BehaviorRelay<[Post]>(value: []) //
  
  private let notificationHeadLabel = UILabel().then {
    $0.text = "우리동네 알리미"
    $0.font = CustomFont.Deco.font()
  }
  
  private let notificationHeadImage = UIImageView().then {
    $0.image = UIImage(systemName: "megaphone")
    $0.tintColor = .red
  }
  
  private let notificationLineView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let writingButton = UIButton().then {
    $0.setTitle("+글쓰기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 15
    $0.titleLabel?.font = CustomFont.Deco4.font()
  }
  
  private let notificationCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: BoardCollectionViewCell.boardCell)
    return collectionView
  }()
  
  private let notificationLineView1 = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let notificationTableView = UITableView().then {
    $0.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.boardTableCell)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupLayout()
    writingButtonTap()
    bindTableView()
    bindCollectionView()
  }
  
  private func bindCollectionView() {
    let dataSource = Observable.just(SomeDataModel.Mocks.getDataSource())
    
    dataSource
      .bind(to: notificationCollectionView.rx.items(cellIdentifier: BoardCollectionViewCell.boardCell, cellType: BoardCollectionViewCell.self)) { row, model, cell in
        cell.configure(with: model)
      }
      .disposed(by: disposeBag)
    
    notificationCollectionView.rx.modelSelected(SomeDataModel.self)
      .subscribe(onNext: { model in
        print("Selected: \(model.name)")
      })
      .disposed(by: disposeBag)
  }
  
  private func writingButtonTap() {
    writingButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.reportNavigation()
      })
      .disposed(by: disposeBag)
  }
  
  private func reportNavigation() {
    let reportViewController = ReportViewController()
    reportViewController.onPostAdded = { [weak self] title, content in
      guard let self = self else { return }
      let newPost = Post(title: title, content: content, createdAt: Date()) //새로운 게시글 생성
      var currentItems = self.tableItems.value //테이블아이템의 벨류를 가져옴
      currentItems.append(newPost) //어펜드로 새로운 게시글 추가
      self.tableItems.accept(currentItems) // 게시글 생성 시간 계산하여 설정해줌
    }
    self.navigationController?.pushViewController(reportViewController, animated: true)
  }
  
  private func bindTableView() {
    tableItems
      .bind(to: notificationTableView.rx.items(cellIdentifier: BoardTableViewCell.boardTableCell, cellType: BoardTableViewCell.self)) { index, post, cell in
        cell.configure(with: post) // 셀마다 게시글의 데이터를 설정해줌
      }
      .disposed(by: disposeBag)
  }
  
  private func setupLayout() {
    [
      notificationHeadLabel,
      notificationHeadImage,
      notificationLineView,
      notificationCollectionView,
      notificationLineView1,
      notificationTableView,
      writingButton
    ].forEach { view.addSubview($0) }
    
    notificationHeadLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.equalTo(30)
    }
    
    notificationHeadImage.snp.makeConstraints {
      $0.leading.equalTo(notificationHeadLabel.snp.trailing).offset(8)
      $0.centerY.equalTo(notificationHeadLabel)
      $0.size.equalTo(25)
    }
    
    notificationLineView.snp.makeConstraints {
      $0.top.equalTo(notificationHeadLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    notificationCollectionView.snp.makeConstraints {
      $0.top.equalTo(notificationLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(60)
    }
    
    notificationLineView1.snp.makeConstraints {
      $0.top.equalTo(notificationCollectionView.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    notificationTableView.snp.makeConstraints {
      $0.top.equalTo(notificationLineView1.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(500)
    }
    
    writingButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(100)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(30)
      $0.width.equalTo(80)
    }
  }
}
