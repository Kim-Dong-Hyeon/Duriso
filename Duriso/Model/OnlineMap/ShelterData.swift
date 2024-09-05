//
//  File.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/3/24.
//

import Foundation

class ShelterData {
  static let shared = ShelterData() // Singleton instance
  
  private init() {} // Singleton pattern을 위한 private init
  
  // 더미 데이터를 생성하여 반환하는 메서드
  func setShelters() -> [Shelter] {
    return [
      Shelter(id: "1", name: "Shelter A", address: "00시 00구 00동 상세주소", longitude: 126.977969, latitude: 37.566535, capacity: 100),
      Shelter(id: "2", name: "Shelter B", address: "00시 00구 00동 상세주소", longitude: 126.9750, latitude: 37.5650, capacity: 50),
      Shelter(id: "3", name: "Shelter C", address: "00시 00구 00동 상세주소", longitude: 126.9740, latitude: 37.5640, capacity: 200),
      // 필요한 만큼 더미 데이터 추가
    ]
  }
  // 쉘터 ID로 특정 쉘터를 찾는 메서드
  func findShelter(id: String) -> Shelter? {
    return setShelters().first(where: { $0.id == id })
  }
  
  // 쉘터 ID가 유효한지 확인하는 메서드
  func isValidShelter(id: String) -> Bool {
    return setShelters().contains(where: { $0.id == id })
  }
}
