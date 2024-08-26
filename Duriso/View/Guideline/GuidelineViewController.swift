//
//  GuidelineViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class GuidelineViewController: UIViewController {
  
  private let urgentMessage: UILabel = {
    let label = UILabel()
    label.text = "긴급재난문자"
    label.font = .boldSystemFont(ofSize: 10)
    return label
  }()
  
  private let urgentMessageContainer: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 10
    return view
  }()
  
  private let urgentMessage: UILabel
  
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
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  private let atrickLabel: UILabel = {
    let label = UILabel()
    label.text = "재난시 행동요령"
    label.font = .systemFont(ofSize: 10)
    return label
  }()
  
  private lazy var atrickTableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    guidelineLayout()
  }
  
  private func guidelineLayout() {
    
  }
  
}

extension GuidelineViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    <#code#>
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    <#code#>
  }
  
  
}

extension GuidelineViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  
  
}




@available(iOS 17.0, *)
#Preview{ GuidelineViewController() }
