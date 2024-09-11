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
    let location: String
    let adminName: String?
    let adminNumber: String
    let managementAgency: String
    let longitude: Double
    let latitude: Double

    enum CodingKeys: String, CodingKey {
        case serialNumber = "SN"
        case address = "INSTL_ADDR"
        case location = "INSTL_PSTN"
        case adminName = "MNGR_NM"
        case adminNumber = "MNGR_TELNO"
        case managementAgency = "MNG_INST_NM"
        case longitude = "LOT"
        case latitude = "LAT"
    }
  
  init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         
         // Handle serialNumber being either String or Int
         if let serialNumberInt = try? container.decode(Int.self, forKey: .serialNumber) {
             serialNumber = String(serialNumberInt)
         } else {
             serialNumber = try container.decode(String.self, forKey: .serialNumber)
         }

         address = try container.decode(String.self, forKey: .address)
         location = try container.decode(String.self, forKey: .location)
         adminName = try container.decodeIfPresent(String.self, forKey: .adminName)
         adminNumber = try container.decode(String.self, forKey: .adminNumber)
         managementAgency = try container.decode(String.self, forKey: .managementAgency)
         longitude = try container.decode(Double.self, forKey: .longitude)
         latitude = try container.decode(Double.self, forKey: .latitude)
     }
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

struct EmergencyReport: PoiData {
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
