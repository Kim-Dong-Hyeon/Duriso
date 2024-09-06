//
//  File2.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import Foundation

class AedData {
  static let shared = AedData() // Singleton instance
  
  private init() {} // Singleton pattern을 위한 private init
  
  // 더미 데이터를 생성하여 반환하는 메서드
  func setAeds() -> [Aed] {
    return [
      Aed(id: "1", name: "Aed A", address: "00시 00구 00동 상세주소", longitude: 126.97769, latitude: 37.566535, capacity: 100),
      Aed(id: "2", name: "Aed B", address: "00시 00구 00동 상세주소", longitude: 126.9755, latitude: 37.5650, capacity: 50),
      Aed(id: "3", name: "Aed C", address: "00시 00구 00동 상세주소", longitude: 126.9745, latitude: 37.5640, capacity: 200),
      // 필요한 만큼 더미 데이터 추가
    ]
  }

  func findAed(id: String) -> Aed? {
    return setAeds().first(where: { $0.id == id })
  }
  
  func isValidAed(id: String) -> Bool {
    return setAeds().contains(where: { $0.id == id })
  }
}
