//
//  BoardTableViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/30/24.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

protocol BoardTableViewCellDelegate: AnyObject {
  func didTapCell(with post: Posts)
}

class BoardTableViewCell: UITableViewCell {
  static let boardTableCell = "BoardTableViewCell"
  private let disposeBag = DisposeBag()
  private var post: Posts?
  private let regionFetcher = RegionFetcher()
  
  weak var delegate: BoardTableViewCellDelegate?
  
  private let titleLabel = UILabel().then {
    $0.font = CustomFont.Head2.font()
  }
  
  private let contentLabel = UILabel().then {
    $0.font = CustomFont.Body2.font()
  }
  
  private let addressLabel = UILabel().then {
    $0.font = CustomFont.Body3.font()
  }
  
  private let timeLabel = UILabel().then {
    $0.font = CustomFont.Body3.font()
  }
  
  private let categorysLabel = UILabel().then {
    $0.font = CustomFont.sub.font()
    $0.textColor = .gray
    $0.textAlignment = .left
  }
  
  private let postImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
    setupGesture()
    contentView.isUserInteractionEnabled = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    [
      titleLabel,
      contentLabel,
      addressLabel,
      timeLabel,
      postImageView,
      categorysLabel
    ].forEach { contentView.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(10)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.lessThanOrEqualTo(contentView).offset(-100) // trailing 제약으로 너비 유동성 처리
    }
    
    // 여기서 hugging priority와 compression resistance 설정
    titleLabel.setContentHuggingPriority(.required, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    
    categorysLabel.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel.snp.centerY)
      $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
      $0.width.equalTo(70)
    }
    
    postImageView.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.trailing.equalTo(contentView).offset(-10)
      $0.width.height.equalTo(80)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(postImageView.snp.leading).offset(-10)
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(16)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
      $0.bottom.equalTo(contentView).offset(-10)
    }
    
    timeLabel.snp.makeConstraints {
      $0.trailing.equalTo(postImageView.snp.leading).offset(8)
      $0.centerY.equalTo(addressLabel)
      $0.width.equalTo(80)
    }
  }
  
  private func setupGesture() {
    let tapGesture = UITapGestureRecognizer()
    addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .subscribe(onNext: { [weak self] _ in
        guard let post = self?.post else { return }
        self?.delegate?.didTapCell(with: post)
      })
      .disposed(by: disposeBag)
  }
  
  func configure(with post: Posts) {
    self.post = post
    titleLabel.text = post.title
    contentLabel.text = post.contents
    addressLabel.text = "\(post.si) \(post.gu) \(post.dong)"
    timeLabel.text = timeAgo(from: post.posttime)
    categorysLabel.text = "#\(post.category)"
    
    if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
      postImageView.kf.setImage(
        with: url,
        options: [
          .transition(.fade(0.2)),
          .cacheOriginalImage
        ]
      )
      postImageView.snp.remakeConstraints {
        $0.centerY.equalTo(contentView)
        $0.trailing.equalTo(contentView).offset(-10)
        $0.width.height.equalTo(80)
      }
      contentLabel.snp.remakeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(contentView).offset(10)
        $0.trailing.equalTo(postImageView.snp.leading).offset(-10)
      }
    } else {
      postImageView.snp.remakeConstraints {
        $0.centerY.equalTo(contentView)
        $0.trailing.equalTo(contentView).offset(-10)
        $0.width.equalTo(0)
        $0.height.equalTo(80)
      }
      contentLabel.snp.remakeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        $0.leading.equalTo(contentView).offset(10)
        $0.trailing.equalTo(contentView).offset(-10)
      }
    }
  }
  
  private func timeAgo(from date: Date) -> String {
    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)
    
    if let days = components.day, days > 0 {
      return "\(days)일 전"
    } else if let hours = components.hour, hours > 0 {
      return "\(hours)시간 전"
    } else if let minutes = components.minute, minutes > 0 {
      return "\(minutes)분 전"
    } else {
      return "방금 전"
    }
  }
}

extension UIImageView {
  func loadImage(from urlString: String?) {
    guard let urlString = urlString, let url = URL(string: urlString) else {
      self.image = UIImage(named: "placeholder")
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        print("Failed to load image: \(error.localizedDescription)")
        DispatchQueue.main.async {
          self.image = UIImage(named: "placeholder")
        }
        return
      }
      
      guard let data = data, let image = UIImage(data: data) else {
        DispatchQueue.main.async {
          self.image = UIImage(named: "placeholder")
        }
        return
      }
      
      DispatchQueue.main.async {
        self.image = image
      }
    }.resume()
  }
}
