//
//  BoardModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation
import UIKit

struct TableViewModel {
  let title: String
}

struct SomeDataModel {
  enum DataModelType: String {
    case allPerson
    case atipoff
    case typhoon
    case earthquake
    case flood
    case tsunami
    case nuclear
    case fire
    case alandslide
    case hot
  }
  
  let type: DataModelType
  var name: String
  var image: UIImage?
  
  init(type: DataModelType, name: String? = nil, imageName: String? = nil) {
    self.type = type
    self.name = name ?? type.rawValue
    if let imageName = imageName {
      self.image = UIImage(systemName: imageName)
    } else {
      self.image = nil
    }
  }
  
  struct Mocks {
    static func getDataSource() -> [SomeDataModel] {
      return [
        SomeDataModel(type: .allPerson, name: "전체"),
        SomeDataModel(type: .atipoff, name: "긴급제보", imageName: "megaphone"),
        SomeDataModel(type: .typhoon, name: "태풍"),
        SomeDataModel(type: .earthquake, name: "지진"),
        SomeDataModel(type: .flood, name: "홍수"),
        SomeDataModel(type: .tsunami, name: "쓰나미"),
        SomeDataModel(type: .nuclear, name: "핵폭발"),
        SomeDataModel(type: .fire, name: "산불"),
        SomeDataModel(type: .alandslide, name: "산사태"),
        SomeDataModel(type: .hot, name: "폭염")
      ]
    }
  }
}
