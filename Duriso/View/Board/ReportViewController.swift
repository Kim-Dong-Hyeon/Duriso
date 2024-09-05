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

class ReportViewController: UIViewController {
  
  private let boardViewController = BoardViewController()
  private let boardTableViewCell = BoardTableViewCell()
  private let disposeBag = DisposeBag()
  var onPostAdded: ((String, String) -> Void)?
  
  private let categoryButton = UIButton().then {
    $0.setTitle("카테고리", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 20
    $0.titleLabel?.font = CustomFont.Head4.font()
  }
  
  private let titleName = UILabel().then {
    $0.text = "제목:"
    $0.font = CustomFont.Body2.font()
    $0.textColor = .black
  }
  
  private let titleText = UITextField().then {
    $0.text = "제목을 입력해주세요"
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
  }
  
  private let pictureButton = UIButton().then {
    $0.setTitle("사진추가", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.backgroundColor = .lightGray
    $0.layer.cornerRadius = 20
    $0.titleLabel?.font = CustomFont.Head4.font()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    reportNavigationItem()
    reportViewLayOut()
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
        if let title = self.titleText.text, let content = self.userTextSet.text {
          self.onPostAdded?(title, content)
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
      pictureButton
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
      $0.bottom.equalToSuperview().offset(-100)
      $0.leading.equalTo(30)
      $0.width.equalTo(80)
      $0.height.equalTo(40)
    }
  }
}
