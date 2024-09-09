//
//  File.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/3/24.
//

import Foundation

import RxSwift

class ShelterRepository {
  
  private let baseUrl = "https://www.safetydata.go.kr/V2/api/"
  private let disposeBag = DisposeBag()
  private var apiKey: String {
    return Bundle.main.infoDictionary?["SHELTER_API_KEY"] as? String ?? ""
  }
  
  func fetchData(lat: Double, lon: Double, radius: Double, pageNo: String, numOfRows: String) -> Observable<[Shelter]> {
    var urlComponents = URLComponents(string: baseUrl)!
    
    let bounds = calculateBounds(for: CLLocation(latitude: lat, longitude: lon), radius: radius)
    
    let queryItems = [
      URLQueryItem(name: "servicekey", value: apiKey),
      URLQueryItem(name: "pageNo", value: pageNo),
      URLQueryItem(name: "numOfRows", value: numOfRows),
      URLQueryItem(name: "startLat", value: "\(bounds.startLat)"),
      URLQueryItem(name: "endLat", value: "\(bounds.endLat)"),
      URLQueryItem(name: "startLot", value: "\(bounds.startLon)"),
      URLQueryItem(name: "endLot", value: "\(bounds.endLon)")
    ]
    
    urlComponents.queryItems = queryItems
    
    
    guard let url = urlComponents.url else {
      return Observable.error(ApiError.invalidUrl)
    }
    
    return Observable.create { observer in
      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
          observer.onError(error)
          return
        }
        
        guard let data = data else {
          observer.onError(ApiError.noData)
          return
        }
        
        return Observable.create { observer in
          let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
              observer.onError(error)
              return
            }
            
            guard let data = data else {
              observer.onError(ApiError.noData)
              return
            }
            
            do {
              let shelters = try JSONDecoder().decode([Shelter].self, from: data)
              observer.onNext(shelters)
            } catch {
              observer.onError(error)
            }
            
            observer.onCompleted()
          }
          
          task.resume()
          
          return Disposables.create {
            task.cancel()
          }
        }
      }
    }
      
      private func calculateBounds(for location: CLLocation, radius: Double) -> (startLat: Double, endLat: Double, startLon: Double, endLon: Double) {
          let earthRadius = 6371.0 // 지구의 반경 (킬로미터 단위)
          let lat = location.coordinate.latitude
          let lon = location.coordinate.longitude
          
          let latDelta = radius / earthRadius
          let lonDelta = radius / (earthRadius * cos(lat * .pi / 180))
          
          let startLat = lat - latDelta
          let endLat = lat + latDelta
          let startLon = lon - lonDelta
          let endLon = lon + lonDelta
          
          return (startLat, endLat, startLon, endLon)
      }
      
      enum ApiError: Error {
        case invalidUrl
        case noData
        case parsingError
      }
    }
