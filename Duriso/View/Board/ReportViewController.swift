//
//  ReportView.swift
//  Duriso
//
//  Created by 신상규 on 9/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ReportViewController: UIViewController {
  
  private let boardViewController = BoardViewController()
  private let boardTableViewCell = BoardTableViewCell()
  
  private let categoryButton: UIButton = {
    let button = UIButton()
    button.setTitle("카테고리", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .lightGray
    button.layer.cornerRadius = 20
    button.titleLabel?.font = CustomFont.Head4.font()
    return button
  }()
  
  private let titleName: UILabel = {
    let label = UILabel()
    label.text = "제목:"
    label.font = CustomFont.Body2.font()
    label.textColor = .black
    return label
  }()
  
  private let titleText: UITextField = {
    let text = UITextField()
    text.text = "제목을 입력해주세요"
    return text
  }()
  
  private let lineView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  private let locationeName: UILabel = {
    let label = UILabel()
    label.text = "현재위치: "
    label.font = CustomFont.Body2.font()
    label.textColor = .black
    return label
  }()
  
  private let locationeName1: UILabel = {
    let label = UILabel()
    label.text = "사랑시 고백구 행복동"
    label.font = CustomFont.Body2.font()
    label.textColor = .black
    return label
  }()
  
  private let lineView1: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  private let userTextSet: UITextView = {
    let text = UITextView()
    text.text = "내용을 작성해주세요"
    return text
  }()
  
  private let pictureButton: UIButton = {
    let button = UIButton()
    button.setTitle("사진추가", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .lightGray
    button.layer.cornerRadius = 20
    button.titleLabel?.font = CustomFont.Head4.font()
    return button
  }()
  
  private let disposeBag = DisposeBag()
  
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
        boardTableViewCell.titleLabel.text = self.titleText.text
        var currentItems = boardViewController.tableItems.value
        currentItems.append("새로운 항목 \(currentItems.count + 1)")
        self.boardViewController.tableItems.accept(currentItems)
        self.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
    
    leftBarButtonItem.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
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
