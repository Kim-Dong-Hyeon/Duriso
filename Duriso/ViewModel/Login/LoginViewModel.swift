//
//  LoginViewModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 8/28/24.
//

import FirebaseAuth

import RxCocoa
import RxSwift

class LoginViewModel {
  
  let email = PublishSubject<String>()
  let password = PublishSubject<String>()
  let loginTap = PublishSubject<Void>()
  
  let loginSuccess = PublishSubject<Void>()
  let loginError = PublishSubject<String>()
  
  private let disposeBag = DisposeBag()
  
  init() {
    let credentials = Observable.combineLatest(email.asObservable(), password.asObservable())
    
    loginTap
      .withLatestFrom(credentials)
      .do(onNext: { email, password in
        print("Credentials Received - Email: \(email), Password: \(password)")
      })
      .flatMapLatest { email, password in
        return Auth.auth().rx.signIn(withEmail: email, password: password)
          .do(onNext: { result in
            print("Firebase Sign In Result: \(result)")
          }, onError: { error in
            print("Firebase Sign In Error: \(error.localizedDescription)")
          })
      }
      .subscribe(onNext: { [weak self] _ in
        self?.loginSuccess.onNext(())
      }, onError: { [weak self] error in
        self?.loginError.onNext(self?.translateFirebaseError(error) ?? "로그인 실패")
      })
      .disposed(by: disposeBag)
    
  }
  
  private func translateFirebaseError(_ error: Error) -> String {
    let errorCode = (error as NSError).code
    
    switch errorCode {
    case AuthErrorCode.invalidEmail.rawValue:
      return "유효하지 않은 이메일 주소입니다. 다시 확인해주세요."
    case AuthErrorCode.wrongPassword.rawValue:
      return "비밀번호가 올바르지 않습니다."
    case AuthErrorCode.userNotFound.rawValue:
      return "해당 이메일로 등록된 사용자가 없습니다."
    case AuthErrorCode.networkError.rawValue:
      return "네트워크 오류가 발생했습니다. 다시 시도해주세요."
    default:
      return error.localizedDescription
    }
  }
}

extension Reactive where Base: Auth {
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
}
