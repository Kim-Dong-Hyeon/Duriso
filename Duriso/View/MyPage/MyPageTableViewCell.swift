//
//  MyPageTableViewCell.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/28/24.
//

import UIKit
import SnapKit

class MyPageTableViewCell: UITableViewCell {
  
  private let versionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = CustomFont.Body2.font()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    contentView.addSubview(versionLabel)
    
    versionLabel.snp.makeConstraints {
      $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
      $0.centerY.equalTo(contentView.snp.centerY)
    }
  }
  
  func configure(with item: MyPageModel) {
    // 타이틀 설정
    textLabel?.text = item.title
    
    // 셀 유형에 따라 UI 설정
    switch item.type {
    case .toggle:
      let toggleSwitch = UISwitch()
      accessoryView = toggleSwitch
      accessoryType = .none
      versionLabel.isHidden = true
    case .disclosure:
      accessoryType = .disclosureIndicator
      versionLabel.isHidden = true
    case .version(let version):
      accessoryType = .none
      versionLabel.text = version
      versionLabel.isHidden = false
    }
  }
}
