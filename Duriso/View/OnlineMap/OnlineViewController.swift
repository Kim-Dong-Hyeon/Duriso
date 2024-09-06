//
//  OnlineMapViewController.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift

class OnlineViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let kakaoMap = KakaoMapViewController()
  private let onlineView = OnlineView()
  private let viewModel = OnlineViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBindings()
    setupMapView()
  }
  
  private func setupMapView() {
    // KakaoMapViewController를 자식으로 추가
    addChild(kakaoMap)
    view.addSubview(kakaoMap.view)
    kakaoMap.didMove(toParent: self)
    
    // KakaoMapViewController의 뷰가 전체 화면을 차지하도록 제약 조건 설정
    kakaoMap.view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    // OnlineView를 현재 뷰 컨트롤러의 뷰에 추가
    view.addSubview(onlineView)
    
    // OnlineView의 제약 조건 설정 (전체 화면을 차지하도록 설정)
    onlineView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupBindings() {
    viewModel.setupButtonBindings(
      shelterButton: onlineView.shelterButton,
      defibrillatorButton: onlineView.defibrillatorButton,
      emergencyReportButton: onlineView.emergencyReportButton
    )
    
    viewModel.shelterButtonSelected
      .bind(to: onlineView.shelterButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    viewModel.defibrillatorButtonSelected
      .bind(to: onlineView.defibrillatorButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    viewModel.emergencyReportButtonSelected
      .bind(to: onlineView.emergencyReportButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      viewModel.shelterButtonSelected,
      viewModel.defibrillatorButtonSelected,
      viewModel.emergencyReportButtonSelected
    ).map { shelter, defibrillator, emergencyReport in
      return (shelter, defibrillator, emergencyReport)
    }
    .subscribe(onNext: { [weak self] shelter, defibrillator, emergencyReport in
      self?.updateButtonColors(shelter: shelter, defibrillator: defibrillator, emergencyReport: emergencyReport)
    })
    .disposed(by: disposeBag)
  }
  
  private func updateButtonColors(shelter: Bool, defibrillator: Bool, emergencyReport: Bool) {
    onlineView.shelterButton.backgroundColor = shelter ? .CGreen : .CLightBlue
    onlineView.defibrillatorButton.backgroundColor = defibrillator ? .CRed : .CLightBlue
    onlineView.emergencyReportButton.backgroundColor = emergencyReport ? .CBlue : .CLightBlue
  }
}

@available(iOS 17.0, *)
#Preview { OnlineViewController() }
