//
//  SingUpViewModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/5/24.
//

import FirebaseAuth
import FirebaseFirestore
import RxCocoa
import RxSwift

class SignUpViewModel {
  
  let emailText = BehaviorRelay<String>(value: "")
  let passwordText = BehaviorRelay<String>(value: "")
  let checkPasswordText = BehaviorRelay<String>(value: "")
  let nicknameText = BehaviorRelay<String>(value: "")
  
  let createUserResult = PublishRelay<Result<AuthDataResult, Error>>()
  
  private let disposeBag = DisposeBag()
  private let firestore = Firestore.firestore()
  
  func performUserCreation() -> Observable<AuthDataResult> {
    let email = emailText.value
    let password = passwordText.value
    let nickname = nicknameText.value
    
    guard password == checkPasswordText.value else {
      return Observable.error(NSError(domain: "", code: 1002, userInfo: nil))
    }
    
    return nicknameCheckObservable()
      .flatMap { [weak self] isAvailable -> Observable<AuthDataResult> in
        guard let self = self else { return Observable.empty() }
        if isAvailable {
          return self.createFirebaseUser(email: email, password: password, nickname: nickname)
        } else {
          return Observable.error(NSError(domain: "", code: 1001, userInfo: nil))  // 닉네임 중복 에러
        }
      }
  }
  
  private func nicknameCheckObservable() -> Observable<Bool> {
    return Observable.create { [weak self] observer in
      guard let self = self else {
        observer.onCompleted()
        return Disposables.create()
      }
      
      let nickname = self.nicknameText.value
      
      guard !nickname.isEmpty else {
        observer.onNext(false)
        observer.onCompleted()
        return Disposables.create()
      }
      
      self.firestore.collection("users")
        .whereField("nickname", isEqualTo: nickname)
        .getDocuments { snapshot, error in
          if let error = error {
            observer.onError(error)
          } else if let snapshot = snapshot, !snapshot.isEmpty {
            observer.onNext(false)
          } else {
            observer.onNext(true)
          }
          observer.onCompleted()
        }
      
      return Disposables.create()
    }
  }
  
  private func createFirebaseUser(email: String, password: String, nickname: String) -> Observable<AuthDataResult> {
    return Observable.create { observer in
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          observer.onError(error)
        } else if let result = result {
          let userData: [String: Any] = [
            "uuid": result.user.uid,
            "nickname": nickname,
            "email": email,
            "postcount": 0,
            "reportedpostcount": 0,
            "createdAt": Timestamp(date: Date())
          ]
          
          FirebaseFirestoreManager.shared.saveUserData(uid: result.user.uid, data: userData)
            .subscribe(onNext: {
              observer.onNext(result)
              observer.onCompleted()
            }, onError: { saveError in
              observer.onError(saveError)
            })
            .disposed(by: self.disposeBag)
        }
      }
      return Disposables.create()
    }
  }
  
  private func isValidEmail(_ email: String) -> Bool {
    let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
    let pred = NSPredicate(format: "SELF MATCHES %@", emailPattern)
    return pred.evaluate(with: email)
  }
  
  private func isValidPassword(_ password: String) -> Bool {
    let passwordPattern = "^.*(?=^.{8,16}$)(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$"
    let pred = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
    return pred.evaluate(with: password)
  }
  
  private func isValidNickname(_ nickname: String) -> Bool {
    let nicknamePattern = "^[a-zA-Z0-9가-힣]{3,10}$"
    let pred = NSPredicate(format: "SELF MATCHES %@", nicknamePattern)
    return pred.evaluate(with: nickname)
  }
  
  func isValidEmailObservable() -> Observable<Bool> {
    return emailText.asObservable()
      .map { [weak self] email in
        return self?.isValidEmail(email) ?? false
      }
  }
  
  func isValidPasswordObservable() -> Observable<Bool> {
    return passwordText.asObservable()
      .map { [weak self] password in
        return self?.isValidPassword(password) ?? false
      }
  }
  
  func isValidNicknameObservable() -> Observable<Bool> {
    return nicknameText.asObservable()
      .map { [weak self] nickname in
        return self?.isValidNickname(nickname) ?? false
      }
  }
  
  func isPasswordMatchObservable() -> Observable<Bool> {
    return Observable.combineLatest(passwordText.asObservable(), checkPasswordText.asObservable())
      .map { $0 == $1 }
  }
}
