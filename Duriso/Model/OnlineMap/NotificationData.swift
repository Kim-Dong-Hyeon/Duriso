//
//  NotificationData.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/5/24.
//

import Foundation

class NotificationData {
  static let shared = NotificationData() // Singleton instance
  
  private init() {} // Singleton pattern을 위한 private init
  
  // 더미 데이터를 생성하여 반환하는 메서드
  func setNotifications() -> [Notification] {
    return [
      Notification(id: "1", name: "Notification A", address: "00시 00구 00동 상세주소", longitude: 126.97769, latitude: 37.5635, capacity: 100),
      Notification(id: "2", name: "Notification B", address: "00시 00구 00동 상세주소", longitude: 126.977695, latitude: 37.5630, capacity: 50),
      Notification(id: "3", name: "Notification C", address: "00시 00구 00동 상세주소", longitude: 126.97769, latitude: 37.5610, capacity: 200),
      // 필요한 만큼 더미 데이터 추가
    ]
  }

  func findAed(id: String) -> Notification? {
    return setNotifications().first(where: { $0.id == id })
  }
  
  func isValidAed(id: String) -> Bool {
    return setNotifications().contains(where: { $0.id == id })
  }
}
