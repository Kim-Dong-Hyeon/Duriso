//
//  MyPageViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
  let viewModel = MyPageViewModel()
  
  private let profileImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 40
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray // 테스트용 배경색
    return imageView
  }()
  
  private let nickNameLabel: UILabel = {
    let label = UILabel()
    label.text = "조수환" // 테스트용 텍스트
    label.textColor = .black
    label.font = CustomFont.Body.font()
    return label
  }()
  
  private let profileButton: UIButton = {
    let button = UIButton()
    button.setTitle("내 정보", for: .normal)
    button.backgroundColor = .CLightBlue
    button.titleLabel?.font = CustomFont.Body3.font()
    button.layer.cornerRadius = 10
    return button
  }()
  
  private let myPageTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageCell") // Register the custom cell
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  private let infoLabel: UILabel = {
    let label = UILabel()
    label.text = "두리소 \n관리자: 김신이조 \n사업자 번호: \n전화번호"   // 테스트용
    label.font = CustomFont.Body3.font()
    label.textColor = .lightGray
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureUI()
  }
  
  private func configureUI() {
    myPageTableView.delegate = self
    myPageTableView.dataSource = self
    
    [
      profileImage,
      nickNameLabel,
      profileButton,
      myPageTableView,
      infoLabel
    ].forEach { view.addSubview($0) }
    
    profileImage.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.width.height.equalTo(80)
    }
    
    nickNameLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalTo(profileImage.snp.trailing).offset(40)
    }
    
    profileButton.snp.makeConstraints {
      $0.top.equalTo(profileImage.snp.bottom).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.height.equalTo(48)
    }
    
    myPageTableView.snp.makeConstraints {
      $0.top.equalTo(profileButton.snp.bottom).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
      $0.bottom.equalTo(infoLabel.snp.top).offset(-16)
    }
    
    infoLabel.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
    }
  }
}

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = myPageTableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageTableViewCell
    viewModel.configureCell(cell, for: indexPath.row)
    if indexPath.row == 0 || indexPath.row == 4 {
      cell.selectionStyle = .none
    } else {
      cell.selectionStyle = .default
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.handleCellSelection(for: indexPath.row, viewController: self)
  }
}
