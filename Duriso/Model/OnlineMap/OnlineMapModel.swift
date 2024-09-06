//
//  File.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import Foundation

protocol PoiData {
    var id: String { get }
    var longitude: Double { get }
    var latitude: Double { get }
}

struct Aed: PoiData {
  let id: String
  let name: String
  let address: String
  let longitude: Double
  let latitude: Double
}

struct Notification: PoiData {
  let id: String
  let name: String
  let address: String
  let longitude: Double
  let latitude: Double
}

struct Shelter: PoiData {
  let id: String
  let name: String
  let address: String
  let longitude: Double
  let latitude: Double
  let capacity: Int
}

