////
////  PoiViewModel.swift
////  Duriso
////
////  Created by 이주희 on 8/26/24.
////
//import Foundation
//
//import RxCocoa
//import RxSwift
//import KakaoMapsSDK
//
//class PoiViewModel {
//  private let disposeBag = DisposeBag()
//  //Input : poi 클릭 이벤트
//  let poiTappedHandler = PublishSubject<PoiData>()
//  
//  //Output : poi 클릭시 뷰 전환
//  var poiBottomSheet: Observable<PoiData> {
//    return poiTappedHandler.asObservable()
//  }
//  
//  init() {
//    poiBottomSheet
//      .subscribe(onNext: { poiData in
////        self.showPoiBottomSheet(poiData)
//      })
//      .disposed(by: disposeBag)
//  }
//  
//  func showPoiBottomSheet(_ poiData: PoiData) {
//      // MapBottomSheetViewController 인스턴스 생성
//      let mapBottomSheet = MapBottomSheetViewController()
//      
//      // panelContentsViewController의 인스턴스를 가져옵니다.
//    if let panelContentsViewController = mapBottomSheet.panelContentsViewController {
//          // POI 데이터 업데이트
//          panelContentsViewController.updatePoiData(with: poiData)
//      }
//      
//      // 최상위 뷰 컨트롤러를 가져와서 mapBottomSheet을 표시합니다.
//      guard let topViewController = UIApplication.shared.windows.first?.rootViewController else {
//          return
//      }
//      topViewController.present(mapBottomSheet, animated: true, completion: nil)
//  }
//}
