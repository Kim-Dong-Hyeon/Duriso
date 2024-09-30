//
//  EmergencyReportViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import SnapKit
import Then

class EmergencyReportViewController: UIViewController {
  
  // MARK: - Properties
  
  var reportName: String?
  var reportAddress: String?
  var authorName: String?
  var postTime: Date?
  var postContent: String?
  var postCategory: String? // 카테고리 정보
  var currentNickname: String = ""
  
  private let firestore = Firestore.firestore()
  
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
  
  private let categoryImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    //    $0.tintColor = .CBlue
  }
  
  private let authorLabel = UILabel().then {
    $0.text = "작성자 정보 불러오는 중"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head3.font()
  }
  
  private let poiViewAddress = UILabel().then {
    $0.text = "작성 위치 정보 불러오는 중"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Head4.font()
  }
  
  private let postTimeLabel = UILabel().then {
    $0.text = "작성 시간 정보 불러오는 중"
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
    $0.backgroundColor = UIColor.CLightBlue2
    $0.font = CustomFont.Body2.font()
    $0.text = "제보 내용 불러오는 중"
    $0.textColor = .CBlack
    
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
    $0.isEditable = false
    $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupUI()
    setupConstraints()
    updatePoiData()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    [
      poiViewTitle,
      megaphoneLabel,
      categoryImageView,
      authorLabel,
      poiViewAddress,
      postTimeLabel,
      cancelButton,
      postMessageTextView
    ].forEach { view.addSubview($0) }
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
    
    categoryImageView.snp.makeConstraints {
      
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(megaphoneLabel.snp.trailing)
      $0.width.equalTo(80)
      $0.height.equalTo(26)// 원하는 크기로 설정
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
      $0.centerY.equalTo(authorLabel.snp.centerY)
      $0.leading.equalTo(authorLabel.snp.trailing).offset(8)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.width.height.equalTo(32)
    }
    
    postMessageTextView.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(poiViewAddress.snp.bottom).offset(16)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.height.equalTo(100)
    }
  }
  
  // MARK: - Data Update
  private func updatePoiData() {
    fetchAuthorNickname { [weak self] nickname in
      self?.authorLabel.text = nickname ?? "알 수 없는 사용자"
    }
    
    if let category = postCategory {
      print("카테고리 확인: \(category)")
      updateCategoryImageView(with: category)
    } else {
      categoryImageView.image = UIImage(systemName: "tag")
    }
    
    // 주소 업데이트
    if let address = reportAddress {
      updateAddressLabel(with: address)
    } else {
      poiViewAddress.text = "작성 위치: 정보 없음"
    }
    
    // 시간 업데이트
    if let time = postTime {
      updatePostTimeLabel(with: time)
    } else {
      postTimeLabel.text = "작성 시간: 정보 없음"
    }
    
    postMessageTextView.text = postContent ?? "작성된 내용이 없습니다."
  }
  
  private func updateLabelWithSymbol(label: UILabel, symbolName: String, text: String) {
    let symbolAttachment = NSTextAttachment()
    symbolAttachment.image = UIImage(systemName: symbolName)
    symbolAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
    let symbolString = NSAttributedString(attachment: symbolAttachment)
    
    let textString = NSAttributedString(string: " \(text)")
    
    let finalString = NSMutableAttributedString()
    finalString.append(symbolString)
    finalString.append(textString)
    
    label.attributedText = finalString
  }
  
  // SF Symbol과 시간을 함께 표시하는 메서드
  private func updatePostTimeLabel(with time: Date) {
    let timeAgoText = timeAgo(from: time)
    updateLabelWithSymbol(label: postTimeLabel, symbolName: "timer", text: timeAgoText)
  }
  
  // SF Symbol과 주소를 함께 표시하는 메서드
  private func updateAddressLabel(with address: String) {
    updateLabelWithSymbol(label: poiViewAddress, symbolName: "map.fill", text: address)
  }
  
  // Firestore에서 작성자의 닉네임을 가져오는 메서드
  private func fetchAuthorNickname(completion: @escaping (String?) -> Void) {
    guard let authorName = authorName else {
      completion(nil)
      return
    }
    
    // Firestore에서 작성자의 UID를 통해 닉네임을 가져옴
    firestore.collection("users").document(authorName).getDocument { (document, error) in
      if let document = document, document.exists {
        let data = document.data()
        let nicknameFromFirestore = data?["nickname"] as? String ?? "닉네임 없음"
        completion(nicknameFromFirestore)
      } else {
        print("작성자 데이터를 불러오는 데 실패했습니다: \(error?.localizedDescription ?? "Unknown error")")
        completion(nil)
      }
    }
  }
  
  private func updateCategoryImageView(with category: String) {
    let imageName: String
    print("카테고리 값 확인: \(category)")
    // 카테고리에 따른 이미지 지정
    switch category {
    case "긴급제보":
      imageName = "EmergencyReporttag"
    case "태풍":
      imageName = "Typhoontag"
    case "지진":
      imageName = "Earthquaketag"
    case "홍수":
      imageName = "Floodtag"
    case "쓰나미":
      imageName = "Tsunamitag"
    case "핵폭발":
      imageName = "Nucleartag"
    case "산불":
      imageName = "ForestFirestag"
    case "산사태":
      imageName = "Landslidetag"
    case "폭염":
      imageName = "Heatwavetag"
    case "대설":
      imageName = "HeavySnowtag"
    default:
      imageName = "tag.fill" // 기본 이미지
    }
    print("이미지 설정 확인: \(imageName)")
    categoryImageView.image = UIImage(named: imageName) ?? UIImage(systemName: "tag.fill")
  }
  
  // MARK: - Helper Method for Time Ago
  private func timeAgo(from date: Date) -> String {
    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)
    
    if let days = components.day, days > 0 {
      return "\(days)일 전"
    } else if let hours = components.hour, hours > 0 {
      return "\(hours)시간 전"
    } else if let minutes = components.minute, minutes > 0 {
      return "\(minutes)분 전"
    } else {
      return "방금 전"
    }
  }
  
  // MARK: - Actions
  @objc private func didTapCancelButton() {
    dismiss(animated: true)
  }
}
