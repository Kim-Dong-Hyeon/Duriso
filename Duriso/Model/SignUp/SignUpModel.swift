//
//  SignUpModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/5/24.
//

import Foundation

struct User {
  let email: String
  let password: String
  let nickname: String
  
  init(email: String, password: String, nickname: String) {
    self.email = email
    self.password = password
    self.nickname = nickname
  }
}
