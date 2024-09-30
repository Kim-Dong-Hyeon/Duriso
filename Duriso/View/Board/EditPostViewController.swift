//
//  PostChangeViewController.swift
//  Duriso
//
//  Created by 신상규 on 9/16/24.
//

import UIKit

import FirebaseFirestore
import FirebaseStorage
import RxCocoa
import RxSwift
import SnapKit

class EditPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let disposeBag = DisposeBag()
  var onPostUpdated: ((String, String, UIImage?, String) -> Void)?
  private let tableItems = BehaviorRelay<[Category]>(value: [])
  private let categoryViewModel = CategoryTableViewModel()
  
  var currentPost: Posts?
  
  private let categoryButton = UIButton().then {
    $0.setTitle("카테고리", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .CLightBlue
    $0.layer.cornerRadius = 20
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
  
  private let userTextSet = UITextView().then {
    $0.text = "내용을 작성해주세요"
    $0.textColor = .CBlack
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
    $0.setImage(UIImage(systemName: "trash.circle"), for: .normal)
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
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    fetchCategories()
    configureNavigationBar()
    setupLayout()
    setupBindings()
    setupUI()
  }
  
  private func configureNavigationBar() {
    navigationItem.title = "게시글 수정"
    let rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(didTapUpdateButton))
    let leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
    
    navigationItem.rightBarButtonItem = rightBarButtonItem
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  @objc private func didTapUpdateButton() {
    guard let title = titleText.text,
          let content = userTextSet.text,
          let category = categoryTouch.text,
          let post = currentPost else {
      return
    }
    
    if let image = pickerImage.image {
      FirebaseFirestoreManager.shared.uploadImage(image) { [weak self] result in
        switch result {
        case .success(let imageUrl):
          self?.updatePost(title: title, content: content, category: category, imageUrl: imageUrl)
        case .failure(let error):
          print("Image upload failed: \(error.localizedDescription)")
        }
      }
    } else {
      updatePost(title: title, content: content, category: category, imageUrl: nil)
    }
  }
  
  private func updatePost(title: String, content: String, category: String, imageUrl: String?) {
    guard let post = currentPost else { return }
    
    var updatedPost: [String: Any] = [
      "title": title,
      "contents": content,
      "category": category
    ]
    
    if let imageUrl = imageUrl {
      updatedPost["imageUrl"] = imageUrl
    }
    
    FirebaseFirestoreManager.shared.updateDocument(collection: "posts", documentID: post.postid, data: updatedPost)
      .subscribe(onNext: { [weak self] in
        self?.onPostUpdated?(title, content, self?.pickerImage.image, category)
        self?.navigationController?.popViewController(animated: true)
      }, onError: { error in
        print("Error updating document: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
  }
  
  @objc private func didTapCancelButton() {
    navigationController?.popViewController(animated: true)
  }
  
  private func setupLayout() {
    [
      categoryButton,
      categoryTouch,
      titleName,
      titleText,
      lineView,
      userTextSet,
      pictureButton,
      pickerImage,
      deleteButton,
      categoryTableView
    ].forEach { view.addSubview($0) }
    
    categoryButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(100)
      $0.leading.equalTo(30)
      $0.width.equalTo(80)
      $0.height.equalTo(40)
    }
    
    categoryTouch.snp.makeConstraints {
      $0.top.equalToSuperview().offset(100)
      $0.centerY.equalTo(categoryButton.snp.centerY)
      $0.centerX.equalToSuperview()
    }
    
    categoryTableView.snp.makeConstraints {
      $0.leading.equalTo(categoryButton.snp.trailing).offset(10)
      $0.top.equalToSuperview().offset(100)
      $0.width.equalTo(200)
      $0.height.equalTo(150)
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
    
    userTextSet.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(16)
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
  
  private func setupBindings() {
    pictureButton.rx.tap
      .flatMap { [weak self] in
        self?.cameraAlert(title: "사진 선택") ?? Observable.empty()
      }
      .subscribe(onNext: { [weak self] actionType in
        switch actionType {
        case .camera:
          self?.presentImagePicker(sourceType: .camera)
        case .library:
          self?.presentImagePicker(sourceType: .photoLibrary)
        case .cancel:
          print("취소 선택됨")
        }
      })
      .disposed(by: disposeBag)
    
    deleteButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.pickerImage.image = nil
        self?.pickerImage.isHidden = true
        self?.deleteButton.isHidden = true
      })
      .disposed(by: disposeBag)
    
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
  
  private func setupUI() {
    if let post = currentPost {
      titleText.text = post.title
      userTextSet.text = post.contents
      categoryTouch.text = post.category
      
      if let imageUrlString = post.imageUrl,
         let imageUrl = URL(string: imageUrlString) {
        pickerImage.isHidden = false
        deleteButton.isHidden = false
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
          guard let self = self, let data = data, let image = UIImage(data: data) else { return }
          DispatchQueue.main.async {
            self.pickerImage.image = image
          }
        }.resume()
      } else {
        pickerImage.isHidden = true
        deleteButton.isHidden = true
      }
    }
    bindCategoryTableView()
  }
  
  private func bindCategoryTableView() {
    categoryTableView.delegate = nil
    categoryTableView.dataSource = nil
    
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
  
  private func fetchCategories() {
    categoryViewModel.items
      .bind(to: tableItems)
      .disposed(by: disposeBag)
    
    categoryViewModel.fetchItem()
  }
  
  private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = sourceType
    present(imagePickerController, animated: true, completion: nil)
  }
  
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
  
  // 이미지 선택 후 호출되는 메서드
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      pickerImage.image = image
      pickerImage.isHidden = false
      deleteButton.isHidden = false
    }
    dismiss(animated: true, completion: nil)
  }
  
  // 이미지 선택 취소 후 호출되는 메서드
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
