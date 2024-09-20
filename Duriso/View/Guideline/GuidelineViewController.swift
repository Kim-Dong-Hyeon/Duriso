//
//  GuidelineViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class GuidelineViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let tableViewModel = GuidelineTableViewModel()
  private let youtubeData = YoutubeData()
  private let news = GuidelineViewModel()
  
  private var messageIndex = 0
  private var timer: Timer?
  
  private let titleLabel = UILabel().then {
    $0.text = "행동요령"
    $0.font = CustomFont.Head.font()
  }
  
  private let urgentMessage = UILabel().then {
    $0.text = "긴급재난문자"
    $0.font = CustomFont.Head2.font()
  }
  
  private let urgentMessageContainer = UIView().then {
    $0.isHidden = false
    $0.alpha = 1.0
    $0.backgroundColor = .CLightBlue2
    $0.layer.borderColor = UIColor.CBlue.cgColor
    $0.layer.borderWidth = 0.5
    $0.layer.cornerRadius = 10
  }
  
  private let urgentMessageContainerLabel = UILabel().then {
    $0.text = ""
    $0.font = CustomFont.Body3.font()
    $0.numberOfLines = 3
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
    
    self.navigationItem.titleView = titleLabel
    guidelineLayout()
    bindCollectionView()
    bindTableView()
    bindNews()
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
    
    // 테이블 셀 선택 시
    atrickTableView.rx.modelSelected(Product.self)
      .bind { [weak self] product in
        print(product.title)
        
        let pdfViewController = GuidelinePDFViewController()
        switch product.title {
        case "재난키트 체크리스트":
          pdfViewController.pdfFileName = "EmergencyKit"
        case "국민행동요령":
          pdfViewController.pdfFileName = "Alertcon"
        case "지진":
          pdfViewController.pdfFileName = "earthquake"
        case "화재":
          pdfViewController.pdfFileName = "Fire"
        case "폭염":
          pdfViewController.pdfFileName = "HeatWave"
        case "대설":
          pdfViewController.pdfFileName = "Heavysnow"
        case "산사태":
          pdfViewController.pdfFileName = "Landslide"
        case "핵공격":
          pdfViewController.pdfFileName = "NuclearAttack"
        case "집중호우":
          pdfViewController.pdfFileName = "TorrentialRain"
        case "태풍":
          pdfViewController.pdfFileName = "Typhoon"
        default:
          pdfViewController.pdfFileName = nil
        }
        self?.navigationController?.pushViewController(pdfViewController, animated: true)
      }
      .disposed(by: disposeBag)
    
    tableViewModel.fetchItem()
  }
  
  private func bindNews() {
    news.fetchData()
    
    news.messageContent
      .observe(on: MainScheduler.instance)
      .bind(to: urgentMessageContainerLabel.rx.text)
      .disposed(by: disposeBag)
    
    timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
      self?.updateMessageContent()
    }
  }
  
  private func updateMessageContent() {
    let messages = news.getRecentMessages()
    
    if !messages.isEmpty {
      let index = messageIndex % messages.count
      urgentMessageContainerLabel.text = messages[index]
      messageIndex += 1
    }
  }
  
  private func guidelineLayout() {
    urgentMessageContainer.addSubview(urgentMessageContainerLabel)
    
    [
      urgentMessage,
      urgentMessageContainer,
      atrickcollectionLabel,
      atrickcollectionView,
      atrickTableLabel,
      atrickTableView
    ].forEach { view.addSubview($0) }
    
    urgentMessage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    urgentMessageContainer.snp.makeConstraints {
      $0.top.equalTo(urgentMessage.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.height.equalTo(80)
    }
    
    urgentMessageContainerLabel.snp.makeConstraints {
      $0.centerY.equalTo(urgentMessageContainer.snp.centerY)
      $0.edges.equalTo(urgentMessageContainer.snp.edges).inset(8)
      $0.width.equalTo(340)
    }
    
    atrickcollectionLabel.snp.makeConstraints {
      $0.top.equalTo(urgentMessageContainer.snp.bottom).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    atrickcollectionView.snp.makeConstraints {
      $0.top.equalTo(atrickcollectionLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(400)
      $0.height.equalTo(160)
    }
    
    atrickTableLabel.snp.makeConstraints {
      $0.top.equalTo(atrickcollectionView.snp.bottom).offset(24)
      $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    atrickTableView.snp.makeConstraints {
      $0.top.equalTo(atrickTableLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
//      $0.height.equalTo(250)
    }
  }
}

