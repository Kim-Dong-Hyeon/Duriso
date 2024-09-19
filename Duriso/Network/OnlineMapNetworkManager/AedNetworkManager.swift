//
//  AedNetworkManager.swift
//  Duriso
//
//  Created by 이주희 on 9/10/24.
//

import Foundation

import Alamofire
import RxSwift

class AedNetworkManager {
  private let baseURL = "https://www.safetydata.go.kr"
  private let endpoint = "/V2/api/DSSP-IF-00068"
  private let networkManager = NetworkManager()
  private let disposeBag = DisposeBag()
  
  // MARK: AED 데이터를 API로부터 가져오는 함수
  func fetchAllAeds(boundingBox: (startLat: Double, endLat: Double, startLot: Double, endLot: Double)) -> Observable<AedResponse> {
    return Observable.create { observer in
      var allAeds: [Aed] = []
      let numOfRows = 1000
      var pageNo = 1
      
      func fetchPage() {
        let parameters: [String: Any] = [
          "serviceKey": Environment.aedApiKey,
          "numOfRows": numOfRows,
          "pageNo": pageNo
        ]
        
        self.networkManager.request(
          baseURL: self.baseURL,
          endpoint: self.endpoint,
          parameters: parameters,
          responseType: AedResponse.self
        ).subscribe(onNext: { response in
          allAeds.append(contentsOf: response.body)
          
          if response.body.count < numOfRows {
            // 더 이상 데이터가 없으면 완료
            let finalResponse = AedResponse(
              header: response.header,
              numOfRows: response.numOfRows,
              pageNo: response.pageNo,
              totalCount: allAeds.count,
              body: allAeds
            )
            observer.onNext(finalResponse)
            observer.onCompleted()
          } else {
            // 다음 페이지 요청
            pageNo += 1
            fetchPage()
          }
        }, onError: { error in
          observer.onError(error)
        }).disposed(by: self.disposeBag)
      }
      
      fetchPage() // 첫 페이지 요청
      return Disposables.create() // Dispose 처리
    }
  }
}

import RxSwift

class AedDataManager {
  private let aedNetworkManager = AedNetworkManager()
  let disposeBag = DisposeBag()
  
  // 전체 AED 데이터 요청 및 UserDefaults에 저장
  func fetchAllAeds() -> Observable<AedResponse> {
    // UserDefaults에서 데이터 로드
    if let storedAeds = loadAeds() {
      return Observable.just(storedAeds) // UserDefaults에서 로드된 데이터를 Observable로 반환
    }
    // 전역 범위로 데이터 요청
    let boundingBox = (startLat: -90.0, endLat: 90.0, startLot: -180.0, endLot: 180.0) // 전체 범위
    
    return Observable.create { observer in
      self.aedNetworkManager.fetchAllAeds(boundingBox: boundingBox)
        .subscribe(onNext: { response in
          // UserDefaults에 저장
          if let data = try? JSONEncoder().encode(response) {
            UserDefaults.standard.set(data, forKey: "AedData")
            print("전체 AED 데이터가 UserDefaults에 저장되었습니다.")
          }
          observer.onNext(response) // 데이터 전달
          observer.onCompleted()
        }, onError: { error in
          observer.onError(error)
        })
        .disposed(by: self.disposeBag) // 구독 해지 설정
      
      return Disposables.create()
    }
  }
  
  // UserDefaults에서 AED 데이터 로드
  func loadAeds() -> AedResponse? {
    if let data = UserDefaults.standard.data(forKey: "AedData"),
       let aedResponse = try? JSONDecoder().decode(AedResponse.self, from: data) {
      return aedResponse
    }
    return nil
  }
}
