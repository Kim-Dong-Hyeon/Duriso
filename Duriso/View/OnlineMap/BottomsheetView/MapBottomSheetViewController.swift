//
//  MapBottomSheetViewController.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import UIKit
import RxCocoa
import RxSwift

class MapBottomSheetViewController: UIViewController {
  var panelContentsViewController: UIViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    // 기본적인 바텀 시트 설정 코드
    if let sheet = sheetPresentationController {
      if #available(iOS 16.0, *) {
        let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("uniqueCustomIdentifier")) { context in
          let customHeight = context.maximumDetentValue * 0.36
          return customHeight
        }
        sheet.detents = [customDetent]
      } else {
        sheet.detents = [.medium()]
      }
      
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 15.0
    }
  }
  
  func configureContentViewController(_ viewController: UIViewController) {
    // 이전의 child view controller를 제거
    panelContentsViewController?.willMove(toParent: nil)
    panelContentsViewController?.view.removeFromSuperview()
    panelContentsViewController?.removeFromParent()
    
    // 새 view controller 추가
    panelContentsViewController = viewController
    addChild(panelContentsViewController!)
    view.addSubview(panelContentsViewController!.view)
    panelContentsViewController!.didMove(toParent: self)
    
    panelContentsViewController!.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      panelContentsViewController!.view.topAnchor.constraint(equalTo: view.topAnchor),
      panelContentsViewController!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      panelContentsViewController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      panelContentsViewController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}
