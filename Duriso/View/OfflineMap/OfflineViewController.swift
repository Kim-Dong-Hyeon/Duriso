//
//  OfflineViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/10/24.
//

import UIKit

import RxSwift
import SnapKit

class OfflineViewController: UIViewController {
  private let offlineMapViewController = OfflineMapViewController(viewModel: OfflineMapViewModel())
  
  let buttonStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .fillEqually
    $0.axis = .horizontal
    $0.spacing = 8
  }
  
  lazy var shelterButton: UIButton = createButton(
    title: "대피소",
    symbolName: "figure.run",
    baseColor: .CLightBlue,
    selectedColor: .CGreen
  )
  
  lazy var aedButton: UIButton = createButton(
    title: "제세동기",
    symbolName: "bolt.heart.fill",
    baseColor: .CLightBlue,
    selectedColor: .CRed
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    addChild(offlineMapViewController)
    view.addSubview(offlineMapViewController.view)
    offlineMapViewController.didMove(toParent: self)
    
    [
      buttonStackView
    ].forEach { view.addSubview($0) }
    
    [
      shelterButton,
      aedButton
    ].forEach { buttonStackView.addArrangedSubview($0) }
  }
  
  private func setupConstraints() {
    buttonStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(100)
      $0.trailing.equalToSuperview().inset(100)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(13)
    }
    
    shelterButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
    
    aedButton.snp.makeConstraints{
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
    
    button.isSelected = false
    return button
  }
}

//@available(iOS 17.0, *)
//#Preview {
//  OfflineViewController()
//}
