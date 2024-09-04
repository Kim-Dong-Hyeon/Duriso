//
//  NoticeDetailViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/4/24.
//

import UIKit

import SnapKit

class NoticeDetailViewController: UIViewController {
  
  private let noticeDetailTableView = UITableView()
  
  private let noticeTitleLabel = UILabel().then {
    $0.text = "제목" //임시
    $0.font = CustomFont.Head2.font()
    $0.textColor = .CBlack
  }
  private let dateLabel = UILabel().then {
    $0.text = "2024.09.04" // 임시
    $0.font = CustomFont.Body2.font()
    $0.textColor = .CBlack
  }
  
  private let noticeDetailTextView = UITextView().then {
    $0.text = "내용" //임시
    $0.font = CustomFont.Body2.font()
    $0.textColor = .CBlack
    $0.isEditable = false
    $0.isScrollEnabled = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    ConfigureUI()
  }
  
  private func ConfigureUI() {
    [
      noticeTitleLabel,
      dateLabel,
      noticeDetailTextView
    ].forEach{ view.addSubview($0) }
    
    noticeTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(noticeTitleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    noticeDetailTextView.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
    }
    
  }
  
}
