//
//  MapBottomSheetViewController.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import UIKit

import FloatingPanel
import RxCocoa
import RxSwift

class MapBottomSheetViewController: UIViewController, FloatingPanelControllerDelegate {
  
  var fpc: FloatingPanelController!
  var panelContentsViewController: UIViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
   func setupView(type: BottomSheetType) {
    switch type {
    case .shelter:
      panelContentsViewController = ShelterViewController()
    case .aed:
      panelContentsViewController = AedViewController()
    case .emergencyReport:
      panelContentsViewController = EmergencyReportViewController()
    }
    
    fpc = FloatingPanelController()
    fpc.changePanelStyle()
    fpc.delegate = self
    fpc.set(contentViewController: panelContentsViewController)
    fpc.layout = MyFloatingPanelLayout()
    fpc.invalidateLayout()
    fpc.addPanel(toParent: self)
  }
}

// 새로운 enum으로 타입 지정
enum BottomSheetType {
  case shelter
  case aed
  case emergencyReport
}


// MARK: - Extesions
/// FloatingPanelController 확장: 스타일 변경 메서드 정의
extension FloatingPanelController {
  func changePanelStyle() {
    let appearance = SurfaceAppearance()
    let shadow = SurfaceAppearance.Shadow()
    shadow.color = UIColor.black
    shadow.offset = CGSize(width: 0, height: -4)
    shadow.opacity = 0.15
    appearance.shadows = [shadow]
    appearance.cornerRadius = 15.0
    appearance.backgroundColor = .CBlue
    appearance.borderColor = .clear
    appearance.borderWidth = 0
    
    surfaceView.grabberHandle.isHidden = true
    surfaceView.appearance = appearance
  }
}

// 위치와 상태를 설정하는 layout 클래스
class MyFloatingPanelLayout: FloatingPanelLayout {
  // 올라오는 위치 지정
  let position: FloatingPanelPosition = .bottom
  let initialState: FloatingPanelState = .half
  
  var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
    return [
      .full: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),  // 85% 높이
      .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .safeArea),   // 40% 높이
      .tip: FloatingPanelLayoutAnchor(fractionalInset: 0.25, edge: .bottom, referenceGuide: .safeArea),    // 10% 높이 (기본 상태)
    ]
  }
}

