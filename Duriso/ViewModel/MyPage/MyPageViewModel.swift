//
//  MyPageViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import FirebaseFirestore
import FirebaseAuth
import RxSwift

class MyPageViewModel {
  let items: Observable<[MyPageModel]>
  
  let nickname: BehaviorSubject<String> = BehaviorSubject(value: "")
  let postcount: BehaviorSubject<Int> = BehaviorSubject(value: 0)
  
  private let firestore = Firestore.firestore()
  private let disposeBag = DisposeBag()
  
  init() {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    //앱의 버전을 앱의 설정파일에서 불러옴 (빌드나 배포에 따라 버전 정보가 자동 업데이트)
    
    items = Observable.just([
      MyPageModel(title: "푸시알림", type: .toggle, selected: false),
      MyPageModel(title: "공지사항", type: .disclosure, selected: true),
      MyPageModel(title: "법적고지", type: .disclosure, selected: true),
      MyPageModel(title: "저작권 표시", type: .disclosure, selected: true),
      MyPageModel(title: "오프라인 정보 다운로드", type: .disclosure, selected: true),
      MyPageModel(title: "버전 정보", type: .version(version), selected: false),
      MyPageModel(title: "로그아웃", type: .disclosure, selected: true),
      MyPageModel(title: "회원탈퇴", type: .disclosure, selected: true)
    ])
    
    fetchUserData()
  }
  
  private func fetchUserData() {
    guard let user = Auth.auth().currentUser else { return }
    
    let safeEmail = user.email?.replacingOccurrences(of: ".", with: "-") ?? ""
    firestore.collection("users").document(safeEmail).getDocument { [weak self] (document, error) in
      guard let self = self else { return }
      if let document = document, document.exists {
        let data = document.data()
        let nickname = data?["nickname"] as? String ?? ""
        let postcount = data?["postcount"] as? Int ?? 0
        
        // 닉네임과 게시글 수 업데이트
        self.nickname.onNext(nickname)
        self.postcount.onNext(postcount)
      } else {
        print("사용자 데이터를 불러오는 데 실패했습니다: \(error?.localizedDescription ?? "")")
      }
    }
  }
}
