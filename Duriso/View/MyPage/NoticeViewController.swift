//
//  NoticeViewController.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/2/24.
//

import UIKit

import SnapKit

class NoticeViewController: UIViewController {
  
  private let noticeTableView = UITableView()
  
  private let noneNoticeLabel = UILabel().then {
    $0.text = "공지사항 없음"
    $0.font = CustomFont.Deco4.font()
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    ConfigureUI()
  }
  
  private func ConfigureUI() {
    [
      noticeTableView,
      noneNoticeLabel
    ].forEach{ view.addSubview($0) }
    
    noticeTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    
    // 테이블 뷰에 데이터가 있으면 라벨 가리고 테이블 뷰 표시/ 데이터가 없으면 테이블 뷰 가리고 라벨 표시
    //    func showData() {
    //      if data.isEmpty {
    //        noneNoticeLabel.isHidden = false
    //        noticeTableView.isHidden = true
    //      } esle {
    //        noneNoticeLabel.isHidden = true
    //        noticeTableView.isHidden = false
    //      }
    //    }
  }
  
  
}
