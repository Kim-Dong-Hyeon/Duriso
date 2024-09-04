//
//  LegalNoticeTableCell.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/3/24.
//

import UIKit

import SnapKit

class LegalNoticeTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func configure(with item: String) {
    textLabel?.text = item
    accessoryType = .disclosureIndicator
  }
}
