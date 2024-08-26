//
//  GuidelineViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

class GuidelineViewController: UIViewController {
  
  private let urgentMessage: UILabel = {
    let label = UILabel()
    label.text = "긴급재난문자"
    label.font = .boldSystemFont(ofSize: 10)
    return label
  }()
  
  private let urgentMessageView: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let disasterKit: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 10
    //imageView.image =
    imageView.frame = .init(x: 0, y: 0, width: 100, height: 350)
    return imageView
  }()
  
  private lazy var atrickcollectionView: UICollectionView = {
    let collectionView = UICollectionView()
    collectionView.backgroundColor = .darkGray
    collectionView.collectionViewLayout = .init()
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    guidelineLayout()
  }
  
  private func guidelineLayout() {
    
  }
  
}

@available(iOS 17.0, *)
#Preview{ GuidelineViewController() }
