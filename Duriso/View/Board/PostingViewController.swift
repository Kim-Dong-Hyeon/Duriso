//
//  PostingViewController.swift
//  Duriso
//
//  Created by 신상규 on 9/10/24.
//

import UIKit

import FirebaseFirestore
import FirebaseStorage
import RxCocoa
import RxSwift
import SnapKit

class PostingViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var postTitle: String?
  var postContent: String?
  var postImage: UIImage?
  var postTitleTop: String?
  var postAddress: String?
  var postTimes: Date?
  var post: Posts?
  
  private let postingScrollView = UIScrollView()
  private let contentView = UIView()
  
  private var isLiked = false
  private var likeCount = 0
  
  let db = Firestore.firestore()
  var documentRef: DocumentReference?
  
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
  
  private let likeButton = UIButton().then {
    $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    $0.backgroundColor = .clear
    $0.tintColor = .lightGray
  }
  
  private let likeNumberLabel = UILabel().then {
    $0.text = "0"
    $0.font = CustomFont.Body3.font()
  }
  
  private let likeStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .trailing
    $0.distribution = .equalSpacing
    $0.spacing = 8
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    alertButtonTap()
    self.title = postTitleTop
    likeButtonTap()
    configureUI()
    changeButtonTap()
    removalButtonTap()
  }
  
  //MARK: - 버튼 텝 이벤트
  private func changeButtonTap() {
    changeButton.rx.tap
      .bind { [weak self] in
        self?.presentEditViewController()
      }
      .disposed(by: disposeBag)
  }
  
  private func likeButtonTap() {
    likeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.toggleLike()
        self?.updateLikesCount(increment: self?.isLiked ?? false)
      })
      .disposed(by: disposeBag)
  }
  
  private func alertButtonTap() {
    ripotButton.rx.tap
      .bind { [weak self] in
        self?.showReportAlert()
      }
      .disposed(by: disposeBag)
  }
  
  private func removalButtonTap() {
    removalButton.rx.tap
      .bind { [weak self] in
        self?.confirmDeletion()
      }
      .disposed(by: disposeBag)
  }
  
  
  private func presentEditViewController() {
    guard let post = self.post else { return }
    let postChangeViewController = PostChangeViewController()
    postChangeViewController.currentPost = post
    postChangeViewController.onPostUpdated = { [weak self] title, content, image, category in
      self?.postTitle = title
      self?.postContent = content
      self?.postImage = image
      self?.postTitleTop = category
      self?.configureUI()
    }
    let navigationController = UINavigationController(rootViewController: postChangeViewController)
    self.navigationController?.pushViewController(postChangeViewController, animated: true)
  }
  
  //MARK: - 좋아요 만들기
  
  private func toggleLike() {
    isLiked.toggle()
    
    if isLiked {
      likeCount += 1
      likeButton.tintColor = .red
    } else {
      likeCount -= 1
      likeButton.tintColor = .lightGray
    }
    
    likeNumberLabel.text = "\(likeCount)"
  }
  
  // 좋아요수 저장 메서드
  private func updateLikesCount(increment: Bool) {
    guard let documentRef = documentRef else { return }
    
    let incrementValue: Int = increment ? 1 : -1
    
    documentRef.updateData([
      "likescount": FieldValue.increment(Int64(incrementValue))
    ]) { error in
      if let error = error {
        print("좋아요 수 업데이트 실패: \(error.localizedDescription)")
      } else {
        print("좋아요 수 업데이트 성공")
      }
    }
  }
  
  // MARK: - 데이터 확인
  
  func setPostData(post: Posts) {
    self.post = post  // 추가: Post 객체 설정
    self.postTitle = post.title
    self.postContent = post.contents
    self.postAddress = "\(post.si) \(post.gu) \(post.dong)"
    self.postTimes = post.posttime
    self.postTitleTop = post.category
    self.documentRef = db.collection("posts").document(post.postid)
    
    // 이미지 로드
    if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
      loadImage(from: url)
    }
    
    // UI 업데이트
    configureUI()
  }
  
  // MARK: - 삭제 확인 및 실행
  private func confirmDeletion() {
    let alertController = UIAlertController(
      title: "삭제 확인",
      message: "이 포스트를 삭제하시겠습니까?",
      preferredStyle: .alert
    )
    
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    alertController.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
      self?.deletePost()
    }))
    
    present(alertController, animated: true, completion: nil)
  }
  
  private func deletePost() {
    guard let documentRef = documentRef else { return }
    
    // Firestore에서 데이터 삭제
    documentRef.delete { [weak self] error in
      if let error = error {
        print("포스트 삭제 실패: \(error.localizedDescription)")
      } else {
        print("포스트 삭제 성공")
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  // MARK: - 레이아웃
  private func setupView() {
    [
      postingScrollView,
      bottomStackView,
      likeStackView
    ].forEach { view.addSubview($0) }
    
    [
      postingTitleText,
      postingLineView,
      postingLocationeName1,
      postingStackView,
      postingImage,
      postingUserTextLabel,
      contentView
    ].forEach { postingScrollView.addSubview($0) }
    
    [
      postingTimeText,
      postingTimeLabel
    ].forEach { postingStackView.addArrangedSubview($0) }
    
    let spacerView = UIView()
    
    [
      ripotButton,
      spacerView,
      changeButton,
      removalButton
    ].forEach { bottomStackView.addArrangedSubview($0) }
    
    [
      likeButton,
      likeNumberLabel
    ].forEach { likeStackView.addArrangedSubview($0) }
    
    setupConstraints()
  }
  
  private func setupConstraints() {
    postingScrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(postingScrollView.snp.width)
    }
    
    postingTitleText.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(contentView.snp.top).offset(16)
      $0.height.equalTo(30)
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
      $0.height.equalTo(30)
    }
    
    postingStackView.snp.makeConstraints {
      $0.top.equalTo(postingLocationeName1.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(30)
    }
    
    postingImage.snp.makeConstraints {
      $0.top.equalTo(postingStackView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(200)
      $0.width.equalToSuperview().inset(30)
    }
    
    postingUserTextLabel.snp.makeConstraints {
      $0.top.equalTo(postingImage.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().inset(30)
    }
    
    likeStackView.snp.makeConstraints {
      $0.top.equalTo(postingUserTextLabel.snp.bottom).offset(16)
      $0.trailing.equalToSuperview().inset(30)
      $0.height.equalTo(30)
      $0.width.greaterThanOrEqualTo(60)
    }
    
    likeButton.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(30)
    }
    
    likeNumberLabel.snp.makeConstraints {
      $0.leading.equalTo(likeButton.snp.trailing).offset(8)
      $0.centerY.equalToSuperview()
    }
    
    bottomStackView.snp.makeConstraints {
      $0.top.equalTo(likeStackView.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().inset(30)
      $0.height.equalTo(50)
      $0.bottom.equalTo(contentView.snp.bottom).offset(-16)
    }
  }
  
  // MARK: -  타입명시
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
  
  // MARK: -  timeStamp 변환
  private func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
  }
  
  // MARK: -  신고 Alert
  
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
    
    confirmationAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { [weak self] _ in
      self?.updateReportCount()
    }))
    present(confirmationAlert, animated: true, completion: nil)
  }
  
  // 신고수 Firebase에 저장 메서드
  private func updateReportCount() {
    guard let documentRef = documentRef else { return }
    
    let incrementValue: Int = 1
    
    documentRef.updateData([
      "reportcount": FieldValue.increment(Int64(incrementValue))
    ]) { error in
      if let error = error {
        print("신고 수 업데이트 실패: \(error.localizedDescription)")
      } else {
        print("신고 수 업데이트 성공")
      }
    }
  }
}
