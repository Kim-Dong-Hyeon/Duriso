//
//  NoticeViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class NoticeViewController: UIViewController {
  private let viewModel = NoticeViewModel()
  private let disposeBag = DisposeBag()
  
  private let noticeTableView = UITableView().then {
    $0.register(NoticeTableViewCell.self, forCellReuseIdentifier: "NoticeCell")
  }
  
  private let noneNoticeLabel = UILabel().then {
    $0.text = "공지사항 없음"
    $0.font = CustomFont.Deco4.font()
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.tabBarController?.tabBar.isHidden = true
    
    noticeTableView.rowHeight = 64
    
    ConfigureUI()
    bindTableView()
    showData()
  }
  
  private func ConfigureUI() {
    [
      noticeTableView,
      noneNoticeLabel
    ].forEach{ view.addSubview($0) }
    
    noticeTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    noneNoticeLabel.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.centerY.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindTableView() {
    viewModel.notices
      .bind(to: noticeTableView.rx.items(
        cellIdentifier: "NoticeCell",
        cellType: NoticeTableViewCell.self)) { row, notice, cell in
        cell.configure(with: notice)
      }
      .disposed(by: disposeBag)
    
    noticeTableView.rx.modelSelected(NoticeModel.self)
      .subscribe(onNext: { [weak self] notice in
        let detailVC = NoticeDetailViewController()
        detailVC.configure(with: notice)
        self?.navigationController?.pushViewController(detailVC, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func showData() {
    viewModel.notices
      .subscribe(onNext: { [weak self] notices in
        if notices.isEmpty {
          self?.noneNoticeLabel.isHidden = false
          self?.noticeTableView.isHidden = true
        } else {
          self?.noneNoticeLabel.isHidden = true
          self?.noticeTableView.isHidden = false
        }
      })
      .disposed(by: disposeBag)
  }
}
