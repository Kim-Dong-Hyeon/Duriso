//
//  File2.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import Foundation

class AedData {
    static let shared = AedData()
    
    func setAeds() -> [Aed] {
        return [
            Aed(id: "Aed1", name: "AED A", address: "서울시 종로구", longitude: 126.9901, latitude: 37.5703),
            Aed(id: "Aed2", name: "AED B", address: "서울시 용산구", longitude: 126.9810, latitude: 37.5612)
        ]
    }
  func findAed(id: String) -> Aed? {
    return setAeds().first(where: { $0.id == id })
  }
  
  func isValidAed(id: String) -> Bool {
    return setAeds().contains(where: { $0.id == id })
  }
}
