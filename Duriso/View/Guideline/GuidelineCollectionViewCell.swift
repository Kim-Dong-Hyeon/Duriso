//
//  GuidelineCollectionViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/26/24.
//

import UIKit
import SnapKit

class GuidelineCollectionViewCell: UICollectionViewCell {
  
  static let guidelineCollectionId = "guidelineCollectionViewCell"
  
  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.backgroundColor = generateRandomColor()
    contentView.addSubview(label)
    
    label.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-10)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with text: String) {
    label.text = text
  }
  
  private func generateRandomColor() -> UIColor {
    return UIColor(
      red: CGFloat(drand48()),
      green: CGFloat(drand48()),
      blue: CGFloat(drand48()),
      alpha: 1.0
    )
  }
}
