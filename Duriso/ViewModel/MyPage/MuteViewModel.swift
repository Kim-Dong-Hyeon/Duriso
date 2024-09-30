//
//  MuteViewModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift

class MuteViewModel {
  
  var editButtonTapped = PublishSubject<Void>()
  var blockedUserNicknames: BehaviorSubject<[String]> = BehaviorSubject(value: [])
  var blockedUserIDs: [String] = []
  var isEditing: BehaviorSubject<Bool> = BehaviorSubject(value: false)
  
  private let disposeBag = DisposeBag()
  
  init() {
    setupBindings()
  }
  
  func deleteBlockedUser(at index: Int) {
    guard var currentNicknames = try? blockedUserNicknames.value(), currentNicknames.indices.contains(index) else {
      print("차단된 사용자 닉네임 배열 또는 인덱스가 유효하지 않습니다.")
      return
    }
    
    guard index >= 0 && index < blockedUserIDs.count else {
      print("blockedUserIDs 배열에서 인덱스가 유효하지 않습니다.")
      return
    }
    
    let userIDToDelete = blockedUserIDs[index]
    
    guard let userUID = Auth.auth().currentUser?.uid else { return }
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(userUID)
    
    userRef.updateData([
      "blockedusers": FieldValue.arrayRemove([userIDToDelete])
    ]) { [weak self] error in
      if let error = error {
        print("Firebase에서 사용자 삭제 실패: \(error.localizedDescription)")
      } else {
        currentNicknames.remove(at: index)
        self?.blockedUserNicknames.onNext(currentNicknames)
        
        self?.blockedUserIDs.remove(at: index)
        print("Firebase에서 차단된 사용자 삭제 성공")
      }
    }
  }
  
  private func setupBindings() {
    editButtonTapped
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let currentEditingState = (try? self.isEditing.value()) ?? false
        self.isEditing.onNext(!currentEditingState)
      })
      .disposed(by: disposeBag)
  }
}
