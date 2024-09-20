//
//  OfflinePageViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

/// 오프라인 상태를 표시하는 뷰 컨트롤러
class OfflinePageViewController: UIViewController {
  
  // MARK: - Properties
  
  private let viewName: String
  private let viewModel: OfflinePageViewModel
  private let disposeBag = DisposeBag()
  
  /// 오프라인 메시지를 표시하는 레이블
  private let messageLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 16)
  }
  
  // MARK: - Initialization
  
  /// ViewModel을 넘겨받아 초기화
  init(viewModel: OfflinePageViewModel, viewName: String) {
    self.viewModel = viewModel
    self.viewName = viewName
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.title = self.viewName
    setupUI()
    bindViewModel()
  }
  
  // MARK: - UI Setup
  
  /// UI 요소를 설정하고 제약 조건을 추가
  private func setupUI() {
    [messageLabel].forEach { view.addSubview($0) }
    
    messageLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  // MARK: - Binding
  
  /// ViewModel과 View를 바인딩
  private func bindViewModel() {
    viewModel.message
      .bind(to: messageLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
