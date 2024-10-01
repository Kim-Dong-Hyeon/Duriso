//
//  GuidelineTableViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/27/24.
//

import UIKit

import SnapKit

class GuidelineTableViewCell: UITableViewCell {
  
  static let guidelineTableId = "GuidelineTableViewCell"
  
  private let tableLabel = UILabel().then {
    $0.font = CustomFont.Body2.font()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    GuidelineTableViewCellLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func GuidelineTableViewCellLayout() {
    contentView.addSubview(tableLabel)
    
    tableLabel.snp.makeConstraints {
      $0.leading.equalTo(contentView).offset(16)
      $0.centerY.equalTo(contentView)
    }
  }
  
  func configure(with title: String) {
      tableLabel.text = title
      accessoryType = .disclosureIndicator
  }
  
}
