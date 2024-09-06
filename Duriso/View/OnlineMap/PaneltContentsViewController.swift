//
//  PaneltContentsViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import SnapKit
import Then

class PaneltContentsViewController: UIViewController {
  
  internal let poiViewTitle = UILabel().then {
    $0.text = "우리 동네 한줄 제보"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Deco2.font()
  }
  
  private let megaphoneLabel = UIImageView().then {
    $0.image = UIImage(systemName: "megaphone")
    $0.tintColor = .CRed
    $0.contentMode = .scaleAspectFit
  }
  
  private let poiViewAddress = UILabel().then {
    $0.text = "서울특별시 00구 00동"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body2.font()
  }
  
  private let postTime = UILabel().then {
    $0.text = "00분전"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body3.font()
  }
  
  private let cancleButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.app"), for: .normal)
    $0.tintColor = .black  // 아이콘 색상 설정
    $0.contentMode = .scaleAspectFit  // 이미지 모드 설정
    $0.addTarget(self, action: #selector(didTapcancelButton), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
  }
  
  func setupView() {
    [
      poiViewTitle,
      megaphoneLabel,
      poiViewAddress,
      postTime,
      cancleButton
    ].forEach { view.addSubview($0) }
  }
  
  func setupConstraints() {
    poiViewTitle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    poiViewAddress.snp.makeConstraints {
      $0.top.equalTo(poiViewTitle.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    postTime.snp.makeConstraints {
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(poiViewAddress.snp.trailing).offset(8)
    }
    
    megaphoneLabel.snp.makeConstraints{
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(poiViewTitle.snp.trailing).offset(16)
      $0.width.height.equalTo(32)
    }
    
    cancleButton.snp.makeConstraints {
      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.width.height.equalTo(32)
    }
  }
  
  func updatePoiData(with poiData: PoiData) {
    // 공통된 속성 업데이트
    poiViewTitle.text = poiData.id
  }
  
  @objc func didTapcancelButton() {
    dismiss(animated: true)
  }
}


@available(iOS 17.0, *)
#Preview { PaneltContentsViewController() }
