//
//  AedDataManager.swift
//  Duriso
//
//  Created by 이주희 on 9/20/24.
//

import Foundation

import RxSwift

// MARK: - AED 데이터 매니저
class AedDataManager {
  
  private let aedNetworkManager = AedNetworkManager()
  let disposeBag = DisposeBag()
  
  // MARK: - 전체 AED 데이터 요청 및 UserDefaults에 저장
  func fetchAllAeds() -> Observable<AedResponse> {
    // UserDefaults에서 데이터 로드
    if let storedAeds = loadAeds() {
      return Observable.just(storedAeds) // UserDefaults에서 로드된 데이터를 Observable로 반환
    }
    
    // 전역 범위로 데이터 요청
    let boundingBox = (startLat: -90.0, endLat: 90.0, startLot: -180.0, endLot: 180.0) // 전 세계 범위
    
    return Observable.create { observer in
      self.aedNetworkManager.fetchAllAeds(boundingBox: boundingBox)
        .subscribe(onNext: { response in
          // UserDefaults에 저장
          if let data = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(data, forKey: "AedData")
            print("전체 AED 데이터가 UserDefaults에 저장되었습니다.")
          }
          observer.onNext(response)
          observer.onCompleted()
        }, onError: { error in
          observer.onError(error)
        })
        .disposed(by: self.disposeBag)
      
      return Disposables.create()
    }
  }
  
  // MARK: - UserDefaults에서 AED 데이터 로드
  func loadAeds() -> AedResponse? {
    if let data = UserDefaults.standard.data(forKey: "AedData"),
       let aedResponse = try? JSONDecoder().decode(AedResponse.self, from: data) {
      return aedResponse
    }
    return nil
  }
}
