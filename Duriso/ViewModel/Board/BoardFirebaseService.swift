//
//  BoardFirebaseStorage.swift
//  Duriso
//
//  Created by 신상규 on 9/12/24.
//

import UIKit

import RxSwift
import FirebaseFirestore
import FirebaseStorage

class BoardFirebaseService {
  
  private let db = Firestore.firestore()
  
  // MARK: - 게시물 데이터 읽어오기
  
  func fetchPosts() -> Observable<[Posts]> {
    return Observable.create { observer in
      self.db.collection("posts")
        .getDocuments { snapshot, error in
          if let error = error {
            observer.onError(error)
            return
          }
          
          guard let documents = snapshot?.documents else {
            observer.onNext([])
            return
          }
          
          let posts = documents.compactMap { doc -> Posts? in
            try? doc.data(as: Posts.self)
          }
          observer.onNext(posts)
          observer.onCompleted()
        }
      return Disposables.create()
    }
  }
  
  // MARK: - 게시물 생성
  
  func createPost(_ post: Posts, completion: @escaping (Result<Void, Error>) -> Void) {
    do {
      try db.collection("posts").document(post.postid).setData(from: post) { error in
        if let error = error {
          completion(.failure(error))
        } else {
          completion(.success(()))
        }
      }
    } catch {
      completion(.failure(error))
    }
  }
}
