//
//  NoticeViewModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/15/24.
//

import FirebaseFirestore
import RxCocoa
import RxSwift

class NoticeViewModel {
  let notices = BehaviorRelay<[NoticeModel]>(value: [])
  private let disposeBag = DisposeBag()
  
  init() {
    fetchNotices()
  }
  
  private func fetchNotices() {
    Firestore.firestore().collection("notice").getDocuments { snapshot, error in
      guard let documents = snapshot?.documents else {
        print("Error fetching notices: \(error?.localizedDescription ?? "")")
        return
      }
      
      let fetchedNotices = documents.compactMap { NoticeModel(dictionary: $0.data()) }
      self.notices.accept(fetchedNotices)
    }
  }
}
