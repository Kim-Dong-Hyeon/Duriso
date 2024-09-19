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
  
  // MARK: - UI 컴포넌트
  private let categoryLabel = UILabel().then {
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  // MARK: - 초기화
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - 설정 메서드
  private func setupView() {
    contentView.addSubview(categoryLabel)
  }
  
  private func setupConstraints() {
    categoryLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(16)
    }
  }
  
  // MARK: - 바인딩
  func configure(with viewModel: CategoryViewModel) {
    viewModel.categoryTitle
      .bind(to: categoryLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  // MARK: - 재사용 준비
  
  override func prepareForReuse() {
    super.prepareForReuse()
    categoryLabel.text = nil
  }
}
// MARK: - ViewModel

struct CategoryViewModel {
  let categoryTitle: Observable<String>
}
