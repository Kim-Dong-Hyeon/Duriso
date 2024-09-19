//
//  EmergencWrittingViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import Firebase
import FirebaseFirestore
import FirebaseStorage
import SnapKit
import Then

class EmergencyWrittingViewController: UIViewController, UITextViewDelegate {
  
  private let firestore = Firestore.firestore()
  var latitude: Double = 0.0 // 실제 값으로 업데이트 필요
  var longitude: Double = 0.0 // 실제 값으로 업데이트 필요
  private var onlineViewController: OnlineViewController?
  private let regionFetcher = RegionFetcher()
  
  func setOnlineViewController(_ viewController: OnlineViewController) {
    self.onlineViewController = viewController
  }
  
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
  
  private let cancelButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    $0.tintColor = .CLightBlue
    $0.contentMode = .scaleAspectFit
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  private let messageInputTextView = UITextView().then {
    $0.backgroundColor = UIColor.CWhite
    $0.font = CustomFont.Body2.font()
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.CBlue.cgColor
    $0.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) // 패딩 설정
    $0.isScrollEnabled = false
  }
  
  // UILabel (플레이스홀더 역할)
  private let placeholderLabel = UILabel().then {
    $0.text = "꼭 필요한 정보만 남겨주세요.\n발생 지역을 상세히 적어주시면 큰 도움이 됩니다!"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .gray
    $0.numberOfLines = 0
  }
  
  private let addPostButton = UIButton().then {
    $0.setTitle("완료", for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
    $0.setTitleColor(.CWhite, for: .normal)
    $0.backgroundColor = .CBlue
    $0.layer.cornerRadius = 12
    $0.layer.masksToBounds = true
    $0.addTarget(self, action: #selector(didTapAddPostButton), for: .touchUpInside)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
    
    messageInputTextView.delegate = self
    
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.latitude = latitude
      self?.longitude = longitude
      print("Updated Location: Latitude \(latitude), Longitude \(longitude)")
      self?.updateLocationNames(latitude: latitude, longitude: longitude)
    }
  }
  
  func setupView() {
    [
      poiViewTitle,
      megaphoneLabel,
      cancelButton,
      messageInputTextView,
      addPostButton
    ].forEach { view.addSubview($0) }
    
    [
      placeholderLabel
    ].forEach { messageInputTextView.addSubview($0) }
  }
  
  func setupConstraints() {
    poiViewTitle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    megaphoneLabel.snp.makeConstraints{
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(poiViewTitle.snp.trailing).offset(4)
      $0.width.height.equalTo(32)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.width.height.equalTo(32)
    }
    
    messageInputTextView.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(poiViewTitle.snp.bottom).offset(24)
      $0.width.equalTo(360)
      $0.height.equalTo(88)
    }
    
    addPostButton.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(messageInputTextView.snp.bottom).offset(16)
      $0.width.equalTo(60)
      $0.height.equalTo(24)
    }
    
    placeholderLabel.snp.makeConstraints {
      $0.edges.equalTo(messageInputTextView).inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
  }
  
  @objc func didTapCancelButton() {
    dismiss(animated: true)
  }
  
  @objc func didTapAddPostButton() {
    guard let content = messageInputTextView.text, !content.isEmpty else {
      print("내용을 입력해주세요.")
      return
    }
    
    let title = ""
    let categorys = "긴급제보"
    
    // 현재 위치가 설정되었는지 확인
    guard latitude != 0.0, longitude != 0.0 else {
      print("현재 위치를 받아오는 중입니다. 잠시 후 다시 시도해주세요.")
      return
    }
    
    // OnlineViewController에서 지역 데이터를 가져옵니다.
    guard let onlineVC = onlineViewController else {
      print("지역 정보가 없습니다.")
      return
    }
    
    // 디버깅용 프린트
    print("EmergencWrittingViewController received si: \(onlineVC.si), gu: \(onlineVC.gu), dong: \(onlineVC.dong)")
    print("Received latitude: \(latitude), longitude: \(longitude)")
    
    // 게시글 생성
    let newPost = Posts(
      author: "작성자 이름",  // 작성자 이름을 설정
      contents: content,
      category: categorys,
      dong: onlineVC.dong,
      gu: onlineVC.gu,
      likescount: 0,
      postid: UUID().uuidString,  // 고유한 ID 생성
      postlatitude: self.latitude,
      postlongitude: self.longitude,
      posttime: Date(), // 현재 시간 설정
      reportcount: 0,
      si: onlineVC.si,
      title: title,
      imageUrl: ""
    )
    
    
    self.firestore.collection("posts").document(newPost.postid).setData(newPost.toDictionary()) { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        print("Firestore에 데이터 저장 실패: \(error.localizedDescription)")
      } else {
        print("게시글 저장 성공")
        
        // 게시글 저장 후 PoiViewModel의 setupPoiData 또는 emergencyReportCreatePoi 호출
        PoiViewModel.shared.setupPoiData()
        
        // 모달 닫기
        self.dismiss(animated: true)
      }
    }
  }
  
  private func updateLocationNames(latitude: Double, longitude: Double) {
    regionFetcher.fetchRegion(longitude: longitude, latitude: latitude) { [weak self] documents, error in
      guard let self = self else { return }
      if let document = documents?.first {
        let si = document.region1DepthName
        let gu = document.region2DepthName
        let dong = document.region3DepthName
        
        self.onlineViewController?.si = si
        self.onlineViewController?.gu = gu
        self.onlineViewController?.dong = dong
        print("Updated Region: SI \(si), GU \(gu), DONG \(dong)")
      } else if let error = error {
        print("지역 정보 가져오기 실패: \(error.localizedDescription)")
      }
    }
  }
  
  // UITextViewDelegate methods
  func textViewDidChange(_ textView: UITextView) {
    // Hide placeholder if text exists, otherwise show it
    placeholderLabel.isHidden = !textView.text.isEmpty
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    // Hide placeholder when editing begins
    placeholderLabel.isHidden = true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    // Show placeholder if no text
    if textView.text.isEmpty {
      placeholderLabel.isHidden = false
    }
  }
}

@available(iOS 17.0, *)
#Preview { EmergencyReportViewController() }
