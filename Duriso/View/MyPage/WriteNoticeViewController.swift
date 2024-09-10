//
//  WriteNoticeViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class WriteNoticeViewController: UIViewController {
  
  private let titleTextField = UITextField().then {
    $0.text = "제목을 입력하세요"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .CBlack
  }
  
  private let dataLabel = UILabel().then {
    $0.text = "2024.09.10"  //테스트, 현재날짜 입력받을 예정
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private let detailTextField = UITextField().then {
    $0.text = "내용을 입력하세요"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .CBlack
    $0.textAlignment = .left
  }
  
  private let saveButton = UIButton().then {
    $0.setTitle("저장", for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.layer.cornerRadius = 10
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    ConfigureUI()
  }
  
  private func ConfigureUI() {
    
    [
      titleTextField,
      dataLabel,
      detailTextField,
      saveButton
    ].forEach { view.addSubview($0) }
    
    titleTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    dataLabel.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
    
    detailTextField.snp.makeConstraints {
      $0.top.equalTo(dataLabel.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.bottom.equalTo(saveButton.snp.top).inset(16)
    }
    
    saveButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
    }
  }
}
