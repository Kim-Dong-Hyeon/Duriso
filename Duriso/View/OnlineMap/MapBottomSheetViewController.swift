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


class MapBottomSheetViewController: UIViewController {
  
  var fpc: FloatingPanelController!  // FloatingPanelController의 인스턴스
  var panelContentsViewController: PaneltContentsViewController! // 패널에 표시될 콘텐츠 뷰 컨트롤러
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    panelContentsViewController = PaneltContentsViewController() // 콘텐츠 뷰 컨트롤러 인스턴스화
    
    fpc = FloatingPanelController()
    fpc.changePanelStyle()
    fpc.delegate = self
    fpc.set(contentViewController: panelContentsViewController)
    
    // 만약 panelContentsViewController에 스크롤 뷰가 있으면 활성화
    // fpc.track(scrollView: panelContentsViewController.scrollView)
    
    fpc.layout = FloatingPanelBottomLayout()
    fpc.invalidateLayout()
    fpc.addPanel(toParent: self)
  }
}

// MARK: - Extesions
///FloatingPanelController 확장: 스타일 변경 메서드 정의
extension FloatingPanelController {
  func changePanelStyle() {
    let appearance = SurfaceAppearance() // 수정된 변수명
    let shadow = SurfaceAppearance.Shadow()
    shadow.color = UIColor.black // UIColor.CBlack 대신 UIColor.black 사용
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

/// FloatingPanelControllerDelegate 채택 및 구현
extension MapBottomSheetViewController: FloatingPanelControllerDelegate {
  func floatingPanelDidChangePosition(_ fpc: FloatingPanelController) {
    if fpc.state == .full {
      // 패널이 풀스크린 모드일 때의 동작
    } else {
      // 패널이 다른 모드일 때의 동작
    }
  }
}

@available(iOS 17.0, *)
#Preview { MapBottomSheetViewController() }
