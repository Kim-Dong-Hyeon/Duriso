//
//  CopyrightTableViewCell.swift
//  Duriso
//
//  Created by 김동현 on 9/20/24.
//

import UIKit

import SnapKit

class CopyrightTableViewCell: UITableViewCell {
  
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
