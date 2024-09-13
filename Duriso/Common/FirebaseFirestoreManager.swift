//
//  FirebaseFirestoreManager.swift
//  Duriso
//
//  Created by 김동현 on 9/12/24.
//

import FirebaseFirestore
import RxSwift

class FirebaseFirestoreManager {
  
  // 싱글톤 인스턴스
  static let shared = FirebaseFirestoreManager()
  
  // Firestore 인스턴스
  private let db = Firestore.firestore()
  
  // 초기화 방지
  private init() {}
  
  // MARK: - Create (문서 생성)
  
  func createDocument(collection: String, data: [String: Any]) -> Observable<Void> {
    return Observable.create { observer in
      // 지정된 컬렉션에 문서를 추가
      self.db.collection(collection).addDocument(data: data) { error in
        if let error = error {
          observer.onError(error) // 에러가 발생하면 observer에 에러 전달
        } else {
          observer.onNext(()) // 성공적으로 추가되면 빈 값 전달
          observer.onCompleted() // 완료 신호
        }
      }
      return Disposables.create()
    }
  }
  
  // MARK: - Read (문서 읽기)
  
  func getDocument(collection: String, documentID: String) -> Observable<[String: Any]> {
    return Observable.create { observer in
      let docRef = self.db.collection(collection).document(documentID)
      
      docRef.getDocument { (document, error) in
        if let document = document, document.exists {
          observer.onNext(document.data() ?? [:]) // 성공적으로 데이터를 가져오면 observer에 전달
          observer.onCompleted()
        } else {
          observer.onError(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "문서가 존재하지 않음"])) // 에러 처리
        }
      }
      return Disposables.create()
    }
  }
  
  // MARK: - Update (문서 업데이트)
  
  func updateDocument(collection: String, documentID: String, data: [String: Any]) -> Observable<Void> {
    return Observable.create { observer in
      let docRef = self.db.collection(collection).document(documentID)
      
      docRef.updateData(data) { error in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  // MARK: - Delete (문서 삭제)
  
  func deleteDocument(collection: String, documentID: String) -> Observable<Void> {
    return Observable.create { observer in
      let docRef = self.db.collection(collection).document(documentID)
      
      docRef.delete { error in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}
