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
  private let endpoint = "/V2/api/DSSP-IF-10941"
  private let networkManager = NetworkManager()
  
  // MARK: 쉘터 데이터를 API로부터 가져오는 함수
  /// - Returns: 쉘터 데이터를 포함한 `Observable<ShelterResponse>` 객체를 반환합니다.
  func fetchShelters() -> Observable<ShelterResponse> {
    let parameters: [String: Any] = [
      "serviceKey": Environment.shelterApiKey,
      "numOfRows": 1000,
      "startLot": "126.0",
      "endLot": "127.0",
      "startLat": "35.0",
      "endLat": "36.0"
    ]
    
    /// NetworkManager의 request 메소드를 호출하여 데이터를 요청
    return networkManager.request(
      baseURL: baseURL,
      endpoint: endpoint,
      parameters: parameters,
      responseType: ShelterResponse.self
    )
  }
}

