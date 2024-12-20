//
//  ShelterNetworkManager.swift
//  Duriso
//
//  Created by 이주희 on 9/9/24.
//

import Foundation

import Alamofire
import RxSwift

class ShelterNetworkManager {
  
  private let baseURL = "https://www.safetydata.go.kr"
  private let endpoint = "/V2/api/DSSP-IF-10941"
  private let networkManager = NetworkManager()
  
  // MARK: 쉘터 데이터를 API로부터 가져오는 함수
  /// - Parameters:
  ///   - boundingBox: 검색할 좌표 범위를 지정하는 파라미터
  /// - Returns: 쉘터 데이터를 포함한 `Observable<ShelterResponse>` 객체를 반환합니다.
  func fetchShelters(boundingBox: (startLat: Double, endLat: Double, startLot: Double, 
                                   endLot: Double)) -> Observable<ShelterResponse> {
    let parameters: [String: Any] = [
      "serviceKey": Environment.shelterApiKey,
      "numOfRows": 1000,
      "startLot": boundingBox.startLot,
      "endLot": boundingBox.endLot,
      "startLat": boundingBox.startLat,
      "endLat": boundingBox.endLat
    ]
    
    // NetworkManager의 request 메소드를 호출하여 데이터를 요청
    return networkManager.request(
      baseURL: baseURL,
      endpoint: endpoint,
      parameters: parameters,
      responseType: ShelterResponse.self
    )
  }
}
