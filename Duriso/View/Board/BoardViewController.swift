//
//  BoardViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit

class BoardViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let tableItems = BehaviorRelay<[Posts]>(value: [])
  private let dataSource = SomeDataModel.Mocks.getDataSource()
  private var allPosts: [Posts] = []  // 전체 게시물 배열
  private var filteredPosts: [Posts] = []  // 필터링된 게시물 배열
  private let onlineViewController = OnlineViewController()
  private let firestore = Firestore.firestore()
  private let regionFetcher = RegionFetcher()
  private let nickname: BehaviorSubject<String> = BehaviorSubject(value: "")
  private var currentUUID: String = ""
  private let refreshControl = UIRefreshControl()
  
  private var latitude: Double = 0.0
  private var longitude: Double = 0.0
  
  //MARK: - UI
  private let notificationHeadLabel = UILabel().then {
    $0.text = "우리동네 알리미"
    $0.font = CustomFont.Deco.font()
  }
  
  public let notificationHeadImage = UIImageView().then {
    $0.image = UIImage(systemName: "megaphone")
    $0.tintColor = .red
  }
  
  private let notificationLineView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let writingButton = UIButton().then {
    $0.setTitle("글쓰기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.titleLabel?.font = CustomFont.Body3.font()
    // 코너 둥글게
    $0.layer.cornerRadius = 17
    $0.clipsToBounds = true
    // 패딩 설정
    $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    // 그림자 추가
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    $0.layer.shadowOpacity = 0.2
    $0.layer.shadowRadius = 4
    // 버튼에 아이콘 추가
    let plusIcon = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
    $0.setImage(plusIcon, for: .normal)
    $0.tintColor = .CWhite
    $0.imageView?.contentMode = .scaleAspectFit
    
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
  }
  
  private let notificationCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: BoardCollectionViewCell.boardCell)
    return collectionView
  }()
  
  private let notificationLineView1 = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let notificationTableView = UITableView().then {
    $0.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.boardTableCell)
    $0.estimatedRowHeight = 100 // 예상 높이 설정
    $0.rowHeight = UITableView.automaticDimension // 자동 높이 계산
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
//    fetchUserData()
    notificationTableView.delegate = self
    
    fetchUserNickname()
    setupLayout()
    fetchPosts()
    bindBoardTableView()
    bindCollectionView()
    writingButtonTap()
    setupRefreshControl()
    fetchFilteredPosts()
    
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      self?.latitude = latitude
      self?.longitude = longitude
      print("Updated Location: Latitude \(latitude), Longitude \(longitude)")
      self?.updateLocationNames(latitude: latitude, longitude: longitude)
    }
  }
  //MARK: - Firebase
  //uuid추출
  private func fetchUserNickname() {
    guard let user = Auth.auth().currentUser else { return }
    
//    let safeEmail = user.email?.replacingOccurrences(of: ".", with: "-") ?? ""
    let uid = user.uid
    firestore.collection("users").document(uid).getDocument { [weak self] (document, error) in
        guard let self = self else { return }
        if let document = document, document.exists {
            let data = document.data()
            let nickname = data?["uuid"] as? String ?? "닉네임 없음"
            self.currentUUID = nickname
            
            // displayName 업데이트
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = nickname
            changeRequest.commitChanges { error in
                if let error = error {
                    print("업데이트 실패: \(error.localizedDescription)")
                } else {
                    print("업데이트 성공: \(nickname)")
                }
            }
            print("사용자 닉네임: \(self.currentUUID)")
        } else {
            print("사용자 데이터를 불러오는 데 실패했습니다: \(error?.localizedDescription ?? "")")
        }
    }
}
  
  //글정렬
  private func fetchPosts() {
    firestore.collection("posts").addSnapshotListener { [weak self] snapshot, error in
      if let error = error {
        print("데이터 가져오기 실패: \(error.localizedDescription)")
      } else {
        guard let documents = snapshot?.documents else { return }
        let posts = documents.compactMap { document -> Posts? in
          try? document.data(as: Posts.self)
        }
        self?.allPosts = posts
        let sortedPosts = posts.sorted { $0.posttime > $1.posttime } // 최신순으로 정렬
        self?.tableItems.accept(sortedPosts)
      }
    }
  }
  
  //차단
  private func fetchFilteredPosts() {
    guard let user = Auth.auth().currentUser else { return }
    
//    let safeEmail = user.email?.replacingOccurrences(of: ".", with: "-") ?? ""
    let uid = user.uid
    let userRef = firestore.collection("users").document(uid)
    
    userRef.getDocument { [weak self] (document, error) in
      if let document = document, document.exists {
        let blockedUsers = document.data()?["blockedusers"] as? [String] ?? []
        
        self?.firestore.collection("posts").getDocuments { (querySnapshot, error) in
          if let querySnapshot = querySnapshot {
            let posts = querySnapshot.documents.compactMap { document -> Posts? in
              try? document.data(as: Posts.self)
            }
            
            let filteredPosts = posts.filter { post in
              let authorUID = post.author
              return !blockedUsers.contains(authorUID)
            }
            
            let sortedFilteredPosts = filteredPosts.sorted { $0.posttime > $1.posttime }
            self?.tableItems.accept(sortedFilteredPosts)
          }
        }
      }
    }
  }
  
  
  //MARK: - 지역정보 가져오기
  private func updateLocationNames(latitude: Double, longitude: Double) {
    regionFetcher.fetchRegion(longitude: longitude, latitude: latitude) { [weak self] documents, error in
      guard let self = self else { return }
      if let document = documents?.first {
        let si = document.region1DepthName
        let gu = document.region2DepthName
        let dong = document.region3DepthName
        
        self.onlineViewController.si = si
        self.onlineViewController.gu = gu
        self.onlineViewController.dong = dong
        print("Updated Region: SI \(si), GU \(gu), DONG \(dong)")
      } else if let error = error {
        print("지역 정보 가져오기 실패: \(error.localizedDescription)")
      }
    }
  }
  
  //MARK: - 상단 스크롤 카테고리 콜랙션 뷰
  private func bindCollectionView() {
    Observable.just(dataSource)
      .bind(to: notificationCollectionView.rx.items(cellIdentifier: BoardCollectionViewCell.boardCell, cellType: BoardCollectionViewCell.self)) { index, model, cell in
        cell.configure(with: model)
        cell.bindTapAction {
          print("\(model.name) 버튼이 눌렸습니다!")
          self.handleButtonTap(for: model)
        }
      }
      .disposed(by: disposeBag)
  }
  
  // UICollectionViewDelegateFlowLayout: 셀 크기 계산
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCollectionViewCell.boardCell, for: indexPath) as? BoardCollectionViewCell else {
      return CGSize(width: 100, height: 50)  // 기본 크기
    }
    
    let width = cell.calculateCellWidth()  // 셀 안의 버튼 크기에 맞는 너비 계산
    return CGSize(width: width, height: 50)  // 버튼 크기에 맞게 셀 크기 반환
  }
  
  // 셀 간의 좌우 여백 설정
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  // 섹션 간의 여백 설정
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  //MARK: - 재난별 버튼
  private func handleButtonTap(for model: SomeDataModel) {
    guard let user = Auth.auth().currentUser else { return }
    
//    let safeEmail = user.email?.replacingOccurrences(of: ".", with: "-") ?? ""
    let uid = user.uid
    let userRef = firestore.collection("users").document(uid)
    
    userRef.getDocument { [weak self] (document, error) in
      if let document = document, document.exists {
        let blockedUsers = document.data()?["blockedusers"] as? [String] ?? []  // 현재 사용자의 blockedusers 배열 가져오기
        
        switch model.type {
        case .allPerson:
          self?.filteredPosts = self?.allPosts.filter { post in
            !blockedUsers.contains(post.author)  // 차단된 사용자의 게시물 제외
          } ?? []
        case .atipoff:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "긴급제보" && !blockedUsers.contains($0.author) } ?? []
        case .typhoon:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "태풍" && !blockedUsers.contains($0.author) } ?? []
        case .earthquake:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "지진" && !blockedUsers.contains($0.author) } ?? []
        case .flood:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "홍수" && !blockedUsers.contains($0.author) } ?? []
        case .tsunami:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "쓰나미" && !blockedUsers.contains($0.author) } ?? []
        case .nuclear:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "핵폭발" && !blockedUsers.contains($0.author) } ?? []
        case .fire:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "산불" && !blockedUsers.contains($0.author) } ?? []
        case .alandslide:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "산사태" && !blockedUsers.contains($0.author) } ?? []
        case .hot:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "폭염" && !blockedUsers.contains($0.author) } ?? []
        case .bigSnow:
          self?.filteredPosts = self?.allPosts.filter { $0.category == "대설" && !blockedUsers.contains($0.author) } ?? []
        }
        
        let sortedFilteredPosts = self?.filteredPosts.sorted { $0.posttime > $1.posttime }
        self?.tableItems.accept(sortedFilteredPosts ?? [])  // 필터링된 게시물을 테이블 뷰에 반영
      }
    }
  }
  
  //MARK: - 글쓰기 버튼
  private func writingButtonTap() {
      writingButton.rx.tap
        .subscribe(onNext: { [weak self] in
          if Auth.auth().currentUser == nil {
            self?.showLoginAlert()
          } else {
            self?.writingNavigation()
          }
        })
        .disposed(by: disposeBag)
  }
  
  private func showLoginAlert() {
      let alert = UIAlertController(title: "회원가입 필요", message: "게시글을 작성하려면 회원가입이 필요합니다.", preferredStyle: .alert)
      
      let signUpAction = UIAlertAction(title: "확인", style: .default) { _ in
          self.navigateToLogin()
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      
      alert.addAction(signUpAction)
      alert.addAction(cancelAction)
      
      self.present(alert, animated: true, completion: nil)
  }
  
  private func navigateToLogin() {
    let loginVC = LoginViewController()
    let navController = UINavigationController(rootViewController: loginVC)
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      let window = windowScene.windows.first
      window?.rootViewController = navController
      window?.makeKeyAndVisible()
    }
  }
  
  private func uploadImageAndGetURL(_ image: UIImage?, completion: @escaping (String?) -> Void) {
    FirebaseFirestoreManager.shared.uploadImage(image ?? UIImage()) { result in
      switch result {
      case .success(let imageUrl):
        completion(imageUrl)
      case .failure(let error):
        print("Error uploading image: \(error.localizedDescription)")
        completion(nil)
      }
    }
  }
  
  //MARK: - 게시글 쓰기
  private func writingNavigation() {
    let postViewController = WritingViewController()
    postViewController.onPostAdded = { [weak self] title, content, settingImage, categorys in
      guard let self = self else { return }
      
      guard let user = Auth.auth().currentUser else { return }
      
      self.uploadImageAndGetURL(settingImage) { imageUrl in
        let newPost = Posts(
          author: self.currentUUID,  // 작성자 이름
          contents: content,
          category: categorys,
          dong: self.onlineViewController.dong,
          gu: self.onlineViewController.gu,
          likescount: 0,
          postid: UUID().uuidString,  // 고유한 ID 생성
          postlatitude: self.latitude,
          postlongitude: self.longitude,
          posttime: Date(), // 현재 시간 설정
          reportcount: 0,
          si: self.onlineViewController.si,
          title: title,
          imageUrl: imageUrl
        )
        
        self.firestore.collection("posts").document(newPost.postid).setData(newPost.toDictionary()) { error in
          if let error = error {
            print("Firestore에 데이터 저장 실패: \(error.localizedDescription)")
          } else {
            print("게시글 저장 성공")
          }
        }
        
        // 테이블 아이템 업데이트
        var currentItems = self.tableItems.value
        currentItems.append(newPost)
        self.tableItems.accept(currentItems) // 테이블 아이템 업데이트
      }
    }
    self.navigationController?.pushViewController(postViewController, animated: true)
  }
  
  //MARK: - 테이블 뷰
  private func bindBoardTableView() {
    tableItems
      .bind(to: notificationTableView.rx.items(cellIdentifier: BoardTableViewCell.boardTableCell, cellType: BoardTableViewCell.self)) { index, post, cell in
        cell.configure(with: post)
        cell.delegate = self
      }
      .disposed(by: disposeBag)
    
    notificationTableView.rx.modelSelected(Posts.self)
      .subscribe(onNext: { [weak self] post in
        self?.didTapCell(with: post)
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchPostsd() {
    firestore.collection("posts").addSnapshotListener { [weak self] snapshot, error in
      if let error = error {
        self?.refreshControl.endRefreshing()
      } else {
        guard let documents = snapshot?.documents else { return }
        let posts = documents.compactMap { document -> Posts? in
          try? document.data(as: Posts.self)
        }
        self?.allPosts = posts
        let sortedPosts = posts.sorted { $0.posttime > $1.posttime }
        self?.tableItems.accept(sortedPosts)
        self?.refreshControl.endRefreshing()
        self?.fetchFilteredPosts()
      }
    }
  }
  
  private func setupRefreshControl() {
    refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
    notificationTableView.refreshControl = refreshControl
  }
  
  @objc private func refreshPosts() {
    fetchPostsd()
    fetchFilteredPosts()
  }
  
  //MARK: - 제약조건
  private func setupLayout() {
    [
      notificationHeadLabel,
      notificationHeadImage,
      notificationLineView,
      notificationCollectionView,
      notificationLineView1,
      notificationTableView,
      writingButton
    ].forEach { view.addSubview($0) }
    
    notificationHeadLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.equalTo(30)
    }
    
    notificationHeadImage.snp.makeConstraints {
      $0.leading.equalTo(notificationHeadLabel.snp.trailing).offset(8)
      $0.centerY.equalTo(notificationHeadLabel)
      $0.size.equalTo(25)
    }
    
    notificationLineView.snp.makeConstraints {
      $0.top.equalTo(notificationHeadLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    notificationCollectionView.snp.makeConstraints {
      $0.top.equalTo(notificationLineView.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(60)
    }
    
    notificationLineView1.snp.makeConstraints {
      $0.top.equalTo(notificationCollectionView.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    notificationTableView.snp.makeConstraints {
      $0.top.equalTo(notificationLineView1.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().inset(150)
      $0.height.greaterThanOrEqualTo(100)
    }
    
    writingButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-18)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(34)
      $0.width.greaterThanOrEqualTo(100)
    }
  }
}

extension BoardViewController: UITableViewDelegate {
  // UITableViewDelegate 메서드 추가
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110  // 고정된 셀 높이 설정 (필요한 높이로 수정 가능)
  }
}

extension BoardViewController: BoardTableViewCellDelegate {
  func didTapCell(with post: Posts) {
    print("didTapCell called with post: \(post)")
    let postingViewController = UserPostViewController()
    postingViewController.setPostData(post: post) // 전달된 post 데이터를 기반으로 설정
    self.navigationController?.pushViewController(postingViewController, animated: true)
  }
}
