//
//  OnlineMapViewController.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnlineMapViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  private let kakaoMapView: UIView = {
    let view = UIView()
    return view
  }()
  
  private let addressView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 20
    view.backgroundColor = .CWhite
    view.layer.shadowOffset = CGSize(width: 0, height: 4)
    view.layer.shadowOpacity = 0.15
    view.layer.shadowColor = UIColor.CBlack.cgColor
    view.layer.shadowRadius = 8
    view.layer.masksToBounds = false
    return view
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.text = "00시 00구 00동"
    label.font = CustomFont.Head3.font()
    return label
  }()
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.distribution = .fillProportionally
    stackView.axis = .horizontal
    stackView.spacing = 8
    return stackView
  }()
  
  private let currentLocationButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  private let writingButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "writingButton"), for: .normal)
    return button
  }()
  
  private let shelterButton: UIButton = createButton(
    title: "대피소",
    symbolName: "figure.run",
    baseColor: .CLightBlue,
    selectedColor: .CGreen
  )
  
  private let defibrillatorButton: UIButton = createButton(
    title: "제세동기",
    symbolName: "bolt.heart.fill",
    baseColor: .CLightBlue,
    selectedColor: .CRed
  )
  
  //  private let gasMaskButton: UIButton = createButton(
  //    title: "방독면",
  //    symbolName: "location.fill",
  //    baseColor: .CLightBlue,
  //    selectedColor: .CYellow,
  //initiallySelected: false
  //  )
  
  private let emergencyReportButton: UIButton = createButton(
    title: "긴급제보",
    symbolName: "megaphone.fill",
    baseColor: .CLightBlue,
    selectedColor: .CBlue
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
    setupConstraints()
    setupButtonBindings()
  }
  
  func setupViews() {
    [
      kakaoMapView,
      addressView,
      currentLocationButton,
      buttonStackView,
      writingButton
    ].forEach { view.addSubview($0) }
   
    [
      shelterButton,
      defibrillatorButton, /*gasMaskButton,*/
      emergencyReportButton
    ].forEach { buttonStackView.addArrangedSubview($0) }
   
    [
      addressLabel
    ].forEach { addressView.addSubview($0) }
  }
  
  func setupConstraints() {
    kakaoMapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addressView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(80)
      $0.width.equalTo(180)
      $0.height.equalTo(40)
    }
    
    addressLabel.snp.makeConstraints {
      $0.center.equalTo(addressView)
    }
    
    writingButton.snp.makeConstraints{
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(buttonStackView.snp.top).offset(-16)
      $0.width.height.equalTo(40)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-96)
    }
    
    shelterButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
    
    defibrillatorButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
    
    //    gasMaskButton.snp.makeConstraints{
    //      $0.height.equalTo(34)
    //    }
    
    emergencyReportButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
    
  }
  
  func createButton(title: String, symbolName: String, baseColor: UIColor, selectedColor: UIColor) 
  -> UIButton {
    
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: symbolName), for: .normal)
    button.tintColor = .CWhite
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = CustomFont.Body3.font()
    button.setTitleColor(.CWhite, for: .normal)
    button.backgroundColor = selectedColor
    
    button.isSelected = false
    button.layer.cornerRadius = 17
    
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 4)
    button.layer.shadowRadius = 4
    button.layer.shadowOpacity = 0.2
    button.layer.masksToBounds = false
    
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    
    button.isSelected = false
    return button
  }
  
  private func setupButtonBindings() {
    bindButtonTap(button: shelterButton, selectedColor: .CGreen)
    bindButtonTap(button: defibrillatorButton, selectedColor: .CRed)
    bindButtonTap(button: emergencyReportButton, selectedColor: .CBlue)
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
    return shelterButton.isSelected && defibrillatorButton.isSelected && emergencyReportButton.isSelected
  }
  
  private func resetButtonsExcept(_ selectedButton: UIButton) {
    let buttons = [shelterButton, defibrillatorButton, emergencyReportButton]
    for button in buttons {
      if button != selectedButton {
        button.isSelected = false
        button.backgroundColor = .CLightBlue
      }
    }
  }
  
  private func selectAllButtons() {
    let buttons = [shelterButton, defibrillatorButton, emergencyReportButton]
    for button in buttons {
      button.isSelected = true
      switch button {
      case shelterButton:
        button.backgroundColor = .CGreen
      case defibrillatorButton:
        button.backgroundColor = .CRed
      case emergencyReportButton:
        button.backgroundColor = .CBlue
      default:
        break
      }
    }
  }
}

@available(iOS 17.0, *)
#Preview { OnlineMapViewController() }
