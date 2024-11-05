//
//  NoticeTableViewCell.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/4/24.
//

import UIKit

import SnapKit

class NoticeTableViewCell: UITableViewCell {
  
  private let titleLabel = UILabel().then {
    $0.font = CustomFont.Head6.font()
  }
  
  private let dateLabel = UILabel().then {
    $0.font = CustomFont.Body4.font()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    [
      titleLabel,
      dateLabel
    ].forEach{ contentView.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.top).offset(8)
      $0.leading.equalTo(contentView.snp.leading).offset(32)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.trailing.equalTo(contentView.snp.trailing).inset(32)
    }
  }
  
  func configure(with notice: NoticeModel) {
    titleLabel.text = notice.title
    dateLabel.text = formatDate(notice.date.dateValue())
  }
  
  private func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
  }
}
