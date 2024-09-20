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
  
  // 바텀 시트에 포함될 컨텐츠 뷰 컨트롤러
  var panelContentsViewController: UIViewController?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  // MARK: - View Setup
  // 바텀 시트 설정을 위한 함수
  func setupView() {
    // sheetPresentationController가 있는지 확인
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
      
      // 바텀 시트의 추가 설정
      sheet.prefersGrabberVisible = true  // 상단에 잡아당길 수 있는 표시 추가
      sheet.preferredCornerRadius = 15.0  // 코너의 라운드 값 설정
    }
  }
  
  // MARK: - Content Management
  
  // 컨텐츠 뷰 컨트롤러 설정 및 레이아웃 제약 설정
  func configureContentViewController(_ viewController: UIViewController) {
    // 기존 child view controller 제거
    panelContentsViewController?.willMove(toParent: nil)
    panelContentsViewController?.view.removeFromSuperview()
    panelContentsViewController?.removeFromParent()
    
    // 새 view controller 추가
    panelContentsViewController = viewController
    addChild(panelContentsViewController!)
    view.addSubview(panelContentsViewController!.view)
    panelContentsViewController!.didMove(toParent: self)
    
    // 새로운 child view controller의 레이아웃 제약 설정
    panelContentsViewController!.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      panelContentsViewController!.view.topAnchor.constraint(equalTo: view.topAnchor),
      panelContentsViewController!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      panelContentsViewController!.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      panelContentsViewController!.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}
