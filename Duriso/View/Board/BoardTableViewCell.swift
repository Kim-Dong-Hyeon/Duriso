//
//  BoardTableViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/30/24.
//

import UIKit

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
  
  weak var delegate: BoardTableViewCellDelegate?
  
  private let titleLabel = UILabel().then {
    $0.font = CustomFont.Head2.font()
  }
  
  private let contentLabel = UILabel().then {
    $0.font = CustomFont.Body3.font()
    $0.numberOfLines = 2
  }
  
  private let addressLabel = UILabel().then {
    $0.font = CustomFont.Body3.font()
  }
  
  private let timeLabel = UILabel().then {
    $0.font = CustomFont.Body3.font()
  }
  
  private let categorysLabel = UILabel().then {
    $0.font = CustomFont.Head3.font()
  }
  
  private let postImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
    setupGesture()
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
      $0.trailing.lessThanOrEqualTo(contentView).offset(-150)
    }
    
    categorysLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(10)
      $0.leading.equalTo(postImageView.snp.trailing).offset(-150)
    }
    
    postImageView.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.trailing.equalTo(contentView).offset(-10)
      $0.width.height.equalTo(100)
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
      $0.leading.equalTo(postImageView.snp.trailing).offset(-150)
      $0.centerY.equalTo(addressLabel)
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
    timeLabel.text = timeAgo(from: post.posttime.dateValue())
    categorysLabel.text = post.categorys
    
    // 이미지 URL을 UIImage로 비동기 로드
    postImageView.loadImage(from: post.imageUrl)
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
