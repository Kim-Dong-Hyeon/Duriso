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
  private let endpoint = "/V2/api/DSSP-IF-00247"
  
  func fetchGuidelineData(pageNo: Int, numOfRows: Int, crtDt: String, rgnNm: String) -> Observable<ApiResponse> {
    let parameters: [String: Any] = [
      "serviceKey": Environment.disasterApiKey,
      "numOfRows": numOfRows,
      "pageNo": pageNo,
      "crtDt": crtDt,
      "rgnNm": rgnNm
    ]
    
    let url = baseURL + endpoint
    
    return Observable.create { observer in
      AF.request(url, parameters: parameters).responseData { response in
        switch response.result {
        case .success(let data):
          if let responseString = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseString)")
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            observer.onNext(apiResponse)
            observer.onCompleted()
          } catch {
            print("Decoding Error: \(error)")
            observer.onError(error)
          }
          
        case .failure(let error):
          print("Request Error: \(error.localizedDescription)")
          observer.onError(error)
        }
      }
      
      return Disposables.create()
    }
  }
}
