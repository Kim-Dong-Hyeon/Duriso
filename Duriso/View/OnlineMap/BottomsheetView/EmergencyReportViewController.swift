//
//  EmergencyReportViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import SnapKit
import Then

class EmergencyReportViewController: UIViewController {
  
  // MARK: - Properties
  var reportName: String?      // 보고서 제목 또는 이름
  var reportAddress: String?   // 보고서 위치 주소 (시, 군, 구)
  var authorName: String?      // 작성자 이름
  var postTime: Date?          // 작성 시간
  var postContent: String?     // 작성 내용
  
  // MARK: - UI Components
  private let poiViewTitle = UILabel().then {
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
  
  private let authorLabel = UILabel().then {
    $0.text = "작성자: 정보 불러오는 중"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body2.font()
  }
  
  private let poiViewAddress = UILabel().then {
    $0.text = "작성 위치: 정보 불러오는 중"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body2.font()
  }
  
  private let postTimeLabel = UILabel().then {
    $0.text = "작성 시간: 정보 불러오는 중"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Body3.font()
  }
  
  private let cancelButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    $0.tintColor = .CLightBlue
    $0.contentMode = .scaleAspectFit
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  private let postMessageTextView = UITextView().then {
    $0.backgroundColor = UIColor.CLightBlue
    $0.font = CustomFont.Body2.font()
    $0.text = "제보 내용 불러오는 중"
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
    $0.isEditable = false
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupUI()
    setupConstraints()
    updatePoiData()  // 전달받은 데이터를 업데이트합니다.
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    [poiViewTitle, megaphoneLabel, authorLabel, poiViewAddress, postTimeLabel, cancelButton, postMessageTextView].forEach {
      view.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    poiViewTitle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    megaphoneLabel.snp.makeConstraints {
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(poiViewTitle.snp.trailing).offset(4)
      $0.width.height.equalTo(32)
    }
    
    authorLabel.snp.makeConstraints {
      $0.top.equalTo(poiViewTitle.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    poiViewAddress.snp.makeConstraints {
      $0.top.equalTo(authorLabel.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    postTimeLabel.snp.makeConstraints {
      $0.top.equalTo(poiViewAddress.snp.bottom).offset(8)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.width.height.equalTo(32)
    }
    
    postMessageTextView.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(postTimeLabel.snp.bottom).offset(16)
      $0.width.equalTo(350)
      $0.height.equalTo(100)
    }
  }
  
  // MARK: - Data Update
  private func updatePoiData() {
    authorLabel.text = "작성자: \(authorName ?? "정보 없음")"
    poiViewAddress.text = "작성 위치: \(reportAddress ?? "정보 없음")"
    
    if let time = postTime {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
      postTimeLabel.text = "작성 시간: \(dateFormatter.string(from: time))"
    } else {
      postTimeLabel.text = "작성 시간: 정보 없음"
    }
    
    postMessageTextView.text = postContent ?? "작성된 내용이 없습니다."
  }
  
  // MARK: - Actions
  @objc private func didTapCancelButton() {
    dismiss(animated: true)
  }
}
