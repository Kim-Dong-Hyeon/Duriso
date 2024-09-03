//
//  GuidelineViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class GuidelineViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let tableViewModel = GuidelineTableViewModel()
  
  
  // 나중에 ViewModel로 바꿔넣을 예정
  private let videos = BehaviorRelay<[GuidelineModel]>(value: [
    GuidelineModel(title: "국민행동요령", url: URL(string: "https://www.youtube.com/watch?v=DxAQi6wyeeY")!),
    GuidelineModel(title: "지진 및 해일피해", url: URL(string: "https://www.youtube.com/watch?v=7IAg2V7P89w")!),
    GuidelineModel(title: "핵공격", url: URL(string: "https://www.youtube.com/watch?v=wiGGYdKHtT0")!),
    GuidelineModel(title: "화재발생", url: URL(string: "https://www.youtube.com/watch?v=W6Zr5yo5gls")!),
    GuidelineModel(title: "집중호우", url: URL(string: "https://www.youtube.com/watch?v=3ZXF4TAB9lc")!),
    GuidelineModel(title: "태풍", url: URL(string: "https://www.youtube.com/watch?v=F5vugtauQT8")!),
    GuidelineModel(title: "강풍", url: URL(string: "https://www.youtube.com/watch?v=M9YwbMXiWQI")!),
    GuidelineModel(title: "산사태", url: URL(string: "https://www.youtube.com/watch?v=XTwjVTq64a0")!),
    GuidelineModel(title: "폭염", url: URL(string: "https://www.youtube.com/watch?v=yXQeLH2QAAs")!)
  ])
  
  private let urgentMessage: UILabel = {
    let label = UILabel()
    label.text = "긴급재난문자"
    label.font = CustomFont.Head2.font()
    return label
  }()
  
  private let urgentMessageContainer: UIView = {
    let view = UIView()
    view.isHidden = false
    view.alpha = 1.0
    view.backgroundColor = .lightGray
    view.layer.cornerRadius = 10
    return view
  }()
  
  private let urgentMessageContainerLabel: UILabel = {
    let label = UILabel()
    label.text = "🚨[긴급] : "
    label.font = CustomFont.Body2.font()
    return label
  }()
  
  private let disasterKitLabel: UILabel = {
    let label = UILabel()
    label.text = "비상시 재난키트 활용법"
    label.font = CustomFont.Head2.font()
    return label
  }()
  
  private let disasterKit: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleToFill
    imageView.image = .emergencykit
    return imageView
  }()
  
  private lazy var atrickcollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: GuidelineFlowLayout())
    collectionView.isPagingEnabled = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(GuidelineCollectionViewCell.self, forCellWithReuseIdentifier: GuidelineCollectionViewCell.guidelineCollectionId)
    return collectionView
  }()
  
  private let atrickcollectionLabel: UILabel = {
    let label = UILabel()
    label.text = "행동요령 영상시청"
    label.font = CustomFont.Head2.font()
    return label
  }()
  
  private let atrickTableLabel: UILabel = {
    let label = UILabel()
    label.text = "재난시 행동요령"
    label.font = CustomFont.Head2.font()
    return label
  }()
  
  private lazy var atrickTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(GuidelineTableViewCell.self, forCellReuseIdentifier: GuidelineTableViewCell.guidelineTableId)
    return tableView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    guidelineLayout()
    bindCollectionView()
    bindTableView()
  }
  
  private func bindCollectionView() {
    videos
      .bind(to: atrickcollectionView.rx.items(cellIdentifier: GuidelineCollectionViewCell.guidelineCollectionId, cellType: GuidelineCollectionViewCell.self)) { index, model, cell in
        cell.configure(with: model.url)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindTableView() {
    tableViewModel.items.bind(to: atrickTableView.rx.items(cellIdentifier: GuidelineTableViewCell.guidelineTableId, cellType: GuidelineTableViewCell.self)) { row, product, cell in
      cell.configure(with: product.title, imageName: product.imageName)
    }.disposed(by: disposeBag)
    
    atrickTableView.rx.modelSelected(Product.self).bind { product in
      print(product.title)
    }.disposed(by: disposeBag)
    
    tableViewModel.fetchItem()
  }
  
  
  
  private func guidelineLayout() {
    urgentMessageContainer.addSubview(urgentMessageContainerLabel)
    
    [urgentMessage, urgentMessageContainer, disasterKitLabel, disasterKit, atrickcollectionLabel, atrickcollectionView, atrickTableLabel, atrickTableView].forEach { view.addSubview($0) }
    
    urgentMessage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
      $0.leading.equalTo(30)
    }
    
    urgentMessageContainer.snp.makeConstraints {
      $0.top.equalTo(urgentMessage.snp.bottom).offset(8)
      $0.leading.equalTo(20)
      $0.height.equalTo(40)
      $0.width.equalTo(350)
    }
    
    urgentMessageContainerLabel.snp.makeConstraints {
      $0.centerY.equalTo(urgentMessageContainer.snp.centerY)
      $0.leading.equalTo(10)
    }
    
    disasterKitLabel.snp.makeConstraints {
      $0.top.equalTo(urgentMessageContainer.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    disasterKit.snp.makeConstraints {
      $0.top.equalTo(disasterKitLabel.snp.bottom).offset(8)
      $0.leading.equalTo(20)
      $0.width.equalTo(350)
      $0.height.equalTo(120)
    }
    
    atrickcollectionLabel.snp.makeConstraints {
      $0.top.equalTo(disasterKit.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    atrickcollectionView.snp.makeConstraints {
      $0.top.equalTo(atrickcollectionLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(350)
      $0.height.equalTo(100)
    }
    
    atrickTableLabel.snp.makeConstraints {
      $0.top.equalTo(atrickcollectionView.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    atrickTableView.snp.makeConstraints {
      $0.top.equalTo(atrickTableLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(350)
      $0.height.equalTo(100)
    }
  }
}
