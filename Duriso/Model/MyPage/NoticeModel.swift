//
//  NoticeModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/13/24.
//

import Foundation

import FirebaseFirestore

struct NoticeModel {
  let title: String
  let date: Timestamp
  let detail: String
  
  init(dictionary: [String: Any]) {
    self.title = dictionary["title"] as? String ?? "제목 없음"
    self.detail = dictionary["detail"] as? String ?? "내용 없음"
    self.date = dictionary["date"] as? Timestamp ?? Timestamp(date: Date())
  }
}
