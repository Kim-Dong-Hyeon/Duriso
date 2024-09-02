//
//  NetworkMonitor.swift
//  Duriso
//
//  Created by 김동현 on 9/2/24.
//

import Network

import RxCocoa
import RxSwift

/// 네트워크 연결 상태를 모니터링 하는 싱글톤 클래스
class NetworkMonitor {
  /// 공유 인스턴스
  static let shared = NetworkMonitor()
  
  private let monitor: NWPathMonitor
  private let queue = DispatchQueue(label: "NetworkMonitor")
  
  /// 현재 네트워크 연결 상태를 나타내는 BehaviorRelay
  let isConnected = BehaviorRelay<Bool>(value: false)
  
  private init() {
    monitor = NWPathMonitor()
  }
  
  /// 네트워크 모니터링 시작
  func startMonitoring() {
    monitor.start(queue: queue)
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected.accept(path.status == .satisfied)
    }
  }
  
  /// 네트워크 모니터링 중지
  func stopMonitoring() {
    monitor.cancel()
  }
}
