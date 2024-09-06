//
//  OnlineView.swift
//  Duriso
//
//  Created by 이주희 on 9/6/24.
//

import UIKit
import SnapKit

class OnlineView: UIView {
  
  // UI Elements
  let addressView = UIView().then {
    $0.backgroundColor = .CWhite
    $0.layer.cornerRadius = 20
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowOpacity = 0.15
    $0.layer.shadowColor = UIColor.CBlack.cgColor
    $0.layer.shadowRadius = 8
    $0.layer.masksToBounds = false
  }
  
  let addressLabel = UILabel().then {
    $0.text = "00시 00구 00동"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head3.font()
  }
  
  let buttonStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.axis = .horizontal
    $0.spacing = 8
  }
  
  let currentLocationButton = UIButton().then {
    $0.backgroundColor = .white
  }

  let writingButton = UIButton().then {
    $0.setImage(UIImage(named: "writingButton"), for: .normal)
  }
  
  lazy var shelterButton: UIButton = createButton(
    title: "대피소",
    symbolName: "figure.run",
    baseColor: .CLightBlue,
    selectedColor: .CGreen
  )
  
  lazy var defibrillatorButton: UIButton = createButton(
    title: "제세동기",
    symbolName: "bolt.heart.fill",
    baseColor: .CLightBlue,
    selectedColor: .CRed
  )
  
  lazy var emergencyReportButton: UIButton = createButton(
    title: "긴급제보",
    symbolName: "megaphone.fill",
    baseColor: .CLightBlue,
    selectedColor: .CBlue
  )
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    [
      addressView,
      currentLocationButton,
      buttonStackView,
      writingButton
    ].forEach { addSubview($0) }
    
    [
      shelterButton,
      defibrillatorButton,
      emergencyReportButton
    ].forEach { buttonStackView.addArrangedSubview($0) }
    
    [
      addressLabel
    ].forEach { addressView.addSubview($0) }
  }
  
  private func setupConstraints() {
      addressView.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.top.equalToSuperview().offset(80)
          $0.width.equalTo(180)
          $0.height.equalTo(40)
      }
      
      addressLabel.snp.makeConstraints {
          $0.center.equalTo(addressView)
      }
      
      // Adjust writingButton constraints to place it in the top-right corner
      writingButton.snp.makeConstraints {
          $0.trailing.equalToSuperview().offset(-16)
          $0.top.equalTo(addressView.snp.bottom).offset(16)
          $0.width.height.equalTo(40)
      }
      
      // Adjust buttonStackView to be at the bottom of the view with padding
      buttonStackView.snp.makeConstraints {
          $0.centerX.equalToSuperview()
          $0.leading.trailing.equalToSuperview().inset(16)
          $0.bottom.equalToSuperview().offset(-96)
      }
      
      // Set consistent height for buttons in the stack view
      shelterButton.snp.makeConstraints {
          $0.height.equalTo(34)
      }
      
      defibrillatorButton.snp.makeConstraints {
          $0.height.equalTo(34)
      }
      
      emergencyReportButton.snp.makeConstraints {
          $0.height.equalTo(34)
      }
  }
  
  private func createButton(title: String, symbolName: String, baseColor: UIColor, selectedColor: UIColor) -> UIButton {
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
    return button
  }
}
