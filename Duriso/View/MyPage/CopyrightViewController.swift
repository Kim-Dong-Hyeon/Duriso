//
//  CopyrightViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/20/24.
//

import UIKit

import RxCocoa
import RxSwift

class CopyrightViewController: UIViewController {
  private let viewModel = CopyrightViewModel()
  private let disposeBag = DisposeBag()
  
  private let copyrightTableView = UITableView().then {
    $0.register(CopyrightTableViewCell.self, forCellReuseIdentifier: "CopyrightCell")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.tabBarController?.tabBar.isHidden = true

    copyrightTableView.rowHeight = 48
    
    configureUI()
    bindViewModel()
  }
  
  private func configureUI() {
    [
      copyrightTableView
    ].forEach{ view.addSubview($0) }
    
    copyrightTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func bindViewModel() {
    viewModel.items
      .bind(to: copyrightTableView.rx.items(
        cellIdentifier: "CopyrightCell",
        cellType: CopyrightTableViewCell.self)
      ) { row, item, cell in
        cell.configure(with: item.title)
      }
      .disposed(by: disposeBag)
    
    copyrightTableView.rx.modelSelected(Copyright.self)
      .subscribe(onNext: { [weak self] item in
        let detailVC = CopyrightDetailViewController(copyright: item)
        self?.navigationController?.pushViewController(detailVC, animated: true)
      })
      .disposed(by: disposeBag)
  }
}
