//
//  AedNetworkManager.swift
//  Duriso
//
//  Created by 이주희 on 9/10/24.
//

import Foundation

import Alamofire
import RxSwift

// MARK: - AED 네트워크 매니저
class AedNetworkManager {
  
  // 기본 URL과 엔드포인트 설정
  private let baseURL = "https://www.safetydata.go.kr"
  private let endpoint = "/V2/api/DSSP-IF-00068"
  private let networkManager = NetworkManager()
  private let disposeBag = DisposeBag()
  
  // MARK: - AED 데이터를 API로부터 가져오는 함수
  /// - Parameter boundingBox: 검색할 좌표 범위를 지정하는 파라미터
  /// - Returns: AED 데이터를 포함한 `Observable<AedResponse>` 객체를 반환합니다.
  func fetchAllAeds(boundingBox: (startLat: Double, endLat: Double, startLot: Double, endLot: Double)) -> Observable<AedResponse> {
    return Observable.create { observer in
      var allAeds: [Aed] = []
      let numOfRows = 1000
      var pageNo = 1
      
      // 페이지 단위로 AED 데이터를 요청하는 함수
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
            // 더 이상 데이터가 없을 경우 완료 처리
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

