//
//  NotificationData.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/5/24.
//

import Foundation

class EmergencyReportData {
  static let shared = EmergencyReportData()
  
  func setNotifications() -> [Notification] {
    return [
      Notification(id: "emergencyReport1", name: "emergencyReport A", address: "서울시 마포구", longitude: 126.9600, latitude: 37.5512),
      Notification(id: "emergencyReport2", name: "emergencyReport B", address: "서울시 영등포구", longitude: 126.9301, latitude: 37.5293)
    ]
  }
  
  func findAed(id: String) -> Notification? {
    return setNotifications().first(where: { $0.id == id })
  }
  
  func isValidAed(id: String) -> Bool {
    return setNotifications().contains(where: { $0.id == id })
  }
}
