//
//  MainTabBarViewModel.swift
//  Duriso
//
//  Created by 김동현 on 9/2/24.
//

import RxCocoa
import RxSwift

/// 메인 탭바의 비즈니스 로직을 처리하는 ViewModel
class MainTabBarViewModel {
  /// 현재 네트워크 연결 상태를 나타내는 Observable
  let isOnline: Observable<Bool>
  
  init() {
    // NetworkMonitor의 isConnected 상태를 Observable로 변환
    isOnline = NetworkMonitor.shared.isConnected.asObservable()
  }
}
