//
//  BoardCollectionViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/29/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BoardCollectionViewCell: UICollectionViewCell {
  
  static let boardCell = "BoardCollectionViewCell"
  
  private var disposeBag = DisposeBag()
  
  private let notificationButton = UIButton().then {
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 20
    $0.layer.borderColor = UIColor.systemGray4.cgColor
    $0.layer.borderWidth = 1.0
    $0.titleLabel?.font = CustomFont.Head3.font()
    $0.titleLabel?.numberOfLines = 1
    $0.titleLabel?.adjustsFontSizeToFitWidth = true
    $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    $0.titleLabel?.textAlignment = .center
//    $0.isUserInteractionEnabled = true
//    $0.titleLabel?.minimumScaleFactor = 0.5
    $0.imageView?.contentMode = .scaleAspectFill
  }
  
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
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.greaterThanOrEqualTo(40)
      $0.width.greaterThanOrEqualToSuperview()
    }
  }
  
  func configure(with model: SomeDataModel) {
    notificationButton.setTitle(model.name, for: .normal)
//    notificationButton.setImage(nil, for: .normal)
    
    if let image = model.image {
      let tintedImage = image.withRenderingMode(.alwaysTemplate)
      notificationButton.setImage(tintedImage, for: .normal)
      notificationButton.tintColor = .CWhite
    }
  }
  
  func bindTapAction(onTap: @escaping () -> Void) {
    notificationButton.rx.tap
      .subscribe(onNext: {
        onTap()  // 버튼이 눌렸을 때
      })
      .disposed(by: disposeBag)
  }
  
  // 텍스트 길이에 맞는 너비 계산
  func calculateCellWidth() -> CGFloat {
    let buttonSize = notificationButton.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    return buttonSize.width + 32  // 여백을 추가해서 버튼의 크기를 정함
  }
}
