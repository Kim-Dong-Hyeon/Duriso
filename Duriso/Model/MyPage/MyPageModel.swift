//
//  MyPageModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation

struct MyPageModel {
  let title: String
  let type: ItemType
  let selected: Bool
  
  enum ItemType {
    case toggle
    case disclosure
    case version(String)
  }
}
