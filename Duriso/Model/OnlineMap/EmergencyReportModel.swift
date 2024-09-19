//
//  EmergencyReportData.swift
//  Duriso
//
//  Created by 이주희 on 9/5/24.
//

import Foundation

class EmergencyReportData {
  static let shared = EmergencyReportData()
  
  func setEmergencyReports() -> [EmergencyReport] {
    return [
      EmergencyReport(id: "emergencyReport1", name: "emergencyReport A", address: "서울시 마포구", longitude: 126.9600, latitude: 37.5512),
      EmergencyReport(id: "emergencyReport2", name: "emergencyReport B", address: "서울시 영등포구", longitude: 126.9301, latitude: 37.5293)
    ]
  }
  
  func findAed(id: String) -> EmergencyReport? {
    return setEmergencyReports().first(where: { $0.id == id })
  }
  
  func isValidAed(id: String) -> Bool {
    return setEmergencyReports().contains(where: { $0.id == id })
  }
}
