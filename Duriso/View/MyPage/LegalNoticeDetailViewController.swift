//
//  LegalNoticeDetailViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/3/24.
//

import UIKit

import SnapKit

class LegalNoticeDetailViewController: UIViewController {
  private let notice: LegalNoticeModel
  
  private let textView = UITextView().then {
    $0.font = CustomFont.Body4.font()
    $0.isEditable = false
  }
  
  init(notice: LegalNoticeModel) {
    self.notice = notice
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.tabBarController?.tabBar.isHidden = true
    title = notice.title
    
    configureUI()
    displayContent()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  private func configureUI() {
    [
      textView
    ].forEach { view.addSubview($0) }
    
    textView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func displayContent() {
    textView.text = notice.content
  }
}
