//
//  PostingViewController.swift
//  Duriso
//
//  Created by 신상규 on 9/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class PostingViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var postTitle: String?
  var postContent: String?
  var postImage: UIImage?  // 이미지 타입 변경
  var postTitleTop: String?
  var postAddress: String?
  var postTimes: Date?
  
  let postingScrollView = UIScrollView()
  
  private let postingTitleText = UILabel().then {
    $0.font = CustomFont.Head2.font()
    $0.textColor = .black
  }
  
  private let postingLineView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let postingLocationeName1 = UILabel().then {
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private let postingTimeText = UILabel().then {
    $0.text = "등록일시 :"
    $0.font = CustomFont.Head3.font()
  }
  
  private let postingTimeLabel = UILabel().then {
    $0.text = "00시 00분 00초"
    $0.font = CustomFont.Head3.font()
  }
  
  private let postingStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
  }
  
  private let postingUserTextLabel = UILabel().then {
    $0.font = CustomFont.Body2.font()
    $0.numberOfLines = 100
    $0.textColor = .black
  }
  
  private let postingImage = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let ripotButton = UIButton().then {
    $0.setTitle("🚨신고하기", for: .normal)
    $0.setTitleColor(.red, for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
  }
  
  private let changeButton = UIButton().then {
    $0.setTitle("수정하기", for: .normal)
    $0.setTitleColor(.lightGray, for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
  }
  
  private let removalButton = UIButton().then {
    $0.setTitle("삭제하기", for: .normal)
    $0.setTitleColor(.lightGray, for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
  }
  
  private let bottomStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 10
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    configureUI()
    setupBindings()
  }
  
  // 게시글 데이터를 설정하는 메서드
  func setPostData(post: Posts) {
    self.postTitle = post.title
    self.postContent = post.contents
    self.postAddress = "\(post.si) \(post.gu) \(post.dong)"
    self.postTimes = post.posttime
    
    // 이미지 로드
    if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
      loadImage(from: url)
    }
  }
  
  private func setupView() {
    // 서브뷰를 슈퍼뷰에 추가
    [
      postingScrollView,
      bottomStackView
    ].forEach { view.addSubview($0) }
    
    [
      postingTitleText,
      postingLineView,
      postingLocationeName1,
      postingStackView,
      postingImage,
      postingUserTextLabel
    ].forEach { postingScrollView.addSubview($0) }
    
    // UIStackView에 어레인지 서브뷰 추가
    [postingTimeText, postingTimeLabel].forEach { postingStackView.addArrangedSubview($0) }
    
    let spacerView = UIView()
    
    // Bottom StackView에 버튼 추가
    [
      ripotButton,
      spacerView,
      changeButton,
      removalButton
    ].forEach { bottomStackView.addArrangedSubview($0) }
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    postingScrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    postingTitleText.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(postingScrollView.snp.top).offset(16)
    }
    
    postingLineView.snp.makeConstraints {
      $0.top.equalTo(postingTitleText.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalToSuperview().inset(30)
    }
    
    postingLocationeName1.snp.makeConstraints {
      $0.top.equalTo(postingLineView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    postingStackView.snp.makeConstraints {
      $0.top.equalTo(postingLocationeName1.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    postingImage.snp.makeConstraints {
      $0.top.equalTo(postingStackView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(postImage == nil ? 0 : 200)
      $0.width.equalToSuperview().inset(30)
    }
    
    postingUserTextLabel.snp.makeConstraints {
      $0.top.equalTo(postingImage.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().inset(30)
    }
    
    bottomStackView.snp.makeConstraints {
      $0.top.equalTo(postingUserTextLabel.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().inset(30)
      $0.height.equalTo(50)
    }
  }
  
  private func configureUI() {
    postingTitleText.text = postTitle
    postingUserTextLabel.text = postContent
    postingLocationeName1.text = postAddress
    self.title = postTitleTop
    
    if let image = postImage {
      postingImage.image = image
      postingImage.alpha = 1
    } else {
      postingImage.alpha = 0
    }
    
    if let time = postTimes {
      postingTimeLabel.text = formatTime(from: time)
    }
    
    view.layoutIfNeeded()
  }
  
  private func setupBindings() {
    ripotButton.rx.tap
      .bind { [weak self] in
        self?.showReportAlert()
      }
      .disposed(by: disposeBag)
  }
  
  private func loadImage(from url: URL) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.postImage = image
          self.configureUI()
        }
      }
    }.resume()
  }
  
  private func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
  }
  
  private func showReportAlert() {
    let reportAlert = UIAlertController(
      title: "신고하기",
      message: "해당 이용자를 신고 하시겠습니까?",
      preferredStyle: .alert
    )
    
    reportAlert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
    reportAlert.addAction(UIAlertAction(title: "신고하기", style: .cancel, handler: { [weak self] _ in
      self?.showReportConfirmationAlert()
    }))
    present(reportAlert, animated: true, completion: nil)
  }
  
  private func showReportConfirmationAlert() {
    let confirmationAlert = UIAlertController(
      title: "신고",
      message: "신고가 완료되었습니다.",
      preferredStyle: .alert
    )
    
    confirmationAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
    present(confirmationAlert, animated: true, completion: nil)
  }
}
