//
//  FirebaseAuthManager.swift
//  Duriso
//
//  Created by 김동현 on 10/10/24.
//

import AuthenticationServices
import CryptoKit

import FirebaseAuth
import RxSwift

class FirebaseAuthManager: NSObject {
  static let shared = FirebaseAuthManager()
  private override init() {}
  
  // 현재 로그인 세션을 위한 nonce 저장
  private var currentNonce: String?
  
  // 현재 사용자를 반환하는 메서드 추가
  func getCurrentUser() -> FirebaseAuth.User? {
    return Auth.auth().currentUser
  }
  
  // 현재 로그인된 사용자의 UID 반환
  func getCurrentUserUid() -> String? {
    return Auth.auth().currentUser?.uid
  }
  
  // 이메일 로그인
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
  
  // Apple 로그인
  func signInWithApple() -> Observable<AuthDataResult> {
    return Observable.create { [weak self] observer in
      guard let self = self else { return Disposables.create() }
      
      let nonce = self.randomNonceString()
      self.currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = self.sha256(nonce)
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.performRequests()
      
      // Apple 로그인 결과 처리
      NotificationCenter.default.addObserver(forName: .appleSignInCompleted, object: nil, queue: nil) { notification in
        if let authResult = notification.object as? AuthDataResult {
          observer.onNext(authResult)
          observer.onCompleted()
        } else if let error = notification.userInfo?["error"] as? Error {
          observer.onError(error)
        }
      }
      
      return Disposables.create()
    }
  }
  
  // 로그아웃
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
  
  // 회원 탈퇴
  func deleteAccount(appleCredential: AuthCredential? = nil) -> Observable<Void> {
    return Observable.create { observer in
      print("FirebaseAuthManager: 계정 삭제 시작")
      
      guard let user = Auth.auth().currentUser else {
        print("FirebaseAuthManager: 현재 로그인된 사용자 없음")
        observer.onError(NSError(domain: "DeleteAccountError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인된 사용자 없음"]))
        return Disposables.create()
      }
      
      print("FirebaseAuthManager: Firestore 데이터 삭제 시작")
      
      FirebaseFirestoreManager.shared.deleteUserData(uid: user.uid)
        .flatMap { _ -> Observable<Void> in
          print("FirebaseAuthManager: Firestore 데이터 삭제 성공")
          
          // Apple 계정일 경우 Apple 계정 삭제 처리
          if let appleCredential = appleCredential {
            return self.deleteUserWithApple(appleCredential: appleCredential)
              .map { _ in }  // Bool 값을 무시하고 Void로 변환
              .asObservable()
          } else {
            return self.deleteFirebaseUser(user: user)
          }
        }
        .subscribe(
          onNext: {
            print("FirebaseAuthManager: 계정 삭제 프로세스 완료")
            observer.onNext(())
            observer.onCompleted()
          },
          onError: { error in
            print("FirebaseAuthManager: 계정 삭제 프로세스 실패 - \(error.localizedDescription)")
            observer.onError(error)
          }
        )
        .disposed(by: DisposeBag())
      
      return Disposables.create()
    }
  }
  
  private func deleteUserWithApple(appleCredential: AuthCredential) -> Single<Bool> {
    return Single<Bool>.create { single in
      guard let user = Auth.auth().currentUser else {
        single(.failure(NSError(domain: "User is nil", code: -1, userInfo: nil)))
        return Disposables.create()
      }
      
      // Apple 계정으로 재인증 후 삭제
      user.reauthenticate(with: appleCredential) { authResult, error in
        if let error = error {
          single(.failure(error))
        } else {
          user.delete { error in
            if let error = error {
              single(.failure(error))
            } else {
              single(.success(true))  // 삭제 성공
            }
          }
        }
      }
      
      return Disposables.create()
    }
  }
  
  func deleteUserWithEmail(password: String) -> Single<Bool> {
    return Single<Bool>.create { single in
      guard let user = Auth.auth().currentUser, let email = user.email else {
        single(.failure(NSError(domain: "User or Email is nil", code: -1, userInfo: nil)))
        return Disposables.create()
      }
      
      let credential = EmailAuthProvider.credential(withEmail: email, password: password)
      
      user.reauthenticate(with: credential) { authResult, error in
        if let error = error {
          single(.failure(error))
        } else {
          user.delete { error in
            if let error = error {
              single(.failure(error))
            } else {
              single(.success(true))  // 삭제 성공 시
            }
          }
        }
      }
      return Disposables.create()
    }
  }
  
  private func deleteFirebaseUser(user: FirebaseAuth.User) -> Observable<Void> {
    return Observable.create { innerObserver in
      user.delete { error in
        if let error = error {
          print("FirebaseAuthManager: Firebase Auth 계정 삭제 실패 - \(error.localizedDescription)")
          innerObserver.onError(error)
        } else {
          print("FirebaseAuthManager: Firebase Auth 계정 삭제 성공")
          innerObserver.onNext(())
          innerObserver.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  // Apple 인증 토큰 생성
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
  
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    return hashedData.compactMap { String(format: "%02x", $0) }.joined()
  }
}

// Apple 로그인 델리게이트 처리
extension FirebaseAuthManager: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
       let appleIDToken = appleIDCredential.identityToken,
       let idTokenString = String(data: appleIDToken, encoding: .utf8),
       let nonce = currentNonce {
      
      let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
      
      Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
          NotificationCenter.default.post(name: .appleSignInCompleted, object: nil, userInfo: ["error": error])
          return
        }
        if let authResult = authResult {
          NotificationCenter.default.post(name: .appleSignInCompleted, object: authResult)
        }
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    NotificationCenter.default.post(name: .appleSignInCompleted, object: nil, userInfo: ["error": error])
  }
}

extension Notification.Name {
  static let appleSignInCompleted = Notification.Name("appleSignInCompleted")
}
