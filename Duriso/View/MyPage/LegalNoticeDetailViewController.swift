//
//  LegalNoticeDetailViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/3/24.
//

import UIKit

class LegalNoticeDetailViewController: UIViewController {
  private let notice: LegalNotice
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    return textView
  }()
  
  init(notice: LegalNotice) {
    self.notice = notice
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = notice.title
    configureUI()
    displayContent()
  }
  
  
  private func configureUI() {
    view.addSubview(textView)
    textView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
  }
  
  private func displayContent() {
    textView.text = notice.content
  }
}
