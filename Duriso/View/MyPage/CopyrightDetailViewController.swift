//
//  CopyrightDetailViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/20/24.
//

import UIKit

import SnapKit

class CopyrightDetailViewController: UIViewController {
  private let copyright: Copyright
  
  private let textView = UITextView().then {
    $0.font = CustomFont.Body3.font()
    $0.isEditable = false
  }
  
  init(copyright: Copyright) {
    self.copyright = copyright
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.tabBarController?.tabBar.isHidden = true
    title = copyright.title
    
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
    textView.text = copyright.content
  }
}
