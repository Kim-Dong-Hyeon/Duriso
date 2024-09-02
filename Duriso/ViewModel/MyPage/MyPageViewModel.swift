//
//  MyPageViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

class MyPageViewModel {
  
  func configureCell(_ cell: MyPageTableViewCell, for row: Int) {
    cell.configure(for: row)
    
    if row == 4 {
      cell.setVersionText("1.0.0") //테스트용 버전
    }
  }
  
  func handleCellSelection(for row: Int, viewController: UIViewController) {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    switch row {
    case 5:
      alert.title = "로그아웃"
      alert.message = "로그아웃 하시겠습니까?"
      let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
      let okAction = UIAlertAction(title: "예", style: .destructive) { _ in
        self.showLogoutSuccessAlert(from: viewController)
      }
      alert.addAction(cancelAction)
      alert.addAction(okAction)
      
    case 6:
      alert.title = "탈퇴하기"
      alert.message = "탈퇴하시겠습니까?"
      let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
      let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
        self.showWithdrawalSuccessAlert(from: viewController)
      }
      alert.addAction(cancelAction)
      alert.addAction(confirmAction)
    default:
      return
    }
    viewController.present(alert, animated: true, completion: nil)
  }
  
  private func showLogoutSuccessAlert(from viewController: UIViewController) {
    let successAlert = UIAlertController(title: "로그아웃", message: "로그아웃되었습니다.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    successAlert.addAction(okAction)
    viewController.present(successAlert, animated: true, completion: nil)
  }
  
  private func showWithdrawalSuccessAlert(from viewController: UIViewController) {
    let successAlert = UIAlertController(title: "탈퇴", message: "회원 탈퇴가 완료되었습니다.", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    successAlert.addAction(okAction)
    viewController.present(successAlert, animated: true, completion: nil)
  }
}
