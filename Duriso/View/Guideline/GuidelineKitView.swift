//
//  GuidelineKitView.swift
//  Duriso
//
//  Created by 신상규 on 9/3/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class GuidelineKitView: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    guidelineKitNavigation()
  }
  
  private func guidelineKitNavigation() {
    navigationItem.title = "재난키트"
    let leftNavigationItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
    navigationItem.leftBarButtonItem = leftNavigationItem
    
    leftNavigationItem.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
  }
  
}
