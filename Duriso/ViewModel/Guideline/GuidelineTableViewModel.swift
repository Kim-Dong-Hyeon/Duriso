//
//  GuidelineTableViewModel.swift
//  Duriso
//
//  Created by 신상규 on 8/29/24.
//

import Foundation
import RxSwift

struct GuidelineTableViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItem() {
        let products = [
            Product(imageName: "arrowshape.right", title: "국민행동요령"),
            Product(imageName: "arrowshape.right", title: "지진"),
            Product(imageName: "arrowshape.right", title: "해일"),
            Product(imageName: "arrowshape.right", title: "핵공격"),
            Product(imageName: "arrowshape.right", title: "화재발생"),
            Product(imageName: "arrowshape.right", title: "집중호우"),
            Product(imageName: "arrowshape.right", title: "태풍"),
            Product(imageName: "arrowshape.right", title: "산사태"),
            Product(imageName: "arrowshape.right", title: "폭염")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}
