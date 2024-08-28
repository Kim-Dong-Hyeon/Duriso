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
  
  func configure(for row: Int) {
    switch row {
    case 0:
      textLabel?.text = "푸시알림"
      textLabel?.font = CustomFont.Body2.font()
      let toggleSwitch = UISwitch()
      accessoryView = toggleSwitch
    case 1:
      textLabel?.text = "공지사항"
      textLabel?.font = CustomFont.Body2.font()
      accessoryType = .disclosureIndicator
    case 2:
      textLabel?.text = "법적고지"
      textLabel?.font = CustomFont.Body2.font()
      accessoryType = .disclosureIndicator
    case 3:
      textLabel?.text = "오프라인 정보 다운로드"
      textLabel?.font = CustomFont.Body2.font()
      accessoryType = .disclosureIndicator
    case 4:
      textLabel?.text = "버전 정보"
      textLabel?.font = CustomFont.Body2.font()
      versionLabel.isHidden = false
    case 5:
      textLabel?.text = "로그아웃"
      textLabel?.font = CustomFont.Body2.font()
      accessoryType = .disclosureIndicator
    case 6:
      textLabel?.text = "회원탈퇴"
      textLabel?.font = CustomFont.Body2.font()
      accessoryType = .disclosureIndicator
    default:
      textLabel?.text = "기타 항목"
      textLabel?.font = CustomFont.Body2.font()
      accessoryType = .disclosureIndicator
    }
  }
  
  func setVersionText(_ text: String) {
    versionLabel.text = text
  }
}
