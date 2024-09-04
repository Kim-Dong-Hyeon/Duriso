//
//  GuidelineViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

class GuidelineViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let tableViewModel = GuidelineTableViewModel()
  private let youtubeData = YoutubeData()
  private let news = GuidelineViewModel()
  
  private let urgentMessage = UILabel().then {
    $0.text = "긴급재난문자"
    $0.font = CustomFont.Head2.font()
  }
  
  private let urgentMessageContainer = UIView().then {
    $0.isHidden = false
    $0.alpha = 1.0
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 10
  }
  
  private let urgentMessageContainerLabel = UILabel().then {
    $0.text = ""
    $0.font = .systemFont(ofSize: 13)
  }
  
  private let disasterKitLabel = UILabel().then {
    $0.text = "비상시 재난키트 활용법"
    $0.font = CustomFont.Head2.font()
  }
  
  private let disasterKitButton = UIButton().then {
    $0.setImage(UIImage.emergencykit, for: .normal)
    $0.layer.cornerRadius = 10
    $0.clipsToBounds = true
  }
  
  private let atrickcollectionView = UICollectionView(frame: .zero,collectionViewLayout: GuidelineFlowLayout()).then {
    $0.isPagingEnabled = false
    $0.backgroundColor = .color(named: "CWhite")
    $0.showsHorizontalScrollIndicator = false
    $0.register(GuidelineCollectionViewCell.self, forCellWithReuseIdentifier: GuidelineCollectionViewCell.guidelineCollectionId)
  }
  
  private let atrickcollectionLabel = UILabel().then {
    $0.text = "행동요령 영상시청"
    $0.font = CustomFont.Head2.font()
  }
  
  private let atrickTableLabel = UILabel().then {
    $0.text = "재난시 행동요령"
    $0.font = CustomFont.Head2.font()
  }
  
  private lazy var atrickTableView = UITableView().then {
    $0.register(GuidelineTableViewCell.self, forCellReuseIdentifier: GuidelineTableViewCell.guidelineTableId)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.title = "행동요령"
    guidelineLayout()
    bindCollectionView()
    bindTableView()
    bindNews()
    disasterKitButtonTap()
  }
  
  private func bindCollectionView() {
    youtubeData.combinedData
      .bind(to: atrickcollectionView.rx.items(cellIdentifier: GuidelineCollectionViewCell.guidelineCollectionId, cellType: GuidelineCollectionViewCell.self)) { index, item, cell in
        cell.configure(with: item)
        
        cell.tapObservable
          .subscribe(onNext: { url in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          }).disposed(by: cell.disposeBag)
      }.disposed(by: disposeBag)
    youtubeData.fetchData()
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
  
  private func bindNews() {
    news.fetchData()
    
    news.title
      .bind(to: urgentMessageContainerLabel.rx.text)
      .disposed(by: disposeBag)
    
    news.writerName
      .subscribe(onNext: { writerName in
        // 필요한 경우 추가 업데이트
        print("Writer Name: \(writerName)")
      })
      .disposed(by: disposeBag)
  }
  
  private func disasterKitButtonTap() {
    disasterKitButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.pushViewController(GuidelineKitView(), animated: true)
      }).disposed(by: disposeBag)
  }
  
  private func guidelineLayout() {
    urgentMessageContainer.addSubview(urgentMessageContainerLabel)
    
    [
      urgentMessage,
      urgentMessageContainer,
      disasterKitLabel,
      disasterKitButton,
      atrickcollectionLabel,
      atrickcollectionView,
      atrickTableLabel,
      atrickTableView
    ].forEach { view.addSubview($0) }
    
    urgentMessage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    
    atrickcollectionLabel.snp.makeConstraints {
      $0.top.equalTo(urgentMessageContainerLabel.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    atrickcollectionView.snp.makeConstraints {
      $0.top.equalTo(atrickcollectionLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(400)
      $0.height.equalTo(200)
    }
    
    disasterKitLabel.snp.makeConstraints {
      $0.top.equalTo(atrickcollectionView.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    disasterKitButton.snp.makeConstraints {
      $0.top.equalTo(disasterKitLabel.snp.bottom).offset(8)
      $0.leading.equalTo(20)
      $0.width.equalTo(350)
      $0.height.equalTo(120)
    }
    
    atrickTableLabel.snp.makeConstraints {
      $0.top.equalTo(disasterKitButton.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    atrickTableView.snp.makeConstraints {
      $0.top.equalTo(atrickTableLabel.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(350)
      $0.height.equalTo(150)
    }
  }
}

