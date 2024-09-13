//
//  PostService.swift
//  Duriso
//
//  Created by 신상규 on 9/13/24.
//

import UIKit

import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import RxSwift


class PostService {
  
  // Firestore 인스턴스
  private let db = Firestore.firestore()
  
  // MARK: - 게시물 가져오기
  
  func fetchPosts() -> Observable<[Posts]> {
    return Observable.create { observer in
      self.db.collection("posts")
        .getDocuments { (snapshot, error) in
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
  
  // MARK: - 이미지 업로드
  
  func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
    guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
    
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
