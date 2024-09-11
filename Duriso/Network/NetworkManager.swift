//
//  NetworkManager.swift
//  Duriso
//
//  Created by 이주희 on 9/9/24.
//

import Foundation
import Alamofire
import RxSwift

class NetworkManager {
  
  // 제네릭 네트워크 요청 함수로, 다양한 API 요청에 재사용 가능.
  // T: Decodable을 준수하는 제네릭 타입으로, 원하는 모델로 응답을 파싱할 수 있음.
  func request<T: Decodable>(
    baseURL: String,           // API URL
    endpoint: String,          // API 엔드포인트.
    parameters: [String: Any], // API 요청 시 파라미터.
    responseType: T.Type       // 응답 데이터를 디코딩할 타입.
  ) -> Observable<T> {
    return Observable.create { observer in
      let url = baseURL + endpoint
      
      print("Request URL: \(url)")
      print("Request Parameters: \(parameters)")
      
      // Alamofire
      AF.request(url, parameters: parameters).responseData { response in
        switch response.result {
        case .success(let data):   // 요청 성공 시
          if let responseString = String(data: data, encoding: .utf8) {
            /*  print("Response Data: \(responseString)") */  // 응답 데이터 출력.
          }
          
          do {
            // 응답 데이터를 제네릭 타입 T 디코딩
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            observer.onNext(decodedResponse)  // 디코딩된 데이터를 옵저버에 전달.
            observer.onCompleted()            // 옵저버 완료.
          } catch {
            observer.onError(error)           // 디코딩 실패 시 에러 전달.
          }
        case .failure(let error):                // 요청 실패 시
          observer.onError(error)              // 에러 전달.
        }
      }
      
      return Disposables.create()  
    }
  }
}
