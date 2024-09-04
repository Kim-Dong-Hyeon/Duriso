//
//  GuidelineCollectionViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/26/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class GuidelineCollectionViewCell: UICollectionViewCell {
  
  static let guidelineCollectionId = "guidelineCollectionViewCell"
  
  private let thumbnailImageView = UIImageView()
  var disposeBag = DisposeBag()
  private let tapSubject = PublishSubject<URL>() // Rx 서브젝트
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    guidelineCollectionViewCellLayout()
    thumbnailTap()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func guidelineCollectionViewCellLayout() {
    thumbnailImageView.contentMode = .scaleAspectFit
    thumbnailImageView.clipsToBounds = true
    thumbnailImageView.layer.cornerRadius = 13
    contentView.addSubview(thumbnailImageView)
    
    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func thumbnailTap() {
    let tapGesture = UITapGestureRecognizer()
    self.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .map { [weak self] _ in self?.videoURL }
      .compactMap { $0 }
      .bind(to: tapSubject)
      .disposed(by: disposeBag)
  }
  
  func configure(with item: VideoThumbnailItem) {
    thumbnailImageView.image = UIImage(named: item.thumbnail.image)
    self.videoURL = item.videoItem.url
  }
  
  var tapObservable: Observable<URL> {
    return tapSubject.asObserver()
  }
  
  private var videoURL: URL?
}
