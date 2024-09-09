//
//  LegalNoticeViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/3/24.
//

import UIKit

import RxCocoa
import RxSwift

class LegalNoticeViewController: UIViewController {
  private let viewModel = LegalNoticeViewModel()
  private let disposeBag = DisposeBag()
  
  private let legalNoticeTableView = UITableView().then {
    $0.register(LegalNoticeTableViewCell.self, forCellReuseIdentifier: "LegalNoticeCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    configureUI()
    bindViewModel()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hidesBottomBarWhenPushed = true
  }
  
  
  private func configureUI() {
    [
      legalNoticeTableView
    ].forEach{ view.addSubview($0) }
    
    legalNoticeTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindViewModel() {
    viewModel.items
      .bind(to: legalNoticeTableView.rx.items(
        cellIdentifier: "LegalNoticeCell",
        cellType: LegalNoticeTableViewCell.self)
      ) { row, item, cell in
        cell.configure(with: item.title)
      }
      .disposed(by: disposeBag)
    
    legalNoticeTableView.rx.modelSelected(LegalNotice.self)
      .subscribe(onNext: { [weak self] item in
        let detailVC = LegalNoticeDetailViewController(notice: item)
        self?.navigationController?.pushViewController(detailVC, animated: true)
      })
      .disposed(by: disposeBag)
  }
}
