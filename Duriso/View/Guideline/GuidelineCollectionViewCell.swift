//
//  GuidelineCollectionViewCell.swift
//  Duriso
//
//  Created by 신상규 on 8/26/24.
//

import UIKit
import SnapKit
import WebKit

class GuidelineCollectionViewCell: UICollectionViewCell {
  
  static let guidelineCollectionId = "guidelineCollectionViewCell"
  
  
  // 나중에 웹뷰로 바꾸어 넣을예정 (공부중)
  private let youtubeVideo: WKWebView = {
    let web = WKWebView()
    return web
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    youtubeLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func youtubeLayout() {
    contentView.addSubview(youtubeVideo)
    
    youtubeVideo.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func configure(with url: URL) {
          let request = URLRequest(url: url)
          youtubeVideo.load(request)
      }
  
}
