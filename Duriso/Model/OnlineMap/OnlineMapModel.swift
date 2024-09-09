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

struct Shelter: Codable {
  let shelterName: String
  let address: String
  let latitude: Double
  let longitude: Double
  let shelterTypeName: String
  
  enum CodingKeys: String, CodingKey {
    case shelterName = "REARE_NM"
    case address = "RONA_DADDR"
    case longitude = "LOT"
    case latitude = "LAT"
    case shelterTypeName = "SHLT_SE_NM"
  }
}

