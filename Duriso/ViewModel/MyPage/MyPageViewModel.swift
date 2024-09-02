//
//  MyPageViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation
import RxSwift

class MyPageViewModel {
  let items: Observable<[MyPageModel]>
  
  init() {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as?
    String ?? "Unknown" //앱의 버전을 앱의 설정파일에서 불러옴 (빌드나 배포에 따라 버전 정보가 자동 업데이트)
    
    items = Observable.just([
      MyPageModel(title: "푸시알림", type: .toggle, selected: false),
      MyPageModel(title: "공지사항", type: .disclosure, selected: true),
      MyPageModel(title: "법적고지", type: .disclosure, selected: true),
      MyPageModel(title: "오프라인 정보 다운로드", type: .disclosure, selected: true),
      MyPageModel(title: "버전 정보", type: .version(version), selected: false),
      MyPageModel(title: "로그아웃", type: .disclosure, selected: true),
      MyPageModel(title: "회원탈퇴", type: .disclosure, selected: true)
    ])
  }
}


//func handleCellSelection(for row: Int, viewController: UIViewController) {
//  let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//  
//  switch row {
//  case 5:
//    alert.title = "로그아웃"
//    alert.message = "로그아웃 하시겠습니까?"
//    let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
//    let okAction = UIAlertAction(title: "예", style: .destructive) { _ in
//      self.showLogoutSuccessAlert(from: viewController)
//    }
//    alert.addAction(cancelAction)
//    alert.addAction(okAction)
//    
//  case 6:
//    alert.title = "탈퇴하기"
//    alert.message = "탈퇴하시겠습니까?"
//    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//    let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive) { _ in
//      self.showWithdrawalSuccessAlert(from: viewController)
//    }
//    alert.addAction(cancelAction)
//    alert.addAction(confirmAction)
//  default:
//    return
//  }
//  viewController.present(alert, animated: true, completion: nil)
//}
//
//private func showLogoutSuccessAlert(from viewController: UIViewController) {
//  let successAlert = UIAlertController(title: "로그아웃", message: "로그아웃되었습니다.", preferredStyle: .alert)
//  let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//  successAlert.addAction(okAction)
//  viewController.present(successAlert, animated: true, completion: nil)
//}
//
//private func showWithdrawalSuccessAlert(from viewController: UIViewController) {
//  let successAlert = UIAlertController(title: "탈퇴", message: "회원 탈퇴가 완료되었습니다.", preferredStyle: .alert)
//  let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
//  successAlert.addAction(okAction)
//  viewController.present(successAlert, animated: true, completion: nil)
//}
//}
