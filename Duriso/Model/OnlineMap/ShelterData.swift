//
//  File.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/3/24.
//

import Foundation

class ShelterData {
    static let shared = ShelterData()
    
    func setShelters() -> [Shelter] {
        return [
            Shelter(id: "Shelter1", name: "Shelter A", address: "서울시 강남구", longitude: 126.967969, latitude: 37.5665, capacity: 500),
            Shelter(id: "Shelter2", name: "Shelter B", address: "서울시 서초구", longitude: 126.9720, latitude: 37.5600, capacity: 400)
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
