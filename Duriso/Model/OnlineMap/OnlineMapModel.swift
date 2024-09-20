//
//  OnlineMapModel.swift
//  Duriso
//
//  Created by 이주희 on 9/4/24.
//

import Foundation

// MARK: - AED Model
/// AED 데이터를 나타내는 구조체, null 값 허용
struct Aed: Codable {
  let serialNumber: String
  let address: String?
  let location: String? // 선택적으로 변경
  let adminName: String?
  let adminNumber: String?
  let managementAgency: String?
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
  
  // 다양한 타입의 serialNumber를 처리하기 위해 커스텀 디코딩 구현
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    // serialNumber가 String 또는 Int일 수 있는 상황 처리
    if let serialNumberInt = try? container.decode(Int.self, forKey: .serialNumber) {
      serialNumber = String(serialNumberInt)
    } else {
      serialNumber = try container.decode(String.self, forKey: .serialNumber)
    }
    
    address = try container.decodeIfPresent(String.self, forKey: .address)
    location = try container.decodeIfPresent(String.self, forKey: .location)
    adminName = try container.decodeIfPresent(String.self, forKey: .adminName)
    adminNumber = try container.decodeIfPresent(String.self, forKey: .adminNumber)
    managementAgency = try container.decodeIfPresent(String.self, forKey: .managementAgency)
    longitude = try container.decode(Double.self, forKey: .longitude)
    latitude = try container.decode(Double.self, forKey: .latitude)
  }
}

// MARK: - AED Response
/// AED 데이터를 담은 응답 구조체
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

// MARK: - EmergencyReport Model
/// 긴급 제보 데이터를 나타내는 구조체
struct EmergencyReport {
  let id: String
  let name: String
  let address: String
  let longitude: Double
  let latitude: Double
}

// MARK: - Shelter Model
/// 대피소 데이터를 나타내는 구조체
// MARK: - Shelter Model
struct Shelter: Codable {
    let shelterName: String?
    let address: String?
    let latitude: Double
    let longitude: Double
    let shelterTypeName: String?
    let shelterSerialNumber: String?

    enum CodingKeys: String, CodingKey {
        case shelterName = "REARE_NM"
        case address = "RONA_DADDR"
        case latitude = "LAT"
        case longitude = "LOT"
        case shelterTypeName = "SHLT_SE_NM"
        case shelterSerialNumber = "MNG_SN"
    }

    // 커스텀 파싱 로직 추가
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 문자열 필드들은 nil이 허용되기 때문에 그냥 decodeIfPresent로 처리
        shelterName = try container.decodeIfPresent(String.self, forKey: .shelterName)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        shelterTypeName = try container.decodeIfPresent(String.self, forKey: .shelterTypeName)
        shelterSerialNumber = try container.decodeIfPresent(String.self, forKey: .shelterSerialNumber)

        // Double 타입의 latitude, longitude는 잘못된 형식이 들어올 경우 기본값을 할당하도록 처리
        if let latitudeString = try? container.decode(String.self, forKey: .latitude) {
            latitude = Double(latitudeString) ?? 0.0 // 문자열을 Double로 변환, 실패시 0.0 할당
        } else {
            latitude = try container.decode(Double.self, forKey: .latitude) // 정상이면 그대로 할당
        }

        if let longitudeString = try? container.decode(String.self, forKey: .longitude) {
            longitude = Double(longitudeString) ?? 0.0
        } else {
            longitude = try container.decode(Double.self, forKey: .longitude)
        }
    }
}

// MARK: - Shelter Response
/// 대피소 데이터를 담은 응답 구조체
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
