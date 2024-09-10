//
//  OnlineMapModel.swift
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
// MARK: - ShelterModel
struct Shelter: Codable {
  let shelterName: String
  let address: String
  let latitude: Double
  let longitude: Double
  let shelterTypeName: String
  let managementSerialNumber: String
  let shelterTypeCode: String
  
  enum CodingKeys: String, CodingKey {
    case shelterName = "REARE_NM"
    case address = "RONA_DADDR"
    case latitude = "LAT"
    case longitude = "LOT"
    case shelterTypeName = "SHLT_SE_NM"
    case managementSerialNumber = "MNG_SN"
    case shelterTypeCode = "SHLT_SE_CD"
  }
}

struct ShelterResponse: Codable {
  let header: Header
  let numOfRows: Int
  let pageNo: Int
  let totalCount: Int
  let body: [Shelter] 
  
  struct Header: Codable {
    let resultMsg: String
    let resultCode: String
    let errorMsg: String?
  }
}
