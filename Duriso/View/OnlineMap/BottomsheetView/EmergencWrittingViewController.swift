//
//  PaneltContentsViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import UIKit

import SnapKit
import Then

class EmergencWrittingViewController: UIViewController, UITextViewDelegate {
  
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
    dismiss(animated: true)
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
