//
//  MyPageViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import AuthenticationServices

import FirebaseAuth
import RxCocoa
import RxSwift

class MyPageViewModel: NSObject {
  // Inputs
  let logoutTrigger = PublishSubject<Void>()
  let deleteAccountTrigger = PublishSubject<Void>()
  
  // Outputs
  let items: Observable<[MyPageModel]>
  let nickname = BehaviorRelay<String>(value: "")
  let postcount = BehaviorRelay<Int>(value: 0)
  let logoutResult = PublishSubject<Result<Void, Error>>()
  let deleteAccountResult = PublishSubject<Result<Void, Error>>()
  
  private let disposeBag = DisposeBag()
  private var accountDeletionObserver: AnyObserver<Void>?
  
  override init() {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    // 앱의 버전을 앱의 설정파일에서 불러옴 (빌드나 배포에 따라 버전 정보가 자동 업데이트)
    
    items = Observable.just([
      MyPageModel(title: "차단 목록", type: .disclosure, selected: true),
      MyPageModel(title: "공지사항", type: .disclosure, selected: true),
      MyPageModel(title: "법적고지", type: .disclosure, selected: true),
      MyPageModel(title: "저작권 표시", type: .disclosure, selected: true),
      MyPageModel(title: "오프라인 정보 다운로드", type: .disclosure, selected: true),
      MyPageModel(title: "버전 정보", type: .version(version), selected: false),
      MyPageModel(title: "로그아웃", type: .disclosure, selected: true),
      MyPageModel(title: "회원탈퇴", type: .disclosure, selected: true)
    ])
    super.init()
    
    setupBindings()
    fetchUserData()
  }
  
  private func setupBindings() {
    logoutTrigger
      .flatMapLatest { FirebaseAuthManager.shared.signOut() }
      .subscribe(onNext: { [weak self] in
        self?.logoutResult.onNext(.success(()))
      }, onError: { [weak self] error in
        self?.logoutResult.onNext(.failure(error))
      })
      .disposed(by: disposeBag)
    
    deleteAccountTrigger
      .do(onNext: { print("회원탈퇴 프로세스 시작") })
      .flatMapLatest { [weak self] in
        print("사용자 재인증 시작")
        return self?.reauthenticateUser() ?? Observable.error(NSError(domain: "ReauthError", code: -1, userInfo: nil))
      }
      .do(onNext: { print("사용자 재인증 성공") })
      .flatMapLatest {
        print("계정 삭제 시작")
        return FirebaseAuthManager.shared.deleteAccount()
      }
      .subscribe(
        onNext: { [weak self] in
          print("계정 삭제 성공")
          self?.deleteAccountResult.onNext(.success(()))
        },
        onError: { [weak self] error in
          print("계정 삭제 실패: \(error.localizedDescription)")
          self?.deleteAccountResult.onNext(.failure(error))
        }
      )
      .disposed(by: disposeBag)
  }
  
  private func fetchUserData() {
    guard let uid = FirebaseAuthManager.shared.getCurrentUser()?.uid else { return }
    
    FirebaseFirestoreManager.shared.fetchUserData(uid: uid)
      .subscribe(onNext: { [weak self] data in
        self?.nickname.accept(data["nickname"] as? String ?? "")
        self?.postcount.accept(data["postcount"] as? Int ?? 0)
      }, onError: { error in
        print("Failed to fetch user data: \(error)")
      })
      .disposed(by: disposeBag)
  }
  
  // 사용자 재인증 메서드
  private func reauthenticateUser() -> Observable<Void> {
    return Observable.create { [weak self] observer in
      guard let self = self else {
        observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
        return Disposables.create()
      }
      
      guard let user = Auth.auth().currentUser else {
        observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
        return Disposables.create()
      }
      
      if let providerData = user.providerData.first {
        switch providerData.providerID {
        case "password":
          self.reauthenticateWithPassword(observer: observer)
        case "apple.com":
          self.reauthenticateWithApple(observer: observer)
        default:
          observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unsupported provider"]))
        }
      } else {
        observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No provider data"]))
      }
      
      return Disposables.create()
    }
  }
  
  private func reauthenticateWithPassword(observer: AnyObserver<Void>) {
    let alert = UIAlertController(title: "재인증", message: "계정 삭제를 위해 비밀번호를 다시 입력해주세요.", preferredStyle: .alert)
    alert.addTextField { textField in
      textField.placeholder = "비밀번호"
      textField.isSecureTextEntry = true
    }
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
      guard let password = alert.textFields?.first?.text, !password.isEmpty else {
        observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Password is empty"]))
        return
      }
      
      guard let email = Auth.auth().currentUser?.email else {
        observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No email found"]))
        return
      }
      
      let credential = EmailAuthProvider.credential(withEmail: email, password: password)
      Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext(())
          observer.onCompleted()
        }
      }
    }))
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
      observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Reauthentication cancelled"]))
    }))
    
    DispatchQueue.main.async {
      UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
  }
  
  private func reauthenticateWithApple(observer: AnyObserver<Void>) {
    guard let user = Auth.auth().currentUser else {
      observer.onError(NSError(domain: "ReauthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"]))
      return
    }
    
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.user = user.uid // 현재 사용자 UID 설정
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
    
    NotificationCenter.default.addObserver(forName: .appleSignInCompleted, object: nil, queue: nil) { notification in
      if let error = notification.userInfo?["error"] as? Error {
        observer.onError(error)
      } else {
        observer.onNext(())
        observer.onCompleted()
      }
    }
  }
}

extension MyPageViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.shared.windows.first!
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
       let appleIDToken = appleIDCredential.identityToken,
       let idTokenString = String(data: appleIDToken, encoding: .utf8) {
      
      let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: "")
      
      Auth.auth().currentUser?.reauthenticate(with: credential) { _, error in
        if let error = error as NSError? {
          print("Reauthentication failed: \(error.localizedDescription), \(error.userInfo)")
          NotificationCenter.default.post(name: .appleSignInCompleted, object: nil, userInfo: ["error": error])
        } else {
          print("Reauthentication successful")
          NotificationCenter.default.post(name: .appleSignInCompleted, object: nil)
        }
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Authorization error: \(error.localizedDescription)")
    NotificationCenter.default.post(name: .appleSignInCompleted, object: nil, userInfo: ["error": error])
  }
}
