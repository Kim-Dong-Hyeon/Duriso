//
//  NetworkMonitor.swift
//  Duriso
//
//  Created by 김동현 on 9/2/24.
//

import Network

class NetworkMonitor {
  static let shared = NetworkMonitor()
  
  private let monitor: NWPathMonitor
  private(set) var isConnected: Bool = false
  
  private init() {
    monitor = NWPathMonitor()
  }
  
  func startMonitoring() {
    monitor.start(queue: DispatchQueue.global())
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected = path.status == .satisfied
    }
  }
  
  func stopMonitoring() {
    monitor.cancel()
  }
}
