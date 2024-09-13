//
//  BoardModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation
import UIKit

import FirebaseFirestore
import RxSwift

struct Category {
  let title: String
}

struct Product {
  let imageName: String
  let title: String
}

// 카메라 알럿
enum ActionType {
  case camera
  case library
  case cancel
}

// 신고 알럿
enum RipotAction {
  case ripot
  case cancel
}

//콜랙션뷰(스크롤) 목데이터
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

//Firebase
struct Posts: Codable {
  var author: String
  var contents: String
  var categorys: String
  var dong: String
  var gu: String
  var imageUrl: String?
  var likescount: Int
  var postid: String
  var postlocation: GeoPoint
  var posttime: Timestamp
  var reportcount: Int
  var si: String
  var title: String
  
  // 초기화
  init(author: String, contents: String, categorys: String, dong: String, gu: String, likescount: Int, postid: String, postlocation: GeoPoint, posttime: Timestamp, reportcount: Int, si: String, title: String, imageUrl: String?) {
    self.author = author
    self.contents = contents
    self.categorys = categorys
    self.dong = dong
    self.gu = gu
    self.likescount = likescount
    self.postid = postid
    self.postlocation = postlocation
    self.posttime = posttime
    self.reportcount = reportcount
    self.si = si
    self.title = title
    self.imageUrl = imageUrl
  }
  
  // Firestore에 저장할 때 사용할 데이터 딕셔너리
  func toDictionary() -> [String: Any] {
    return [
      "author": author,
      "contents": contents,
      "categorys": categorys,
      "dong": dong,
      "gu": gu,
      "imageUrl": imageUrl ?? "",
      "likescount": likescount,
      "postid": postid,
      "postlocation": postlocation,
      "posttime": posttime,
      "reportcount": reportcount,
      "si": si,
      "title": title
    ]
  }
}

struct CategoryTableModel {
  var items = PublishSubject<[Category]>()
  
  func fetchItem() {
    let category = [
      Category(title: "긴급제보"),
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
