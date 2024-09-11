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
  
  var panelContentsViewController: UIViewController!
  var type: BottomSheetType

  // Custom initializer
  init(type: BottomSheetType) {
    self.type = type
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .CWhite
    setupView(type: type)  // 인자로 받은 타입으로 설정
  }
  
  func setupView(type: BottomSheetType) {
    print("Setup view called with type: \(type)")  // 타입 확인을 위한 출력

    switch type {
    case .shelter:
      panelContentsViewController = ShelterViewController()
    case .aed:
      panelContentsViewController = AedViewController()
    case .emergencyReport:
      panelContentsViewController = EmergencyReportViewController()
    }
    
    addChild(panelContentsViewController)
    view.addSubview(panelContentsViewController.view)
    panelContentsViewController.didMove(toParent: self)
    
    panelContentsViewController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      panelContentsViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      panelContentsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      panelContentsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      panelContentsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    if let sheet = sheetPresentationController {
      if #available(iOS 16.0, *) {
        if type == .emergencyReport {
          let customDetent = UISheetPresentationController.Detent.custom(identifier: UISheetPresentationController.Detent.Identifier("uniqueCustomIdentifier")) { context in
            let value = context.maximumDetentValue * 0.3
            print("Custom detent 높이: \(value)")
            return value
          }
          sheet.detents = [customDetent]  // custom만 사용
          print("Custom detent 설정됨")
        } else {
          sheet.detents = [.medium()]
          print("Medium detent 설정됨")
        }
      } else {
        sheet.detents = [.medium()]
        print("Medium detent 설정됨 (iOS 16.0 미만)")
      }
      
      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 15.0
    }
  }
}

enum BottomSheetType {
  case shelter
  case aed
  case emergencyReport
}


