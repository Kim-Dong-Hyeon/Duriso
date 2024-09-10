//
//  OnlineMapModel.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import Foundation

protocol PoiData {
  var id: String { get }
  var longitude: Double { get }
  var latitude: Double { get }
}

struct Aed: Codable {
  let serialNumber: String
  let address: String
  let longitude: Double
  let latitude: Double
}

struct AedResponse: Codable {
  let header: Header
  let numOfRows: Int
  let pageNo: Int
  let totalCount: Int
  let body: [Aed]
  
  struct Header: Codable {
    let resultMsg: String
    let resultCode: String
    let errorMsg: String?
  }
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
