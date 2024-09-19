//
//  BoardViewModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation

import RxSwift

struct CategoryTableViewModel {
  var items = PublishSubject<[Category]>()
  
  func fetchItem() {
    let category = [
      Category(title: "태풍"),
      Category(title: "지진"),
      Category(title: "홍수"),
      Category(title: "쓰나미"),
      Category(title: "핵폭발"),
      Category(title: "산불"),
      Category(title: "산사태"),
      Category(title: "폭염")
    ]
    
    items.onNext(category)
    items.onCompleted()
  }
}
