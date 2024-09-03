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
  
  private let tableLabel: UILabel = {
    let label = UILabel()
    label.font = CustomFont.Body2.font()
    return label
  }()
  
  private let tableImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(tableLabel)
    contentView.addSubview(tableImage)
    
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
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with title: String, imageName: String) {
          tableLabel.text = title
          tableImage.image = UIImage(systemName: imageName)
      }
  
}
