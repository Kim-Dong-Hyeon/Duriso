//
//  OnlineViewModel.swift
//  Duriso
//
//  Created by 이주희 on 9/6/24.
//

import RxCocoa
import RxSwift
import UIKit

class OnlineViewModel {
  
  private let disposeBag = DisposeBag()
  
  // Outputs
  let shelterButtonSelected = BehaviorRelay<Bool>(value: true)
  let defibrillatorButtonSelected = BehaviorRelay<Bool>(value: true)
  let emergencyReportButtonSelected = BehaviorRelay<Bool>(value: true)
  
  // Actions
  func setupButtonBindings(shelterButton: UIButton, defibrillatorButton: UIButton, emergencyReportButton: UIButton) {
    bindButtonTap(button: shelterButton, selectedColor: .CGreen, buttonType: .shelter)
    bindButtonTap(button: defibrillatorButton, selectedColor: .CRed, buttonType: .defibrillator)
    bindButtonTap(button: emergencyReportButton, selectedColor: .CBlue, buttonType: .emergencyReport)
    
    // 버튼의 초기 상태 설정
    initializeButtonStates()
  }
  
  
  
  private func bindButtonTap(button: UIButton, selectedColor: UIColor, buttonType: ButtonType) {
    button.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        switch buttonType {
        case .shelter:
          self.shelterButtonSelected.accept(!self.shelterButtonSelected.value)
        case .defibrillator:
          self.defibrillatorButtonSelected.accept(!self.defibrillatorButtonSelected.value)
        case .emergencyReport:
          self.emergencyReportButtonSelected.accept(!self.emergencyReportButtonSelected.value)
        }
        
        if self.areAllButtonsSelected() {
          self.resetButtonsExcept(buttonType: buttonType, button: button, selectedColor: selectedColor)
        } else if button.isSelected {
          self.selectAllButtons()
        } else {
          self.resetButtonsExcept(buttonType: buttonType, button: button, selectedColor: selectedColor)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func areAllButtonsSelected() -> Bool {
    return shelterButtonSelected.value && defibrillatorButtonSelected.value && emergencyReportButtonSelected.value
  }
  
  private func resetButtonsExcept(buttonType: ButtonType, button: UIButton, selectedColor: UIColor) {
    let buttons = [
      ButtonType.shelter: (buttonRelay: shelterButtonSelected, color: UIColor.CGreen),
      ButtonType.defibrillator: (buttonRelay: defibrillatorButtonSelected, color: UIColor.CRed),
      ButtonType.emergencyReport: (buttonRelay: emergencyReportButtonSelected, color: UIColor.CBlue)
    ]
    
    for (type, (buttonRelay, color)) in buttons {
      if type != buttonType {
        buttonRelay.accept(false)
        let button = getButton(for: type)
        button?.isSelected = false
        button?.backgroundColor = .CLightBlue
      }
    }
    
    button.isSelected = true
    button.backgroundColor = selectedColor
  }
  
  private func selectAllButtons() {
    let buttons = [
      ButtonType.shelter: (buttonRelay: shelterButtonSelected, color: UIColor.CGreen),
      ButtonType.defibrillator: (buttonRelay: defibrillatorButtonSelected, color: UIColor.CRed),
      ButtonType.emergencyReport: (buttonRelay: emergencyReportButtonSelected, color: UIColor.CBlue)
    ]
    
    for (type, (buttonRelay, color)) in buttons {
      buttonRelay.accept(true)
      let button = getButton(for: type)
      button?.isSelected = true
      button?.backgroundColor = color
    }
  }
  
func initializeButtonStates() {
      let buttons = [
          ButtonType.shelter: (buttonRelay: shelterButtonSelected, color: UIColor.CGreen),
          ButtonType.defibrillator: (buttonRelay: defibrillatorButtonSelected, color: UIColor.CRed),
          ButtonType.emergencyReport: (buttonRelay: emergencyReportButtonSelected, color: UIColor.CBlue)
      ]
      
      for (type, (buttonRelay, color)) in buttons {
          buttonRelay.accept(true) // 초기 상태는 선택되지 않은 상태
          let button = getButton(for: type)
          button?.isSelected = false
          button?.backgroundColor = color // 색상 설정
      }
  }
  
  private func getButton(for type: ButtonType) -> UIButton? {
    // 버튼 반환 로직 필요
    return nil
  }
}

// Enum for button types
enum ButtonType {
  case shelter
  case defibrillator
  case emergencyReport
}
