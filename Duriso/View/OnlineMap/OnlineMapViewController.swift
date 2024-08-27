//
//  OnlineMapViewController.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import KakaoMapsSDK
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
    view.layer.masksToBounds = false
    return view
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.text = "00시 00구 00동"
    label.font = CustomFont.Body2.font()
    return label
  }()
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.axis = .horizontal
    stackView.spacing = 8
    return stackView
  }()
  
  private lazy var currentLocationButton: UIButton = {
    let button = UIButton()
    return button
  }()
  
  private lazy var writingButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "writingButton"), for: .normal)
    return button
  }()
  
  private lazy var shelterButton: UIButton = createButton(
    title: "대피소",
    symbolName: "figure.run",
    baseColor: .CLightBlue,
    selectedColor: .CGreen,
    initiallySelected: false
  )
  
  private lazy var defibrillatorButton: UIButton = createButton(
    title: "제세동기",
    symbolName: "bolt.heart.fill",
    baseColor: .CLightBlue,
    selectedColor: .CRed,
    initiallySelected: false
  )
  
  //  private lazy var gasMaskButton: UIButton = createButton(
  //    title: "방독면",
  //    symbolName: "location.fill",
  //    baseColor: .CLightBlue,
  //    selectedColor: .CYellow,
  //initiallySelected: false
  //  )
  
  private lazy var emergencyReportButton: UIButton = createButton(
    title: "긴급제보",
    symbolName: "megaphone.fill",
    baseColor: .CLightBlue,
    selectedColor: .CBlue,
    initiallySelected: false
  )
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
    setupConstraints()
    
  }
  
  func setupViews() {
    [kakaoMapView, addressView, currentLocationButton, buttonStackView, writingButton].forEach { view.addSubview($0) }
    [shelterButton, defibrillatorButton, /*gasMaskButton,*/emergencyReportButton].forEach {buttonStackView.addArrangedSubview($0)}
    [addressLabel].forEach { addressView.addSubview($0) }
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
  
  // 공통 UIButton 설정 함수
  private func createButton(title: String, symbolName: String, baseColor: UIColor, selectedColor: UIColor, initiallySelected: Bool = true) -> UIButton {
      let button = UIButton(type: .system)
      
      var config = UIButton.Configuration.plain()
      config.title = title
      config.image = UIImage(systemName: symbolName)
      config.imagePadding = 4
      config.baseForegroundColor = .white
      config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      button.configuration = config
      button.titleLabel?.font = CustomFont.Head3.font()
      button.layer.cornerRadius = 17
      button.sizeToFit()
    
      button.isSelected = true
      button.backgroundColor = selectedColor
      
      // 버튼 클릭 시 이벤트 처리
    
    // 초기버튼 컬러버튼
    // 버튼 클릭시 해당버튼만 컬러 나머지 버튼은 베이스 컬러
    // 클릭되어있는 버튼을 다시 클릭하면 전체 버튼 컬러버튼
    // 클릭되어있지 않은 버튼 클릭시 클릭된 버튼만 컬러버튼 나머지 버튼은 베이스 컬러
      button.rx.tap
          .scan(button.isSelected) { lastState, _ in
              !lastState // 버튼의 선택 상태를 반전
          }
          .subscribe(onNext: { [weak self] isSelected in
              guard let self = self else { return }

              if isSelected {
                  // 버튼이 선택된 상태에서 다시 클릭하면 모든 버튼을 고유의 selectedColor로 설정
                  self.resetAllButtonsToOriginalColor()
              } else {
                  // 버튼을 클릭하면 해당 버튼만 selectedColor로 유지하고 나머지는 baseColor로 설정
                  self.setAllButtonsToBaseColor(except: button)
                  button.backgroundColor = selectedColor
              }

              // 현재 버튼의 선택 상태를 업데이트
              button.isSelected = isSelected
          })
          .disposed(by: disposeBag)
      
      return button
  }

  private func setAllButtonsToBaseColor(except selectedButton: UIButton) {
      // 모든 버튼을 기본 색상으로 설정하지만 선택된 버튼은 제외
      if selectedButton != shelterButton {
          resetButton(shelterButton, toBaseColor: .CLightBlue)
      }
      if selectedButton != defibrillatorButton {
          resetButton(defibrillatorButton, toBaseColor: .CLightBlue)
      }
      if selectedButton != emergencyReportButton {
          resetButton(emergencyReportButton, toBaseColor: .CLightBlue)
      }
  }

  private func resetAllButtonsToOriginalColor() {
      resetButton(shelterButton, toColor: .CGreen)
      resetButton(defibrillatorButton, toColor: .CRed)
      resetButton(emergencyReportButton, toColor: .CBlue)
  }

  private func resetButton(_ button: UIButton, toBaseColor baseColor: UIColor) {
      button.isSelected = false
      button.backgroundColor = baseColor
  }

  private func resetButton(_ button: UIButton, toColor color: UIColor) {
      button.isSelected = true
      button.backgroundColor = color
  }
}

@available(iOS 17.0, *)
#Preview { OnlineMapViewController() }
