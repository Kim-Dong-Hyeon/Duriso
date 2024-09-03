//
//  BoardCollectionViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BoardCollectionViewCell: UICollectionViewCell {
  
  static let boardCell = "BoardCollectionViewCell"
  
  private let notificationButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .lightGray
    button.layer.cornerRadius = 15
    button.titleLabel?.font = CustomFont.Deco4.font()
    button.titleLabel?.numberOfLines = 1
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.titleLabel?.minimumScaleFactor = 0.5
    button.imageView?.contentMode = .scaleAspectFit
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    contentView.addSubview(notificationButton)
    
    notificationButton.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(10)
    }
  }
  
  func configure(with model: SomeDataModel) {
    notificationButton.setTitle(model.name, for: .normal)
    
    notificationButton.setImage(nil, for: .normal)
    
    if let image = model.image {
      let tintedImage = image.withRenderingMode(.alwaysTemplate)
      notificationButton.setImage(tintedImage, for: .normal)
      notificationButton.tintColor = .red
    }
  }
}
