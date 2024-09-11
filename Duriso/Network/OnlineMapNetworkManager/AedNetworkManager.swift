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
  func fetchAeds(boundingBox: (startLat: Double, endLat: Double, startLot: Double, endLot: Double)) -> Observable<AedResponse> {
    let parameters: [String: Any] = [
      "serviceKey": Environment.aedApiKey,
      "numOfRows": 1000,
      "startLot": boundingBox.startLot,
      "endLot": boundingBox.endLot,
      "startLat": boundingBox.startLat,
      "endLat": boundingBox.endLat,
      "pageNo": 1
    ]
    
    return networkManager.request(
      baseURL: baseURL,
      endpoint: endpoint,
      parameters: parameters,
      responseType: AedResponse.self
    )
  }
}
