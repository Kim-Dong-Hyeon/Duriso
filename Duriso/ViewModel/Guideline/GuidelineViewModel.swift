//
//  GuidelineViewModel.swift
//  Duriso
//
//  Created by 신상규 on 9/3/24.
//

import Foundation
import UIKit

import Alamofire
import RxCocoa
import RxSwift

class GuidelineViewModel {
  let title: BehaviorRelay<String> = BehaviorRelay(value: "Loading...")
  let writerName: BehaviorRelay<String> = BehaviorRelay(value: "Loading...")
  
  private let disposeBag = DisposeBag()
  private let network = GuidelineNetWork()
  
  // Fetch data from network
  func fetchData() {
    network.fetchGuidelineData()
      .subscribe(onNext: { [weak self] response in
        // Safely unwrap and use the first item from the response body
        if let firstItem = response.body.first {
          self?.title.accept(firstItem.ynaTtl ?? "No Title")
          self?.writerName.accept(firstItem.ynaYmd ?? "No Date")
        } else {
          // Handle case where response body is empty
          self?.title.accept("No Title")
          self?.writerName.accept("No Date")
        }
      }, onError: { error in
        // Handle error
        print("Error: \(error)")
        self.title.accept("Error fetching data")
        self.writerName.accept("N/A")
      })
      .disposed(by: disposeBag)
  }
}
