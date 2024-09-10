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
  
  // MARK: AED 데이터를 API로부터 가져오는 함수
  /// - Returns: AED 데이터를 포함한 `Observable<AedResponse>` 객체를 반환합니다.
  func fetchAeds() -> Observable<AedResponse> {
    let parameters: [String: Any] = [
      "serviceKey": Environment.aedApiKey,
      "numOfRows": 1000,
      "pageNo": 1
    ]
    
    /// NetworkManager의 request 메소드를 호출하여 데이터를 요청
    return networkManager.request(
      baseURL: baseURL,
      endpoint: endpoint,
      parameters: parameters,
      responseType: AedResponse.self
    )
  }
}

