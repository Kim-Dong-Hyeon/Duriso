//
//  PostingViewController.swift
//  Duriso
//
//  Created by 신상규 on 9/10/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import RxCocoa
import RxSwift
import SnapKit

class PostingViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let firestore = Firestore.firestore()
  private let nickname: BehaviorSubject<String> = BehaviorSubject(value: "")
  
  var userId: String?
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
  
  private var currentNickname: String = ""
  
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
    fetchUserId()
    self.title = postTitleTop
    likeButtonTap()
    configureUI()
    changeButtonTap()
    removalButtonTap()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchLikesStatus()
  }
  
  //MARK: - 버튼 텝 이벤트
  private func changeButtonTap() {
    changeButton.rx.tap
      .bind { [weak self] in
        self?.checkIfUserCanEdit()
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
  
  //MARK: - 게시글 수정
  private func checkIfUserCanEdit() {
    guard let postUserNickname = post?.author else { return }

    if postUserNickname == self.currentNickname {
          presentEditViewController()
      } else {
          let alert = UIAlertController(
              title: "수정 권한 없음",
              message: "이 포스트를 수정할 수 있는 권한이 없습니다.",
              preferredStyle: .alert
          )
          alert.addAction(UIAlertAction(title: "확인", style: .default))
          present(alert, animated: true)
      }
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
  private func fetchLikesStatus() {
    guard let documentRef = documentRef, let userId = userId else { return }
    
    documentRef.getDocument { [weak self] (document, error) in
      if let document = document, document.exists {
        let data = document.data()
        let likedUsers = data?["likedUsers"] as? [String] ?? []
        
        // 사용자가 좋아요를 눌렀는지 확인
        self?.isLiked = likedUsers.contains(userId)
        self?.likeCount = (data?["likescount"] as? Int) ?? 0
        
        // UI 업데이트
        self?.updateLikeButton()
      }
    }
  }
  
  private func updateLikeButton() {
    likeNumberLabel.text = "\(likeCount)"
    likeButton.tintColor = isLiked ? .red : .lightGray
  }
  
  private func toggleLike() {
    isLiked.toggle()
    
    likeCount += isLiked ? 1 : -1
    likeNumberLabel.text = "\(likeCount)"
    likeButton.tintColor = isLiked ? .red : .lightGray
  }
  
  private func updateLikesCount(increment: Bool) {
    guard let documentRef = documentRef, let userId = userId else { return }
    
    let incrementValue: Int = increment ? 1 : -1
    let updateData: [String: Any] = [
      "likescount": FieldValue.increment(Int64(incrementValue)),
      "likedUsers": increment ? FieldValue.arrayUnion([userId]) : FieldValue.arrayRemove([userId])
    ]
    
    documentRef.updateData(updateData) { error in
      if let error = error {
        print("좋아요 수 업데이트 실패: \(error.localizedDescription)")
      } else {
        print("좋아요 수 업데이트 성공")
      }
    }
  }
  
  //MARK: - 유저확인
  private func fetchUserId() {
      guard let user = Auth.auth().currentUser else { return }

      let safeEmail = user.email?.replacingOccurrences(of: ".", with: "-") ?? ""

      firestore.collection("users").document(safeEmail).getDocument { [weak self] (document, error) in
          guard let self = self else { return }
          if let document = document, document.exists {
              let data = document.data()
              let nicknameFromFirestore = data?["nickname"] as? String ?? "닉네임 없음"
              self.currentNickname = nicknameFromFirestore
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
    } else {
      // 이미지가 없으면 configureUI를 호출
      configureUI()
    }
  }
  
  // 이미지 로드
  private func loadImage(from url: URL) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.postImage = image
          self.configureUI() // 이미지 로드가 완료된 후 UI 업데이트
        }
      } else {
        DispatchQueue.main.async {
          // 이미지 로드 실패 시 UI를 업데이트할 수 있습니다.
          self.postImage = nil
          self.configureUI() // 이미지가 없으니 UI 업데이트
        }
      }
    }.resume()
  }
  
  // MARK: - 삭제 확인 및 실행
  private func confirmDeletion() {
      guard let postUserNickname = post?.author else { return }

      // 닉네임이 일치하지 않을 때 삭제 권한이 없다는 메시지
      if postUserNickname != self.currentNickname {
          let alert = UIAlertController(
              title: "삭제 권한 없음",
              message: "이 포스트를 삭제할 수 있는 권한이 없습니다.",
              preferredStyle: .alert
          )
          alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
          present(alert, animated: true, completion: nil)
          return
      }

      // 닉네임이 일치할 때 삭제 확인 알림 표시
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
   
  // MARK: -  타입명시
  private func configureUI() {
    postingTitleText.text = postTitle
    postingUserTextLabel.text = postContent
    postingLocationeName1.text = postAddress
    self.title = postTitleTop
    
    if let image = postImage {
      postingImage.image = image
      postingImage.alpha = 1
      postingImage.snp.updateConstraints {
        $0.height.equalTo(200) // 이미지가 있을 때 높이 200
      }
    } else {
      postingImage.alpha = 0
      postingImage.snp.updateConstraints {
        $0.height.equalTo(0) // 이미지가 없을 때 높이를 0
      }
    }
    
    if let time = postTimes {
      postingTimeLabel.text = formatTime(from: time)
    }
    
    view.layoutIfNeeded()
  }
  
  // MARK: -  timeStamp 변환
  private func formatTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
  }
  
  
  // MARK: -  신고하기
  private func showReportAlert() {
    
    let reportAlert = UIAlertController(
      title: "신고하기",
      message: "해당 이용자를 신고 하시겠습니까?",
      preferredStyle: .alert
    )
    
    reportAlert.addAction(UIAlertAction(title: "신고하기", style: .destructive, handler: { [weak self] _ in
      self?.checkIfUserCanReport()
    }))
    
    reportAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    
    present(reportAlert, animated: true, completion: nil)
  }
  
  private func checkIfUserCanReport() {
    guard let user = Auth.auth().currentUser else { return }
    let userId = user.uid
    
    documentRef?.getDocument { [weak self] (document, error) in
      if let document = document, document.exists {
        let data = document.data()
        let reportedUsers = data?["reportedUsers"] as? [String] ?? []
        
        if reportedUsers.contains(userId) {
          self?.showAlreadyReportedAlert()
        } else {
          self?.updateReportCount()
        }
      }
    }
  }
  
  private func showAlreadyReportedAlert() {
    let alert = UIAlertController(title: "알림", message: "이미 신고한 사용자입니다.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    present(alert, animated: true, completion: nil)
  }
  
  private func updateReportCount() {
    guard let user = Auth.auth().currentUser, let documentRef = documentRef else { return }
    let userId = user.uid
    
    documentRef.updateData([
      "reportcount": FieldValue.increment(Int64(1)),
      "reportedUsers": FieldValue.arrayUnion([userId])
    ]) { error in
      if let error = error {
        print("신고 수 업데이트 실패: \(error.localizedDescription)")
      } else {
        print("신고 수 업데이트 성공")
        self.showReportConfirmationAlert()
      }
    }
  }
  
  private func showReportConfirmationAlert() {
    let confirmationAlert = UIAlertController(
      title: "신고",
      message: "신고가 완료되었습니다.",
      preferredStyle: .alert
    )
    confirmationAlert.addAction(UIAlertAction(title: "확인", style: .default))
    present(confirmationAlert, animated: true, completion: nil)
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
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
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
}
