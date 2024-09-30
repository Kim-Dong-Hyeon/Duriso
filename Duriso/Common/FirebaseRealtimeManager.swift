//
//  FirebaseRealtimeManager.swift
//  Duriso
//
//  Created by 김동현 on 9/18/24.
//

import Alamofire
import FirebaseDatabase
import RxSwift

class FirebaseRealtimeManager {
  static let shared = FirebaseRealtimeManager()
  private let databaseRef = Database.database().reference()
  
  func fetchAEDData() -> Observable<[FirebaseAED]> {
    return Observable.create { observer in
      self.databaseRef.child("offlinedatas/aeds").observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists(), let value = snapshot.value as? [[String: Any]] {
          do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
            let decoder = JSONDecoder()
            let aedArray = try decoder.decode([FirebaseAED].self, from: jsonData)
            observer.onNext(aedArray)
            observer.onCompleted()
          } catch let DecodingError.dataCorrupted(context) {
            print("AED 데이터 손상 오류: \(context) - Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.keyNotFound(key, context) {
            print("AED 키 \(key.stringValue)를 찾을 수 없습니다: \(context.debugDescription) - Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.typeMismatch(type, context) {
            print("AED 타입 \(type) 불일치: \(context.debugDescription) - Attribute: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.valueNotFound(value, context) {
            print("AED 값 \(value) 없음: \(context.debugDescription) - Attribute: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch {
            print("AED 기타 디코딩 오류: \(error.localizedDescription)")
          }
        } else {
          observer.onError(NSError(domain: "FirebaseRealtimeManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "AED 데이터가 존재하지 않습니다."]))
          print("Firebase에서 AED 데이터를 찾을 수 없습니다.")
        }
      }
      return Disposables.create()
    }
  }
  
  func fetchCivilDefenseShelterData() -> Observable<[FirebaseCivilDefenseShelter]> {
    return Observable.create { observer in
      self.databaseRef.child("offlinedatas/civildefenseshelters").observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists(), let value = snapshot.value as? [[String: Any]] {
          do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
            let decoder = JSONDecoder()
            let shelterArray = try decoder.decode([FirebaseCivilDefenseShelter].self, from: jsonData)
            observer.onNext(shelterArray)
            observer.onCompleted()
          } catch let DecodingError.dataCorrupted(context) {
            print("Civil Defense Shelter 데이터 손상 오류: \(context) - Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.keyNotFound(key, context) {
            print("Civil Defense Shelter 키 \(key.stringValue)를 찾을 수 없습니다: \(context.debugDescription) - Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.typeMismatch(type, context) {
            print("Civil Defense Shelter 타입 \(type) 불일치: \(context.debugDescription) - Attribute: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.valueNotFound(value, context) {
            print("Civil Defense Shelter 값 \(value) 없음: \(context.debugDescription) - Attribute: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch {
            print("Civil Defense Shelter 기타 디코딩 오류: \(error.localizedDescription)")
          }
        } else {
          observer.onError(NSError(domain: "FirebaseRealtimeManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Civil Defense Shelter 데이터가 존재하지 않습니다."]))
          print("Firebase에서 Civil Defense Shelter 데이터를 찾을 수 없습니다.")
        }
      }
      return Disposables.create()
    }
  }
  
  func fetchDisasterShelterData() -> Observable<[FirebaseDisasterShelter]> {
    return Observable.create { observer in
      self.databaseRef.child("offlinedatas/disastershelters").observeSingleEvent(of: .value) { snapshot in
        if snapshot.exists(), let value = snapshot.value as? [[String: Any]] {
          do {
            let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
            let decoder = JSONDecoder()
            let shelterArray = try decoder.decode([FirebaseDisasterShelter].self, from: jsonData)
            observer.onNext(shelterArray)
            observer.onCompleted()
          } catch let DecodingError.dataCorrupted(context) {
            print("Disaster Shelter 데이터 손상 오류: \(context) - Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.keyNotFound(key, context) {
            print("Disaster Shelter 키 \(key.stringValue)를 찾을 수 없습니다: \(context.debugDescription) - Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.typeMismatch(type, context) {
            print("Disaster Shelter 타입 \(type) 불일치: \(context.debugDescription) - Attribute: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch let DecodingError.valueNotFound(value, context) {
            print("Disaster Shelter 값 \(value) 없음: \(context.debugDescription) - Attribute: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
          } catch {
            print("Disaster Shelter 기타 디코딩 오류: \(error.localizedDescription)")
          }
        } else {
          observer.onError(NSError(domain: "FirebaseRealtimeManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Disaster Shelter 데이터가 존재하지 않습니다."]))
          print("Firebase에서 Disaster Shelter 데이터를 찾을 수 없습니다.")
        }
      }
      return Disposables.create()
    }
  }
}
