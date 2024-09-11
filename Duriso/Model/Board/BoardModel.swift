//
//  BoardModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation
import UIKit


struct Category {
  let title: String
}

struct Product {
  let imageName: String
  let title: String
}

//테이블뷰
struct Post {
  let title: String
  let content: String
  let settingImage: UIImage?
  let categorys: String
  let createdAt: Date
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
struct Posts {
  let author: String //작성자
  let contents: String //내용
  let dong: String //동
  let gu: String //구
  let likescount: Int //좋아요 갯수
  let postid: Int //게시물번호
  let postlatitude: Double //위도
  let postlocation: Double //경도
  let postlongitude: Double //위도경도 합친값
  let posttime: Date //게시글 시간
  let reportcount: Int //신고 수
  let si: String //시
  let title: String //제목
}
