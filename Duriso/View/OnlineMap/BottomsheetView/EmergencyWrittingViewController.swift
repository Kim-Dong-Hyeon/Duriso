//
//  EmergencyWrittingViewController.swift
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
  
  // MARK: - Properties
  private let firestore = Firestore.firestore()
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  private var onlineViewController: OnlineViewController?
  private let regionFetcher = RegionFetcher()
  
  func setOnlineViewController(_ viewController: OnlineViewController) {
    self.onlineViewController = viewController
  }
  // MARK: - UI Components
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
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  private let messageInputTextView = UITextView().then {
    $0.backgroundColor = UIColor.CWhite
    $0.font = CustomFont.Body2.font()
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.CBlue.cgColor
    $0.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    $0.isScrollEnabled = false
  }
  
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
    $0.addTarget(self, action: #selector(didTapAddPostButton), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
    messageInputTextView.delegate = self
    setupLocationUpdates()
  }
  
  // MARK: - Setup
  private func setupView() {
    [poiViewTitle, megaphoneLabel, cancelButton, messageInputTextView, addPostButton].forEach { view.addSubview($0) }
    messageInputTextView.addSubview(placeholderLabel)
  }
  
  private func setupConstraints() {
    poiViewTitle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    megaphoneLabel.snp.makeConstraints {
      $0.centerY.equalTo(poiViewTitle)
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
  
  private func setupLocationUpdates() {
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.latitude = latitude
      self?.longitude = longitude
      print("Updated Location: Latitude \(latitude), Longitude \(longitude)")
      self?.updateLocationNames(latitude: latitude, longitude: longitude)
    }
  }
  
  // MARK: - Actions
  @objc private func didTapCancelButton() {
    dismiss(animated: true)
  }
  
  @objc private func didTapAddPostButton() {
    guard let content = messageInputTextView.text, !content.isEmpty else {
      print("내용을 입력해주세요.")
      return
    }
    
    let title = ""
    let category = "긴급제보"
    
    guard latitude != 0.0, longitude != 0.0 else {
      print("현재 위치를 받아오는 중입니다. 잠시 후 다시 시도해주세요.")
      return
    }
    
    guard let onlineVC = onlineViewController else {
      print("지역 정보가 없습니다.")
      return
    }
    
    let newPost = createPost(content: content, category: category, onlineVC: onlineVC)
    
    firestore.collection("posts").document(newPost.postid).setData(newPost.toDictionary()) { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        print("Firestore에 데이터 저장 실패: \(error.localizedDescription)")
      } else {
        print("게시글 저장 성공")
        PoiViewModel.shared.setupPoiData()
        self.dismiss(animated: true)
      }
    }
  }
  
  private func createPost(content: String, category: String, onlineVC: OnlineViewController) -> Posts {
    return Posts(
      author: "작성자 이름",
      contents: content,
      category: category,
      dong: onlineVC.dong,
      gu: onlineVC.gu,
      likescount: 0,
      postid: UUID().uuidString,
      postlatitude: self.latitude,
      postlongitude: self.longitude,
      posttime: Date(),
      reportcount: 0,
      si: onlineVC.si,
      title: "",
      imageUrl: ""
    )
  }
  
  // MARK: - Helper Methods
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
  
  // MARK: - UITextViewDelegate
  func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = !textView.text.isEmpty
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    placeholderLabel.isHidden = true
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      placeholderLabel.isHidden = false
    }
  }
}


