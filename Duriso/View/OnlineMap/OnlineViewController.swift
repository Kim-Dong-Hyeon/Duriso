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

class OnlineMapViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let onlineMapViewController = KakaoMapViewController()
  private let viewModel = OnlineViewModel()
  private var mapBottomSheetViewController: MapBottomSheetViewController?
  
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
    $0.setImage(UIImage(named: "locationButton"), for: .normal)
    $0.addTarget(self, action: #selector(didTapcurrentLocationButton), for: .touchUpInside)
  }
  
  let writingButton = UIButton().then {
    $0.setImage(UIImage(named: "writingButton"), for: .normal)
    $0.addTarget(self, action: #selector(didTapWritingButton), for: .touchUpInside)
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
  
  //  private let gasMaskButton: UIButton = createButton(
  //    title: "방독면",
  //    symbolName: "location.fill",
  //    baseColor: .CLightBlue,
  //    selectedColor: .CYellow,
  //initiallySelected: false
  //  )
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
    setupConstraints()
    setupButtonBindings()
  }
  
  func setupViews() {
    
    addChild(onlineMapViewController)
    view.addSubview(onlineMapViewController.view)
    onlineMapViewController.didMove(toParent: self)
    
    [
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
    onlineMapViewController.view.snp.makeConstraints {
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
    
    currentLocationButton.snp.makeConstraints{
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(writingButton.snp.top).offset(-8)
      $0.width.height.equalTo(40)
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
    
    emergencyReportButton.snp.makeConstraints{
      $0.height.equalTo(34)
    }
  }
  
  //    gasMaskButton.snp.makeConstraints{
  //      $0.height.equalTo(34)
  //    }
  
  
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
  
  @objc func didTapcurrentLocationButton() {
    // Handle the writing button tap action here
    print("Writing button tapped")
  }
  
  @objc private func didTapWritingButton() {
    presentMapBottomSheet()
    print("Writing button tapped")
  }
  
  private func presentMapBottomSheet() {
      // MapBottomSheetViewController를 인스턴스화합니다
      let bottomSheetVC = MapBottomSheetViewController()
      
      // FloatingPanelController와 함께 bottomSheetVC를 설정합니다
      mapBottomSheetViewController = bottomSheetVC
      present(mapBottomSheetViewController!, animated: true, completion: nil)
  }
  
  private func setupButtonBindings() {
    viewModel.setupButtonBindings(
      shelterButton: shelterButton,
      defibrillatorButton: defibrillatorButton,
      emergencyReportButton: emergencyReportButton
    )
    
    // Subscribe to button state changes and update UI
    viewModel.shelterButtonSelected
      .map { $0 ? UIColor.CGreen : UIColor.CLightBlue }
      .bind(to: shelterButton.rx.backgroundColor)
      .disposed(by: disposeBag)
    
    viewModel.defibrillatorButtonSelected
      .map { $0 ? UIColor.CRed : UIColor.CLightBlue }
      .bind(to: defibrillatorButton.rx.backgroundColor)
      .disposed(by: disposeBag)
    
    viewModel.emergencyReportButtonSelected
      .map { $0 ? UIColor.CBlue : UIColor.CLightBlue }
      .bind(to: emergencyReportButton.rx.backgroundColor)
      .disposed(by: disposeBag)
  }
}

@available(iOS 17.0, *)
#Preview { OnlineMapViewController() }
