//
//  OnlineMapViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit
import SnapKit

class OnlineMapViewController: UIViewController {
  private let label: UILabel = {
    let label = UILabel()
    label.text = "우리동네 알리미"
    label.font = CustomFont.Deco.font()
    return label
  }()
  private let label2: UILabel = {
    let label = UILabel()
    label.text = "우리동네 알리미"
    label.font = CustomFont.Display.font()
    return label
  }()
  private let label3: UILabel = {
    let label = UILabel()
    label.text = "우리동네 알리미"
    label.font = CustomFont.Deco4.font()
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .CBlue
    view.addSubview(label)
    view.addSubview(label2)
    view.addSubview(label3)
    
    label.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    label2.snp.makeConstraints { make in
      make.top.equalTo(label).offset(50)
      make.centerX.equalToSuperview()
    }
    label3.snp.makeConstraints { make in
      make.top.equalTo(label2).offset(50)
      make.centerX.equalToSuperview()
    }
  }
}

@available(iOS 17.0, *)
#Preview { OnlineMapViewController() }

