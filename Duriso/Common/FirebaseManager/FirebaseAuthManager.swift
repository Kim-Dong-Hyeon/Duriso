//
//  FirebaseAuthManager.swift
//  Duriso
//
//  Created by 김동현 on 10/10/24.
//

import FirebaseAuth
import RxSwift

class FirebaseAuthManager {
  static let shared = FirebaseAuthManager()
  private init() {}
  
  func signIn(withEmail email: String, password: String) -> Observable<AuthDataResult> {
    return Observable.create { observer in
      Auth.auth().signIn(withEmail: email, password: password) { result, error in
        if let error = error {
          observer.onError(error)
        } else if let result = result {
          observer.onNext(result)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func createUser(withEmail email: String, password: String) -> Observable<AuthDataResult> {
    return Observable.create { observer in
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          observer.onError(error)
        } else if let result = result {
          observer.onNext(result)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func signOut() -> Observable<Void> {
    return Observable.create { observer in
      do {
        try Auth.auth().signOut()
        observer.onNext(())
        observer.onCompleted()
      } catch let error {
        observer.onError(error)
      }
      return Disposables.create()
    }
  }
  
  func currentUser() -> FirebaseAuth.User? {
    return Auth.auth().currentUser
  }
}
