//
//  OfflineViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/10/24.
//

import UIKit

class OfflineViewController: UIViewController {
  private let offlineMapViewController = OfflineMapViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addChild(offlineMapViewController)
    view.addSubview(offlineMapViewController.view)
  }
}

@available(iOS 17.0, *)
#Preview {
  OfflineViewController()
}
