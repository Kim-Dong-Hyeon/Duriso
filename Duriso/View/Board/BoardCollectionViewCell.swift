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
    $0.layer.cornerRadius = 15
    $0.titleLabel?.font = CustomFont.Deco4.font()
    $0.titleLabel?.numberOfLines = 1
    $0.titleLabel?.adjustsFontSizeToFitWidth = true
    $0.isUserInteractionEnabled = true
    $0.titleLabel?.minimumScaleFactor = 0.5
    $0.imageView?.contentMode = .scaleAspectFit
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
  
  func bindTapAction(onTap: @escaping () -> Void) {
    notificationButton.rx.tap
      .subscribe(onNext: {
        onTap()  //버튼이 눌렸을때
      })
      .disposed(by: disposeBag)
  }
}
