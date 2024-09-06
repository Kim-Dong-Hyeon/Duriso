//
//  BoardTableViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/30/24.
//

import Foundation
import UIKit
import SnapKit

class BoardTableViewCell: UITableViewCell {
  
  static let boardTableCell = "BoardTableCell"
  
  public let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "제목"
    label.font = CustomFont.Head2.font()
    return label
  }()
  
  public let contentLabel: UILabel = {
    let label = UILabel()
    label.text = "내용"
    label.font = CustomFont.Body2.font()
    return label
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.text = "사랑시 고백구 행복동"
    label.font = CustomFont.Body3.font()
    return label
  }()
  
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.text = "0분전"
    label.font = CustomFont.Body3.font()
    return label
  }()
  
  private let reportButton: UIButton = {
    let button = UIButton()
    button.setTitle("🚨", for: .normal)
    button.backgroundColor = .clear
    return button
  }()
  
  private let userSetImage: UIImageView = {
    let view = UIImageView()
    view.image = .writingButton
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    [
      titleLabel,
      contentLabel,
      addressLabel,
      reportButton,
      userSetImage,
      timeLabel
    ].forEach { contentView.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(10)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(reportButton.snp.leading).offset(-10)
    }
    
    reportButton.snp.makeConstraints {
      $0.trailing.equalTo(userSetImage.snp.leading).offset(-30)
      $0.centerY.equalTo(titleLabel)
    }
    
    userSetImage.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.trailing.equalTo(contentView).offset(-30)
      $0.width.height.equalTo(70)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(contentView).offset(-10)
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(16)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
      $0.bottom.equalTo(contentView).offset(-10)
    }
    
    timeLabel.snp.makeConstraints {
      $0.trailing.equalTo(userSetImage.snp.leading).offset(-30)
      $0.centerY.equalTo(addressLabel)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
