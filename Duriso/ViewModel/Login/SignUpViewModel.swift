//
//  SingUpViewModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/5/24.
//

import Foundation

import FirebaseAuth
import FirebaseDatabase
import RxCocoa
import RxSwift

class SignUpViewModel {
  
  let emailText = BehaviorRelay<String>(value: "")
  let passwordText = BehaviorRelay<String>(value: "")
  let nicknameText = BehaviorRelay<String>(value: "")
  
  let createUserResult = PublishRelay<Result<AuthDataResult, Error>>()
  
  private let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
  private let passwordPattern = "^.*(?=^.{8,16}$)(?=.*\\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$"
  private let nicknamePattern = "^[a-zA-Z0-9가-힣]{3,10}$"
  
  private let disposeBag = DisposeBag()
  private let db = Database.database().reference()
  
  init() {
    setupBindings()
  }
  
  private func setupBindings() {
    let validEmail = createValidationObservable(for: emailText, pattern: emailPattern)
    let validPassword = createValidationObservable(for: passwordText, pattern: passwordPattern)
    let validNickname = createValidationObservable(for: nicknameText, pattern: nicknamePattern)
    
    let validForm = Observable.combineLatest(validEmail, validPassword, validNickname) {
      emailValid, passwordValid, nicknameValid in
      return emailValid && passwordValid && nicknameValid
    }
  }
  
  private func createValidationObservable(for text: BehaviorRelay<String>, pattern: String) -> Observable<Bool> {
    return text
      .map { input in
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: input)
      }
  }
  
  private func nicknameCheckObservable() -> Observable<Bool> {
    let nickname = nicknameText.value
    return Observable<Bool>.create { [weak self] observer in
      self?.db.child("users").queryOrdered(byChild: "nickname").queryEqual(toValue: nickname)
        .observeSingleEvent(of: .value) { snapshot in
          if snapshot.exists() {
            observer.onNext(false)  // 닉네임이 이미 존재하는 경우
          } else {
            observer.onNext(true)   // 닉네임이 사용 가능한 경우
          }
          observer.onCompleted()
        } withCancel: { error in
          observer.onError(error)
        }
      return Disposables.create()
    }
  }
  
  private func createFirebaseUser(email: String, password: String, nickname: String) -> Observable<AuthDataResult> {
    return Observable<AuthDataResult>.create { [weak self] observer in
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
        if let error = error {
          observer.onError(error)
        } else if let result = result {
          self?.saveUserData(uid: result.user.uid, nickname: nickname)
          observer.onNext(result)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  func createUser() {
    let email = emailText.value
    let password = passwordText.value
    let nickname = nicknameText.value
    
    nicknameCheckObservable()
      .flatMap { [weak self] isAvailable -> Observable<AuthDataResult> in
        guard let self = self else { return Observable.empty() }
        if isAvailable {
          return self.createFirebaseUser(email: email, password: password, nickname: nickname)
        } else {
          return Observable.error(NSError(domain: "", code: 1001, userInfo: nil))  // 닉네임 중복 에러 발생
        }
      }
      .subscribe(onNext: { [weak self] result in
        self?.createUserResult.accept(.success(result))
      }, onError: { [weak self] error in
        self?.createUserResult.accept(.failure(error))
      })
      .disposed(by: disposeBag)
  }
  
  private func saveUserData(uid: String, nickname: String) {
    let databaseRef = Database.database().reference(withPath: "users/\(uid)")
    
    let userData: [String: String] = [
      "nickname": nickname,
      "email": emailText.value
    ]
    
    databaseRef.setValue(userData) { error, _ in
      if let error = error {
        print("계정 생성 실패: \(error.localizedDescription)")
      } else {
        print("계정 생성 완료")
      }
    }
  }
}
