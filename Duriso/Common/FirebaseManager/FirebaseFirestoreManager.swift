//
//  FirebaseFirestoreManager.swift
//  Duriso
//
//  Created by 김동현 on 9/12/24.
//

import FirebaseFirestore
import FirebaseStorage
import RxSwift

class FirebaseFirestoreManager {
  
  // 싱글톤 인스턴스
  static let shared = FirebaseFirestoreManager()
  
  // Firestore 인스턴스
  private let firestore = Firestore.firestore()
  
  // 초기화 방지
  private init() {}
  
  // MARK: - Create (문서 생성)
  
  func createDocument(collection: String, data: [String: Any]) -> Observable<Void> {
    return Observable.create { observer in
      // 지정된 컬렉션에 문서를 추가
      self.firestore.collection(collection).addDocument(data: data) { error in
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
      let docRef = self.firestore.collection(collection).document(documentID)
      
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
      let docRef = self.firestore.collection(collection).document(documentID)
      
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
      let docRef = self.firestore.collection(collection).document(documentID)
      
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
  
  func fetchUserData(uid: String) -> Observable<[String: Any]> {
    return Observable.create { observer in
      self.firestore.collection("users").document(uid).getDocument { document, error in
        if let error = error {
          observer.onError(error)
        } else if let document = document, document.exists {
          observer.onNext(document.data() ?? [:])
          observer.onCompleted()
        } else {
          observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"]))
        }
      }
      return Disposables.create()
    }
  }
  
  // Firestore에 사용자 정보 저장
  func saveUserData(uid: String, data: [String: Any]) -> Observable<Void> {
    return Observable.create { observer in
      self.firestore.collection("users").document(uid).setData(data) { error in
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
  
  // Firestore에서 사용자 데이터 삭제
  func deleteUserData(uid: String) -> Observable<Void> {
    return Observable.create { observer in
      print("FirebaseFirestoreManager: 사용자 데이터 삭제 시작")
      self.firestore.collection("users").document(uid).delete { error in
        if let error = error {
          print("FirebaseFirestoreManager: 사용자 데이터 삭제 실패 - \(error.localizedDescription)")
          observer.onError(error)
        } else {
          print("FirebaseFirestoreManager: 사용자 데이터 삭제 성공")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  // MARK: - 이미지 업로드
  
  func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
    guard let imageData = image.jpegData(compressionQuality: 0.75) else {
      completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 데이터 변환 실패"])))
      return
    }
    
    storageRef.putData(imageData, metadata: nil) { metadata, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      storageRef.downloadURL { url, error in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(url?.absoluteString ?? ""))
        }
      }
    }
  }
}
