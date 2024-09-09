//
//  ReportView.swift
//  Duriso
//
//  Created by 신상규 on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
  private let boardViewController = BoardViewController()
  private let boardTableViewCell = BoardTableViewCell()
  private let disposeBag = DisposeBag()
  private let mainTabBarViewModel = MainTabBarViewModel()
  var onPostAdded: ((String, String, UIImage?) -> Void)?
  
  private let categoryButton = UIButton().then {
    $0.setTitle("카테고리", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 20
    $0.titleLabel?.font = CustomFont.Head4.font()
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
  
  private let locationeName1 = UILabel().then {
    $0.text = "사랑시 고백구 행복동"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private let lineView1 = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let userTextSet = UITextView().then {
    $0.text = "내용을 작성해주세요"
    $0.textColor = .placeholderText
  }
  
  private let pictureButton = UIButton().then {
    $0.setTitle("사진추가", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 20
    $0.titleLabel?.font = CustomFont.Head4.font()
  }

  private let deleteButton = UIButton().then {
    $0.setImage(UIImage(systemName: "trash.circle"), for: .normal)
    $0.tintColor = .red
    $0.isHidden = true
  }
  
  
  private let pickerImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    reportNavigationItem()
    reportViewLayOut()
    pictureButtonTap()
    deleteButtonTap()
    userTextSet.delegate = self
    deleteButton.isHidden = true
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
        if let title = self.titleText.text,
           let content = self.userTextSet.text {
          self.onPostAdded?(title, content, self.pickerImage.image)
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
  
  // 사진추가 알럿 (무엇을 보여줄지)
  private func pictureButtonTap() {
    pictureButton.rx.tap
      .flatMap { [weak self] in
        self?.cameraAlert(title: "사진 선택") ?? Observable.empty()
      }
      .subscribe(onNext: { [weak self] actionType in
        switch actionType {
        case .Camera:
          self?.presentImagePicker(sourceType: .camera)
        case .Library:
          self?.presentImagePicker(sourceType: .photoLibrary)
        case .Cancel:
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
        observer.onNext(.Camera)
        observer.onCompleted()
      }
      
      let libraryAction = UIAlertAction(title: "사진첩", style: .default) { _ in
        observer.onNext(.Library)
        observer.onCompleted()
      }
      
      let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
        observer.onNext(.Cancel)
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
  
  // 레이아웃
  private func reportViewLayOut() {
    [
      categoryButton,
      titleName,
      titleText,
      lineView,
      locationeName,
      locationeName1,
      lineView1,
      userTextSet,
      pictureButton,
      pickerImage,
      deleteButton
    ].forEach { view.addSubview($0) }
    
    categoryButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(100)
      $0.leading.equalTo(30)
      $0.width.equalTo(80)
      $0.height.equalTo(40)
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
      $0.centerY.equalTo(locationeName1.snp.centerY)
      $0.leading.equalTo(locationeName1.snp.trailing).offset(8)
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
      $0.bottom.equalToSuperview().offset(-100)
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

extension PostViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    guard textView.textColor == .placeholderText else { return }
    textView.textColor = .label
    textView.text = nil
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "텍스트 입력"
      textView.textColor = .placeholderText
    }
  }
}
