//
//  MapBottomSheet.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import UIKit

import FloatingPanel
import RxCocoa
import RxSwift
import Then

class MapBottomSheetViewController: UIViewController {
  //맵 인포 및 긴급제보 시트
  //내부 UI구현
  private let shelterTitle: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let shelterAddress: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let shelterType: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
  }
  
  func setupView() {
    [
      shelterTitle,
      shelterAddress,
      shelterType
    ].forEach { view.addSubview($0) }
    
    setupSheet()
    addNavigationBarButtonItem()
  }
  
  private func setupSheet() {
    //sheetPresentationController 설정
  }
  
  private func addNavigationBarButtonItem() {
    
  }

}

@available(iOS 17.0, *)
#Preview { OnlineMapViewController() }
