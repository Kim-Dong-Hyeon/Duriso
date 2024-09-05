//
//  GuidelineNetWork.swift
//  Duriso
//
//  Created by 신상규 on 9/3/24.
//

import Foundation

import Alamofire
import RxSwift

class GuidelineNetWork {
  private let baseURL = "https://www.safetydata.go.kr"
  private let endpoint = "/V2/api/DSSP-IF-00051"
  
  func fetchGuidelineData() -> Observable<ApiResponse> {
    return Observable.create { observer in
      let url = self.baseURL + self.endpoint
      let parameters: [String: Any] = [
        "serviceKey": Environment.newsApiKey,
        "numOfRows": 10,
        "pageNo": 1,
        "sortBy": "desc"
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
            let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            observer.onNext(apiResponse)
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
