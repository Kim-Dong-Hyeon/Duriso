//
//  BoardViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import Firebase
import FirebaseFirestore
import FirebaseStorage
import RxCocoa
import RxSwift
import SnapKit

class BoardViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  private let tableItems = BehaviorRelay<[Posts]>(value: [])
  private let dataSource = SomeDataModel.Mocks.getDataSource()
  private var allPosts: [Posts] = []  // 전체 게시물 배열
  private var filteredPosts: [Posts] = []  // 필터링된 게시물 배열
  
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
    $0.setTitle("+글쓰기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 15
    $0.titleLabel?.font = CustomFont.Deco4.font()
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
    $0.rowHeight = 100 // 셀 높이 설정
  }
  
  private let postService = PostService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupLayout()
    writingButtonTap()
    bindBoardTableView()
    bindCollectionView()
    notificationTableView.estimatedRowHeight = 120
    notificationTableView.rowHeight = UITableView.automaticDimension
  }
  
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
  
  private func handleButtonTap(for model: SomeDataModel) {
    switch model.type {
    case .allPerson:
      filteredPosts = allPosts
    case .atipoff:
      filteredPosts = allPosts.filter { $0.categorys == "긴급제보" }
    case .typhoon:
      filteredPosts = allPosts.filter { $0.categorys == "태풍" }
    case .earthquake:
      filteredPosts = allPosts.filter { $0.categorys == "지진" }
    case .flood:
      filteredPosts = allPosts.filter { $0.categorys == "홍수" }
    case .tsunami:
      filteredPosts = allPosts.filter { $0.categorys == "쓰나미" }
    case .nuclear:
      filteredPosts = allPosts.filter { $0.categorys == "핵폭발" }
    case .fire:
      filteredPosts = allPosts.filter { $0.categorys == "산불" }
    case .alandslide:
      filteredPosts = allPosts.filter { $0.categorys == "산사태" }
    case .hot:
      filteredPosts = allPosts.filter { $0.categorys == "폭염" }
    }
    tableItems.accept(filteredPosts)
  }
  
  private func writingButtonTap() {
    writingButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.reportNavigation()
      })
      .disposed(by: disposeBag)
  }
  
  private func uploadImageAndGetURL(_ image: UIImage?, completion: @escaping (String?) -> Void) {
      postService.uploadImage(image ?? UIImage()) { result in
          switch result {
          case .success(let imageUrl):
              completion(imageUrl) // 성공적으로 얻은 URL을 반환
          case .failure(let error):
              print("Error uploading image: \(error.localizedDescription)")
              completion(nil) // 실패 시 nil 반환
          }
      }
  }
  
  private func reportNavigation() {
    let postViewController = PostViewController()
    postViewController.onPostAdded = { [weak self] title, content, settingImage, categorys in
      guard let self = self else { return }
      
      self.uploadImageAndGetURL(settingImage) { imageUrl in
        // 게시글 생성
        let newPost = Posts(
          author: "작성자 이름",  // 작성자 이름을 설정
          contents: content,
          categorys: categorys,
          dong: "동",
          gu: "구",
          likescount: 0,
          postid: UUID().uuidString,  // 고유한 ID 생성
          postlocation: GeoPoint(latitude: 0, longitude: 0), // 위치 정보를 설정
          posttime: Timestamp(date: Date()), // 현재 시간 설정
          reportcount: 0,
          si: "시",
          title: title,
          imageUrl: imageUrl
        )
        
        // 테이블 아이템 업데이트
        var currentItems = self.tableItems.value
        currentItems.append(newPost)
        self.tableItems.accept(currentItems)
      }
    }
    self.navigationController?.pushViewController(postViewController, animated: true)
  }
  
  private func bindBoardTableView() {
    tableItems
      .bind(to: notificationTableView.rx.items(cellIdentifier: BoardTableViewCell.boardTableCell, cellType: BoardTableViewCell.self)) { index, post, cell in
        print("Post at index \(index): \(post)")
        cell.configure(with: post)
      }
      .disposed(by: disposeBag)
    
    notificationTableView.rx.modelSelected(Posts.self)
      .subscribe(onNext: { [weak self] post in
        self?.didTapCell(with: post)
      })
      .disposed(by: disposeBag)
  }
  
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
    }
    
    writingButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(100)
      $0.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(30)
      $0.width.equalTo(80)
    }
  }
}

extension BoardViewController: BoardTableViewCellDelegate {
  func didTapCell(with post: Posts) {
    let postingViewController = PostingViewController()
    postingViewController.postTitle = post.title
    postingViewController.postContent = post.contents
    postingViewController.postTitleTop = post.categorys
    
    // 비동기적으로 이미지를 로드
    if let imageUrl = post.imageUrl {
      UIImage.from(url: imageUrl) { image in
        DispatchQueue.main.async {
          postingViewController.postImage = image
          self.navigationController?.pushViewController(postingViewController, animated: true)
        }
      }
    } else {
      navigationController?.pushViewController(postingViewController, animated: true)
    }
  }
}

extension UIImage {
  static func from(url: String?, completion: @escaping (UIImage?) -> Void) {
    guard let urlString = url, let url = URL(string: urlString) else {
      completion(nil)
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        print("Failed to load image: \(error.localizedDescription)")
        completion(nil)
        return
      }
      
      guard let data = data, let image = UIImage(data: data) else {
        completion(nil)
        return
      }
      
      DispatchQueue.main.async {
        completion(image)
      }
    }.resume()
  }
}
