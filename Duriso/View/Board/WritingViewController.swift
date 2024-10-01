//
//  PostViewController.swift
//  Duriso
//
//  Created by 신상규 on 9/2/24.
//

import UIKit

import AVFoundation
import Photos
import RxCocoa
import RxSwift
import SnapKit

class WritingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let disposeBag = DisposeBag()
  var onPostAdded: ((String, String, UIImage?, String) -> Void)?
  private let regionFetcher = RegionFetcher()
  private let kakaoMap = KakaoMapViewController()
  private let tableItems = BehaviorRelay<[Category]>(value: [])
  var currentPost: Posts?
  
  
  private let categoryButton = UIButton().then {
    $0.setTitle("카테고리", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 17
    $0.titleLabel?.font = CustomFont.Head4.font()
  }
  
  private let categoryTouch = UILabel().then {
    $0.text = ""
    $0.font = CustomFont.Head2.font()
    $0.textColor = .black
  }
  
  private let titleName = UILabel().then {
    $0.text = "제목:"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private let titleText = UITextField().then {
    $0.text = ""
    $0.placeholder = "제목을 입력해주세요"
  }
  
  private let lineView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let locationeName = UILabel().then {
    $0.text = "현재위치: "
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private var locationeName1 = UILabel().then {
    $0.text = "위치 읽는중..."
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private let lineView1 = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let userTextSet = UITextView().then {
    $0.text = "내용을 입력해주세요.\n\n부적절한 내용이나 불쾌감을 줄 수 있는 내용은 제제를 받을 수 있습니다."
    $0.textColor = .placeholderText
    $0.font = CustomFont.sub.font()
  }
  
  private let pictureButton = UIButton().then {
    $0.setTitle("사진추가", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 20
    $0.titleLabel?.font = CustomFont.Head4.font()
  }
  
  private let deleteButton = UIButton().then {
    $0.setImage(UIImage(named: "trash"), for: .normal)
    $0.tintColor = .red
    $0.isHidden = true
  }
  
  private let pickerImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.isHidden = true
  }
  
  private let categoryTableView = UITableView().then {
    $0.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.categoryCell)
    $0.isHidden = true
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray.cgColor
    $0.layer.cornerRadius = 15
  }
  
  func updateLocationNames(latitude: Double, longitude: Double) {
    regionFetcher.fetchRegion(longitude: longitude, latitude: latitude) { [weak self] documents, error in
      guard let self = self else { return }
      if let document = documents?.first {
        let si = document.region1DepthName
        let gu = document.region2DepthName
        let dong = document.region3DepthName
        
        DispatchQueue.main.async {
          self.locationeName1.text = "\(si) \(gu) \(dong)"
          if var currentPost = self.currentPost {
            currentPost.si = document.region1DepthName
            currentPost.gu = document.region2DepthName
            currentPost.dong = document.region3DepthName
            currentPost.postlatitude = self.kakaoMap.latitude
            currentPost.postlongitude = self.kakaoMap.longitude
            
            self.onPostAdded?(currentPost.title, currentPost.contents, UIImage(), currentPost.category)
          }
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    reportNavigationItem()
    reportViewLayOut()
    pictureButtonTap()
    deleteButtonTap()
    categoryButtonTap()
    bindCategoryTableView()
    bindCategoryTableViewModel()
    userTextSet.delegate = self
    deleteButton.isHidden = true
    categoryTableView.isHidden = true
    LocationManager.shared.onLocationUpdate = { [weak self] latitude, longitude in
      print("LocationManager에서 위치 업데이트 수신: \(latitude), \(longitude)")
      self?.updateLocationNames(latitude: latitude, longitude: longitude)
    }
    
  }
  
  // 글쓰기뷰에서 탭바 없애기
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  // 글쓰기뷰가 끝나면 탭바 생기기
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  // 네비게이션
  private func reportNavigationItem() {
    navigationItem.title = "새 게시글"
    let rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: nil, action: nil)
    let leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
    
    navigationItem.rightBarButtonItem = rightBarButtonItem
    navigationItem.leftBarButtonItem = leftBarButtonItem
    
    rightBarButtonItem.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        if self.titleText.text?.isEmpty ?? true {
          self.showAlert(title: "경고", message: "제목을 입력해주세요.")
          return
        }
        
        if self.userTextSet.text.isEmpty || self.userTextSet.text == "내용을 입력해주세요.\n\n부적절한 내용이나 불쾌감을 줄 수 있는 내용은 제제를 받을 수 있습니다." {
          self.showAlert(title: "경고", message: "내용을 입력해주세요.")
          return
        }
        
        if self.categoryTouch.text?.isEmpty ?? true {
          self.showAlert(title: "경고", message: "카테고리를 선택해주세요.")
          return
        }
        
        // 모든 조건 통과
        if let title = self.titleText.text,
           let content = self.userTextSet.text,
           let category = self.categoryTouch.text {
          self.onPostAdded?(title, content, self.pickerImage.image ?? UIImage(), category)
        }
        self.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    leftBarButtonItem.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func pictureButtonTap() {
    pictureButton.rx.tap
      .flatMap { [weak self] in
        self?.cameraAlert(title: "사진 선택") ?? Observable.empty()
      }
      .subscribe(onNext: { [weak self] actionType in
        switch actionType {
        case .camera:
          self?.presentImagePickerForCameraOrLibrary(sourceType: .camera)
          self?.presentImagePicker(sourceType: .camera)
        case .library:
          self?.presentImagePickerForCameraOrLibrary(sourceType: .photoLibrary)
          self?.presentImagePicker(sourceType: .photoLibrary)
        case .cancel:
          print("취소 선택됨")
        }
      })
      .disposed(by: disposeBag)
  }
  
  // 사진삭제
  private func deleteButtonTap() {
    deleteButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.pickerImage.image = nil
        self?.pickerImage.isHidden = true
        self?.deleteButton.isHidden = true
      })
      .disposed(by: disposeBag)
  }
  
  
  //MARK: - 카메라
  // 카메라 추가
  private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = sourceType
    imagePicker.allowsEditing = false
    present(imagePicker, animated: true, completion: nil)
  }
  
  // 라이브러리 추가
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let selectedImage = info[.originalImage] as? UIImage {
      pickerImage.image = selectedImage
      pickerImage.isHidden = false
      deleteButton.isHidden = false
    }
    dismiss(animated: true, completion: nil)
  }
  
  // 이미지피커 닫기
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  //Alert Mock case는 model부분에 있음
  private func cameraAlert(title: String, message: String? = nil) -> Observable<ActionType> {
    return Observable.create { observer in
      let alertController = UIAlertController(
        title: title,
        message: "카메라 종류를 선택해주세요.",
        preferredStyle: .actionSheet
      )
      let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
        observer.onNext(.camera)
        observer.onCompleted()
      }
      
      let libraryAction = UIAlertAction(title: "사진첩", style: .default) { _ in
        observer.onNext(.library)
        observer.onCompleted()
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        observer.onNext(.cancel)
        observer.onCompleted()
      }
      
      [cameraAction, libraryAction, cancelAction].forEach(alertController.addAction(_:))
      
      DispatchQueue.main.async {
        self.present(alertController, animated: true, completion: nil)
      }
      
      return Disposables.create {
        alertController.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  private func checkCameraAuthorization(completion: @escaping (Bool) -> Void) {
    let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
    switch cameraAuthStatus {
    case .authorized: // 이미 권한이 있음
      completion(true)
    case .denied, .restricted: // 권한이 거부됨
      completion(false)
    case .notDetermined: // 아직 권한 요청 전
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
          completion(granted)
        }
      }
    @unknown default:
      completion(false)
    }
  }
  
  private func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
    let photoAuthStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthStatus {
    case .authorized, .limited:
      completion(true)
    case .denied, .restricted:
      completion(false)
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { status in
        DispatchQueue.main.async {
          completion(status == .authorized || status == .limited)
        }
      }
    @unknown default:
      completion(false)
    }
  }
  
  private func presentImagePickerForCameraOrLibrary(sourceType: UIImagePickerController.SourceType) {
    switch sourceType {
    case .camera:
      checkCameraAuthorization { granted in
        if granted {
          self.presentImagePicker(sourceType: .camera)
        } else {
          self.showSettingsAlert(message: "카메라 접근 권한이 필요합니다.")
        }
      }
    case .photoLibrary:
      checkPhotoLibraryAuthorization { granted in
        if granted {
          self.presentImagePicker(sourceType: .photoLibrary)
        } else {
          self.showSettingsAlert(message: "사진첩 접근 권한이 필요합니다.")
        }
      }
    default:
      break
    }
  }
  
  private func showSettingsAlert(message: String) {
    let alertController = UIAlertController(
      title: "권한 필요",
      message: message,
      preferredStyle: .alert
    )
    
    let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
      guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
      if UIApplication.shared.canOpenURL(settingsURL) {
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
      }
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    alertController.addAction(settingsAction)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  private func bindCategoryTableView() {
    categoryTableView.delegate = nil
    categoryTableView.dataSource = nil
    
    // 셀을 테이블 뷰에 바인딩
    tableItems
      .bind(to: categoryTableView.rx.items(cellIdentifier: CategoryCell.categoryCell, cellType: CategoryCell.self)) { index, category, cell in
        let viewModel = CategoryViewModel(categoryTitle: Observable.just(category.title))
        cell.configure(with: viewModel)
      }
      .disposed(by: disposeBag)
    
    categoryTableView.rx.modelSelected(Category.self)
      .subscribe(onNext: { [weak self] category in
        guard let self = self else { return }
        self.categoryTouch.text = category.title
        self.categoryTableView.isHidden = true
      })
      .disposed(by: disposeBag)
  }
  
  private func categoryButtonTap() {
    categoryButton.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        
        let isHidden = self.categoryTableView.isHidden
        
        UIView.animate(withDuration: 0.3) {
          self.categoryTableView.isHidden = !isHidden
        }
        
        if !isHidden {
          self.bindCategoryTableView()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func bindCategoryTableViewModel() {
    let viewModel = CategoryTableViewModel()
    viewModel.items
      .bind(to: tableItems)
      .disposed(by: disposeBag)
    viewModel.fetchItem()
  }
  
  // 레이아웃
  private func reportViewLayOut() {
    [
      categoryButton,
      categoryTouch,
      titleName,
      titleText,
      lineView,
      locationeName,
      locationeName1,
      lineView1,
      userTextSet,
      pictureButton,
      pickerImage,
      deleteButton,
      categoryTableView
    ].forEach { view.addSubview($0) }
    
    categoryButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      $0.leading.equalTo(30)
      $0.width.equalTo(80)
      $0.height.equalTo(34)
    }
    
    categoryTouch.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
      $0.centerY.equalTo(categoryButton.snp.centerY)
      $0.centerX.equalToSuperview()
    }
    
    categoryTableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
      $0.leading.equalTo(categoryButton.snp.trailing).offset(10)
      $0.width.equalTo(100)
      $0.height.equalTo(115)
    }
    
    titleName.snp.makeConstraints {
      $0.top.equalTo(categoryButton.snp.bottom).offset(24)
      $0.leading.equalTo(30)
    }
    
    titleText.snp.makeConstraints {
      $0.centerY.equalTo(titleName.snp.centerY)
      $0.leading.equalTo(titleName.snp.trailing).offset(8)
    }
    
    lineView.snp.makeConstraints {
      $0.top.equalTo(titleName.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    locationeName.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(8)
      $0.leading.equalTo(30)
    }
    
    locationeName1.snp.makeConstraints {
      $0.centerY.equalTo(locationeName.snp.centerY)
      $0.leading.equalTo(locationeName.snp.trailing).offset(8)
    }
    
    lineView1.snp.makeConstraints {
      $0.top.equalTo(locationeName.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    userTextSet.snp.makeConstraints {
      $0.top.equalTo(lineView1.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(350)
      $0.height.equalTo(300)
    }
    
    pictureButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
      $0.leading.equalTo(30)
      $0.width.equalTo(80)
      $0.height.equalTo(40)
    }
    
    pickerImage.snp.makeConstraints {
      $0.top.equalTo(userTextSet.snp.bottom).offset(8)
      $0.leading.equalTo(30)
      $0.width.height.equalTo(80)
    }
    
    deleteButton.snp.makeConstraints {
      $0.top.equalTo(pickerImage.snp.top).offset(-10)
      $0.trailing.equalTo(pickerImage.snp.trailing).offset(10)
      $0.width.height.equalTo(30)
    }
  }
}

extension WritingViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    guard textView.textColor == .placeholderText else { return }
    textView.textColor = .label
    textView.text = nil
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "내용을 입력해주세요.\n\n부적절한 내용이나 불쾌감을 줄 수 있는 내용은 제제를 받을 수 있습니다."
      textView.textColor = .placeholderText
    }
  }
}
