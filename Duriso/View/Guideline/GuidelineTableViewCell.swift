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
  
  private let tableImage = UIImageView().then {
    $0.image = UIImage()
    $0.contentMode = .scaleAspectFit
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    GuidelineTableViewCellLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func GuidelineTableViewCellLayout() {
    
    [
      tableLabel,
      tableImage
    ].forEach { contentView.addSubview($0) }
    
    tableLabel.snp.makeConstraints {
      $0.leading.equalTo(contentView).offset(16)
      $0.centerY.equalTo(contentView)
    }
    
    tableImage.snp.makeConstraints {
      $0.trailing.equalTo(contentView).offset(-16)
      $0.centerY.equalTo(contentView)
      $0.width.height.equalTo(24)
    }
  }
  
  func configure(with title: String, imageName: String) {
    tableLabel.text = title
    tableImage.image = UIImage(systemName: imageName)
  }
  
}
