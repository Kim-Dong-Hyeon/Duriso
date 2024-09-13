//
//  CategoryCell.swift
//  Duriso
//
//  Created by 신상규 on 9/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class CategoryCell: UITableViewCell {
  
  private var disposeBag = DisposeBag()
  
  static let categoryCell = "CategoryCell"
  
  // MARK: - UI Components
  
  private let categoryLabel = UILabel().then {
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  // MARK: - Initializer
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup Methods
  
  private func setupView() {
    contentView.addSubview(categoryLabel)
  }
  
  private func setupConstraints() {
    categoryLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(16)
    }
  }
  
  // MARK: - Binding
  
  func configure(with viewModel: CategoryViewModel) {
          viewModel.categoryTitle
              .bind(to: categoryLabel.rx.text) // Observable을 UI 요소에 바인딩
              .disposed(by: disposeBag) // DisposeBag을 사용하여 구독 해제 관리
      }
  }

// MARK: - ViewModel

struct CategoryViewModel {
  let categoryTitle: Observable<String>
}
