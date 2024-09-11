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
  var postImage: UIImage?
  var postTitleTop: String?
  
  private var postingTitleText = UILabel().then {
    $0.text = "너 제목해"
    $0.font = CustomFont.Head2.font()
    $0.textColor = .black
  }
  
  private let postingLineView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let postingLineView1 = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let postingLineView2 = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private let postingLocationeName1 = UILabel().then {
    $0.text = "사랑시 고백구 행복동"
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
  
  private var postingUserTextLabel = UILabel().then {
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private var postingImage = UIImageView().then {
    $0.frame = .init(x: 0, y: 0, width: 300, height: 300)
  }
  
  private let ripotButton = UIButton().then {
    $0.setTitle("🚨신고하기", for: .normal)
    $0.backgroundColor = .clear
    $0.setTitleColor(.red, for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
  }
  
  private let changeButton = UIButton().then {
    $0.setTitle("수정하기", for: .normal)
    $0.backgroundColor = .clear
    $0.setTitleColor(.lightGray, for: .normal)
    $0.titleLabel?.font = CustomFont.Body3.font()
  }
  
  private let removalButton = UIButton().then {
    $0.setTitle("삭제하기", for: .normal)
    $0.backgroundColor = .clear
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
    
    postingTitleText.text = postTitle
    postingUserTextLabel.text = postContent
    postingImage.image = postImage
    ripotAlerts()
    optionalLayout()
    self.title = postTitleTop
  }
  
  private func ripotAlerts() {
    ripotButton.rx.tap
      .bind { [weak self] in
        self?.ripotAlert()
      }
      .disposed(by: disposeBag)
  }
  
  private func ripotAlert() {
    let ripotAlert = UIAlertController(
      title: "신고하기",
      message: "해당 이용자를 신고 하시겠습니까?",
      preferredStyle: .alert
    )
    
    ripotAlert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
    ripotAlert.addAction(UIAlertAction(title: "신고하기", style: .cancel, handler: { _ in
      self.ripotAlert2()
    }))
    present(ripotAlert, animated: true, completion: nil)
  }
  
  private func ripotAlert2() {
    let ripotAlert = UIAlertController(
      title: "신고",
      message: "신고가 완료되었습니다.",
      preferredStyle: .alert
    )
    
    ripotAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
      //신고 되었을때의 행동
    }))
    present(ripotAlert, animated: true, completion: nil)
  }
  
  private func optionalLayout() {
    if let image = postImage {
      postingImage.image = image
      postingViewLayout()
    } else {
      postingViewLayout2()
    }
  }
  
  private func postingViewLayout() {
    
    [
      postingTitleText,
      postingLineView,
      postingLocationeName1,
      postingLineView1,
      postingUserTextLabel,
      postingImage,
      postingStackView,
      bottomStackView,
      postingLineView2
    ].forEach { view.addSubview($0) }
    
    [
      postingTimeText,
      postingTimeLabel
    ].forEach { postingStackView.addArrangedSubview($0) }
    
    // 스택뷰 안에 틈을 주기위해 뷰 설정
    let spacerView = UIView()
    
    [
      ripotButton, spacerView, changeButton, removalButton
    ].forEach { bottomStackView.addArrangedSubview($0) }
    
    // 스택뷰 안에 버튼의 크기 설정
    ripotButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.width.equalTo(100)
    }
    
    changeButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.width.equalTo(80)
    }
    
    removalButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.width.equalTo(80)
    }
    
    spacerView.snp.makeConstraints {
      $0.width.greaterThanOrEqualTo(50)
    }
    
    postingTitleText.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    postingLineView.snp.makeConstraints {
      $0.top.equalTo(postingTitleText.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    postingLocationeName1.snp.makeConstraints {
      $0.top.equalTo(postingLineView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    postingStackView.snp.makeConstraints {
      $0.top.equalTo(postingLocationeName1.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    postingLineView1.snp.makeConstraints {
      $0.top.equalTo(postingStackView.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    postingImage.snp.makeConstraints {
      $0.top.equalTo(postingLineView1.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(200)
      $0.width.equalTo(350)
    }
    
    postingUserTextLabel.snp.makeConstraints {
      $0.top.equalTo(postingImage.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(350)
      $0.height.equalTo(200)
    }
    
    postingLineView2.snp.makeConstraints {
      $0.top.equalTo(postingUserTextLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    bottomStackView.snp.makeConstraints {
      $0.top.equalTo(postingLineView2.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(350)
      $0.height.equalTo(50)
    }
  }
  
  private func postingViewLayout2() {
    
    [
      postingTitleText,
      postingLineView,
      postingLocationeName1,
      postingLineView1,
      postingUserTextLabel,
      postingStackView,
      bottomStackView,
      postingLineView2
    ].forEach { view.addSubview($0) }
    
    [
      postingTimeText,
      postingTimeLabel
    ].forEach { postingStackView.addArrangedSubview($0) }
    
    let spacerView = UIView()
    
    [
      ripotButton, spacerView, changeButton, removalButton
    ].forEach { bottomStackView.addArrangedSubview($0) }
    
    ripotButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.width.equalTo(100)
    }
    
    changeButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.width.equalTo(80)
    }
    
    removalButton.snp.makeConstraints {
      $0.height.equalTo(50)
      $0.width.equalTo(80)
    }
    
    spacerView.snp.makeConstraints {
      $0.width.greaterThanOrEqualTo(30)
    }
    
    postingTitleText.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    postingLineView.snp.makeConstraints {
      $0.top.equalTo(postingTitleText.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    postingLocationeName1.snp.makeConstraints {
      $0.top.equalTo(postingLineView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    postingStackView.snp.makeConstraints {
      $0.top.equalTo(postingLocationeName1.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    
    postingLineView1.snp.makeConstraints {
      $0.top.equalTo(postingStackView.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    
    postingUserTextLabel.snp.makeConstraints {
      $0.top.equalTo(postingLineView1.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(350)
      $0.height.equalTo(200)
    }
    
    postingLineView2.snp.makeConstraints {
      $0.top.equalTo(postingUserTextLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(1)
      $0.width.equalTo(350)
    }
    
    bottomStackView.snp.makeConstraints {
      $0.top.equalTo(postingLineView2.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(350)
      $0.height.equalTo(50)
    }
  }
}
