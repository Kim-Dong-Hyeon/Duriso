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
  let appleLoginTap = PublishSubject<Void>()
  
  let loginSuccess = PublishSubject<Void>()
  let loginError = PublishSubject<String>()
  let appleLoginSuccess = PublishSubject<Void>() // Apple 로그인 성공 시 사용
  
  private let disposeBag = DisposeBag()
  
  init() {
    let credentials = Observable.combineLatest(email.asObservable(), password.asObservable())
    
    loginTap
      .withLatestFrom(credentials)
      .flatMapLatest { [weak self] email, password -> Observable<AuthDataResult> in
        guard let self = self else { return .empty() }
        return FirebaseAuthManager.shared.signIn(withEmail: email, password: password)
      }
      .subscribe(onNext: { [weak self] _ in
        self?.loginSuccess.onNext(())
      }, onError: { [weak self] error in
        self?.loginError.onNext(error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    appleLoginTap
      .flatMapLatest {
        FirebaseAuthManager.shared.signInWithApple()
      }
      .flatMap { result -> Observable<(AuthDataResult, [String: Any]?)> in
        let uid = result.user.uid
        return FirebaseFirestoreManager.shared.fetchUserData(uid: uid)
          .map { userData in (result, userData) }
          .catchAndReturn((result, nil))
      }
      .flatMap { result, existingUserData -> Observable<Void> in
        let uid = result.user.uid
        let email = result.user.email ?? ""
        
        if let existingUserData = existingUserData, existingUserData["nickname"] as? String != nil {
          // 기존 사용자: 데이터 업데이트 없이 로그인 성공
          return Observable.just(())
        } else {
          // 새로운 사용자 또는 닉네임이 없는 사용자: 기본 데이터 저장
          return FirebaseFirestoreManager.shared.saveUserData(uid: uid, data: ["email": email, "nickname": "", "postcount": 0, "reportedpostcount": 0, "uuid": uid])
        }
      }
      .subscribe(onNext: { [weak self] in
        self?.appleLoginSuccess.onNext(())
      }, onError: { [weak self] error in
        self?.loginError.onNext(error.localizedDescription)
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
