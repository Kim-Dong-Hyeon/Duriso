//
//  OfflineViewModel.swift
//  Duriso
//
//  Created by 김동현 on 9/2/24.
//

import RxCocoa
import RxSwift

/// 오프라인 상태에 대한 비즈니스 로직을 처리하는 ViewModel
class OfflineViewModel {
  /// 오프라인 상태 메시지를 담고 있는 BehaviorRelay
  let message = BehaviorRelay<String>(value: "네트워크가 연결되지 않았습니다.\n이 기능은 온라인 상태에서만 사용할 수 있습니다.")
}
