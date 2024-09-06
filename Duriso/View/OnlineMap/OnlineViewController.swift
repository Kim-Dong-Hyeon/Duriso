//
//  OnlineMapViewController.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class OnlineViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let onlineMapViewController = KakaoMapViewController()
  private let onlineView = OnlineView()
  
  override func loadView() {
    view = onlineView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupButtonBindings()
  }
  
  private func setupButtonBindings() {
    bindButtonTap(button: onlineView.shelterButton, selectedColor: .CGreen)
    bindButtonTap(button: onlineView.defibrillatorButton, selectedColor: .CRed)
    bindButtonTap(button: onlineView.emergencyReportButton, selectedColor: .CBlue)
    
    addChild(onlineMapViewController)
    view.addSubview(onlineMapViewController.view)
    onlineMapViewController.didMove(toParent: self)
    
    onlineMapViewController.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func bindButtonTap(button: UIButton, selectedColor: UIColor) {
    button.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        if self.areAllButtonsSelected() {
          self.resetButtonsExcept(button)
          button.isSelected = true
          button.backgroundColor = selectedColor
        } else if button.isSelected {
          self.selectAllButtons()
        } else {
          self.resetButtonsExcept(button)
          button.isSelected = true
          button.backgroundColor = selectedColor
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func areAllButtonsSelected() -> Bool {
    return onlineView.shelterButton.isSelected && onlineView.defibrillatorButton.isSelected && onlineView.emergencyReportButton.isSelected
  }
  
  private func resetButtonsExcept(_ selectedButton: UIButton) {
    let buttons = [onlineView.shelterButton, onlineView.defibrillatorButton, onlineView.emergencyReportButton]
    for button in buttons {
      if button != selectedButton {
        button.isSelected = false
        button.backgroundColor = .CLightBlue
      }
    }
  }
  
  private func selectAllButtons() {
    let buttons = [onlineView.shelterButton, onlineView.defibrillatorButton, onlineView.emergencyReportButton]
    for button in buttons {
      button.isSelected = true
      switch button {
      case onlineView.shelterButton:
        button.backgroundColor = .CGreen
      case onlineView.defibrillatorButton:
        button.backgroundColor = .CRed
      case onlineView.emergencyReportButton:
        button.backgroundColor = .CBlue
      default:
        break
      }
    }
  }
}

@available(iOS 17.0, *)
#Preview { OnlineViewController() }
