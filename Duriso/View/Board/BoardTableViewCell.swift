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

class BoardTableViewCell: UITableViewCell {
  
  static let boardTableCell = "BoardTableCell"
  weak var delegate: BoardTableViewCellDelegate?
  private var post: Post?
  private let disposeBag = DisposeBag()
  
  public let titleLabel = UILabel().then {
    $0.text = "제목"
    $0.font = CustomFont.Head2.font()
  }
  
  public let titleTop = UILabel().then {
    $0.text = ""
    $0.font = CustomFont.Head2.font()
  }
  
  public let contentLabel = UILabel().then {
    $0.text = "내용"
    $0.font = CustomFont.Body2.font()
    $0.numberOfLines = 2
  }
  
  private let addressLabel = UILabel().then {
    $0.text = "사랑시 고백구 행복동"
    $0.font = CustomFont.Body3.font()
  }
  
  private let timeLabel = UILabel().then {
    $0.text = "0분전"
    $0.font = CustomFont.Body3.font()
  }
  
  private let userSetImage = UIImageView().then {
    $0.image = .writingButton
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with post: Post) {
    self.post = post
    titleLabel.text = post.title
    contentLabel.text = post.content
    addressLabel.text = "사랑시 고백구 행복동"  // 추후 변경예정 자기위치 따다가 넣을곳
    userSetImage.image = post.settingImage
    timeLabel.text = timeAgo(from: post.createdAt)
    titleTop.text = post.categorys
    
    let cellTapEvent = UITapGestureRecognizer(target: self, action: #selector(cellTap))
    self.contentView.addGestureRecognizer(cellTapEvent)
  }
  
  @objc private func cellTap() {
    guard let post = self.post else { return }
    delegate?.didTapCell(with: post)
  }
  
  private func timeAgo(from date: Date) -> String {
    let interval = -date.timeIntervalSinceNow
    let minutes = Int(interval) / 60
    if minutes < 1 {
      return "방금"
    } else if minutes < 60 {
      return "\(minutes)분 전"
    } else {
      let hours = minutes / 60
      if hours < 24 {
        return "\(hours)시간 전"
      } else {
        let days = hours / 24
        return "\(days)일 전"
      }
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    [
      titleLabel,
      contentLabel,
      addressLabel,
      userSetImage,
      timeLabel,
      titleTop
    ].forEach { contentView.addSubview($0) }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(10)
      $0.leading.equalTo(contentView).offset(10)
    }
    
    titleTop.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(10)
      $0.centerX.equalTo(timeLabel.snp.centerX)
    }
    
    userSetImage.snp.makeConstraints {
      $0.centerY.equalTo(contentView)
      $0.trailing.equalTo(contentView).offset(-30)
      $0.width.height.equalTo(100)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.height.equalTo(50)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(contentView).offset(-120)
    }
    
    addressLabel.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(16)
      $0.leading.equalTo(contentView).offset(10)
      $0.trailing.equalTo(timeLabel.snp.leading).offset(-10)
      $0.bottom.equalTo(contentView).offset(-10)
    }
    
    timeLabel.snp.makeConstraints {
      $0.leading.equalTo(userSetImage.snp.trailing).offset(-160)
      $0.centerY.equalTo(addressLabel)
    }
  }
}

protocol BoardTableViewCellDelegate: AnyObject {
  func didTapCell(with post: Post)
}

