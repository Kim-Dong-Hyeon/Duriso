//
//  SignUpModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/5/24.
//

import Foundation

enum NicknameStatus {
  case available
  case unavailable
  case empty
}

struct User {
  let email: String
  let nickname: String
  let uuid: String
  let postcount: Int
  let reportedpostcount: Int
  
  init(email: String, nickname: String, uuid: String, postcount: Int = 0, reportedpostcount: Int = 0) {
    self.email = email
    self.nickname = nickname
    self.uuid = uuid
    self.postcount = postcount
    self.reportedpostcount = reportedpostcount
  }
}
