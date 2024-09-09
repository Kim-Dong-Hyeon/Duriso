//
//  ShelterNetworkManager.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/9/24.
//

import Foundation

import Alamofire
import RxSwift

class ShelterNetworkManager {
  private let baseURL = "https://www.safetydata.go.kr"
  private let endpoint = "/V2/api/DSSP-IF-10941"
  
  // Observable<ShelterResponse>로 변경
  func fetchShelters() -> Observable<ShelterResponse> {
    return Observable.create { observer in
      let url = self.baseURL + self.endpoint
      let parameters: [String: Any] = [
        "serviceKey": Environment.shelterApiKey,
        "numOfRows": 1000,
        "startLot": "126.0",
        "endLot": "127.0",
        "startLat": "35.0",
        "endLat": "36.0"
      ]
      
      print("Request URL: \(url)")
      
      AF.request(url, parameters: parameters).responseData { response in
        switch response.result {
        case .success(let data):
          // 응답 데이터 출력
          if let responseString = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseString)")
          }
          
          do {
            // ShelterResponse로 디코딩
            let shelterResponse = try JSONDecoder().decode(ShelterResponse.self, from: data)
            observer.onNext(shelterResponse)
            observer.onCompleted()
          } catch {
            observer.onError(error)
          }
        case .failure(let error):
          observer.onError(error)
        }
      }
      
      return Disposables.create()
    }
  }
}
