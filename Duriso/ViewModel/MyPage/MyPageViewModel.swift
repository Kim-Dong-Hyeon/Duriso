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
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    //앱의 버전을 앱의 설정파일에서 불러옴 (빌드나 배포에 따라 버전 정보가 자동 업데이트)
    
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
