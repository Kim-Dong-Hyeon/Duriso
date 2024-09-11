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
  
  static let categoryCell = "CategoryCell"
  
  public let categoryLabel = UILabel().then {
    $0.text = ""
    $0.font = CustomFont.Head3.font()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    self.addSubview(categoryLabel)
    
    categoryLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with category: Category) {
    categoryLabel.text = category.title
  }
}
