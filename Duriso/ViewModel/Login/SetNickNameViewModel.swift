//
//  SetNickNameViewModel.swift
//  Duriso
//
//  Created by 김동현 on 10/17/24.
//

import Foundation

import FirebaseFirestore
import RxSwift
import RxCocoa

class SetNickNameViewModel {
  
  let nicknameText = BehaviorRelay<String>(value: "")
  let isNicknameValid = BehaviorRelay<Bool>(value: false)
  let saveButtonTapped = PublishSubject<Void>()
  let saveResult = PublishSubject<Result<Void, Error>>()
  
  private let disposeBag = DisposeBag()
  private let firestore = Firestore.firestore()
  
  init() {
    // 닉네임이 3자 이상일 때 유효하다고 판단
    nicknameText
      .map { $0.count >= 3 }
      .bind(to: isNicknameValid)
      .disposed(by: disposeBag)
    
    // 닉네임 입력 값이 변경될 때마다 중복 확인
    nicknameText
      .flatMapLatest { [weak self] nickname -> Observable<Bool> in
        guard let self = self else { return Observable.just(false) }
        return self.nicknameCheckObservable(nickname)
      }
      .bind(to: isNicknameValid)  // 중복 확인 결과에 따라 닉네임 유효성 업데이트
      .disposed(by: disposeBag)
    
    // 저장 버튼이 눌렸을 때 Firestore에 닉네임 저장
    saveButtonTapped
      .withLatestFrom(nicknameText)
      .flatMapLatest { [weak self] nickname -> Observable<Void> in
        guard let self = self else { return Observable.error(NSError(domain: "", code: -1, userInfo: nil)) }
        return self.nicknameCheckObservable(nickname)
          .flatMap { isAvailable -> Observable<Void> in
            if isAvailable {
              print("닉네임 사용 가능. Firestore에 저장 시작.")
              return self.saveNicknameToFirestore(nickname: nickname)
            } else {
              print("닉네임 중복됨.")
              return Observable.error(NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "이미 사용 중인 닉네임입니다."]))
            }
          }
      }
      .subscribe(onNext: {
        print("닉네임 저장 성공. 화면 전환 준비.")
        self.saveResult.onNext(.success(())) // 성공적으로 저장되면 성공 결과 전달
      }, onError: { error in
        print("닉네임 저장 실패: \(error.localizedDescription)")
        self.saveResult.onNext(.failure(error)) // 오류 발생 시 실패 결과 전달
      })
      .disposed(by: disposeBag)
  }
  
  // 닉네임 중복 확인
  private func nicknameCheckObservable(_ nickname: String) -> Observable<Bool> {
    return Observable.create { observer in
      guard !nickname.isEmpty else {
        observer.onNext(false)
        observer.onCompleted()
        return Disposables.create()
      }
      
      print("닉네임 중복 확인 중: \(nickname)")
      
      self.firestore.collection("users")
        .whereField("nickname", isEqualTo: nickname)
        .getDocuments { snapshot, error in
          if let error = error {
            print("닉네임 중복 확인 중 오류 발생: \(error.localizedDescription)")
            observer.onError(error)
          } else if let snapshot = snapshot, !snapshot.isEmpty {
            print("닉네임 중복 확인: 닉네임이 이미 사용 중입니다.")
            observer.onNext(false) // 닉네임 중복
          } else {
            print("닉네임 중복 확인: 닉네임 사용 가능.")
            observer.onNext(true)  // 닉네임 사용 가능
          }
          observer.onCompleted()
        }
      
      return Disposables.create()
    }
  }
  
  // Firestore에 닉네임과 추가 사용자 정보 저장
  private func saveNicknameToFirestore(nickname: String) -> Observable<Void> {
    return Observable.create { observer in
      guard let uid = FirebaseAuthManager.shared.getCurrentUser()?.uid else {
        print("로그인된 사용자 없음.")
        observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인된 사용자 없음"]))
        return Disposables.create()
      }
      
      // 애플 로그인 사용자의 이메일 정보 가져오기
      let email = FirebaseAuthManager.shared.getCurrentUser()?.email ?? "apple_user@unknown.com"
      
      let data: [String: Any] = [
        "nickname": nickname,
        "email": email,                    // 애플 로그인 사용자 이메일 저장
        "postcount": 0,
        "reportedpostcount": 0,
        "uuid": uid,
        "createdAt": Timestamp(date: Date())
      ]
      
      print("Firestore에 사용자 정보 저장 시작: \(nickname)")
      
      self.firestore.collection("users").document(uid).setData(data, merge: true) { error in
        if let error = error {
          print("Firestore에 사용자 정보 저장 실패: \(error.localizedDescription)")
          observer.onError(error)
        } else {
          print("Firestore에 사용자 정보 저장 성공")
          observer.onNext(())
          observer.onCompleted()
        }
      }
      
      return Disposables.create()
    }
  }
}
