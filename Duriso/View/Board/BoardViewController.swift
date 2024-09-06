//
//  BoardViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BoardViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  let tableItems = BehaviorRelay<[String]>(value: [])
  
  private let notificationHeadLabel: UILabel = {
    let label = UILabel()
    label.text = "우리동네 알리미"
    label.font = CustomFont.Deco.font()
    return label
  }()
  
  private let notificationHeadImage: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(systemName: "megaphone")
    image.tintColor = .red
    return image
  }()
  
  private let notificationLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  private let writingButton: UIButton = {
    let button = UIButton()
    button.setTitle("+글쓰기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .lightGray
    button.layer.cornerRadius = 15
    button.titleLabel?.font = CustomFont.Deco4.font()
    return button
  }()
  
  private let notificationCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: BoardCollectionViewCell.boardCell)
    return collectionView
  }()
  
  private let notificationLineView1: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  private let notificationTableView: UITableView = {
    let view = UITableView()
    view.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.boardTableCell)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupLayout()
    bindTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    bindCollectionView()
    writingButtonTap()
    //    bindTableView()
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
    self.navigationController?.pushViewController(reportViewController, animated: true)
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
  
  private func bindTableView() {
    tableItems.bind(to: notificationTableView.rx.items(cellIdentifier: "cell")) { index, item, cell in
      cell.textLabel?.text = item
    }.disposed(by: disposeBag)
  }
}
