//
//  OfflineDataModel.swift
//  Duriso
//
//  Created by 김동현 on 9/18/24.
//

import Foundation

struct OfflineAED {
  let org: String             // 설치기관명
  let clerkTel: String        // 설치기관전화번호
  let buildAddress: String    // 설치기관주소
  let buildPlace: String      // 설치위치
  let manager: String         // 관리책임자명
  let managerTel: String      // 관리자 연락처
  let latitude: Double        // 위도
  let longitude: Double       // 경도
  let sido: String            // 시/도
  let gugun: String           // 구/군
  let mfg: String             // 제조사
  let model: String           // AED 모델명
  
  enum CodingKeys: String, CodingKey {
    case org = "org"
    case clerkTel = "clerktel"
    case buildAddress = "buildAddress"
    case buildPlace = "buildPlace"
    case manager = "manager"
    case managerTel = "managerTel"
    case latitude = "wgs84Lat"
    case longitude = "wgs84Lon"
    case sido = "sido"
    case gugun = "gugun"
    case mfg = "mfg"
    case model = "model"
  }
}

struct OfflineCivilDefenseShelter {
  let placeName: String       // 시설명
  let normalUsageType: String // 평상시활용유형
  let lotnoAddress: String    // 시설주소지번
  let ronaAddress: String     // 시설주소도로명
  let manageOrg: String       // 관리기관명
  let manageOrgTel: String    // 관리기관전화번호
  let scale: Int              // 시설규모
  let scaleUnit: String       // 규모단위
  let personCapability: Int   // 대피가능인원수
  let groundUnderground: Int  // 지상지하구분
  let latProvinces: Double    // 위도도
  let latMinutes: Double      // 위도분
  let latSeconds: Double      // 위도초
  let lonProvinces: Double    // 경도도
  let lonMinutes: Double      // 경도분
  let lonSeconds: Double      // 경도초
  let latitude: Double        // 변환위도
  let longitude: Double       // 변환경도
  
  enum CodingKeys: String, CodingKey {
    case placeName = "FCLT_NM"
    case normalUsageType = "ORTM_UTLZ_TYPE"
    case lotnoAddress = "FCLT_ADDR_LOTNO"
    case ronaAddress = "FCLT_ADDR_RONA"
    case manageOrg = "MNG_INST_NM"
    case manageOrgTel = "MNG_INST_TELNO"
    case scale = "FCLT_SCL"
    case scaleUnit = "SCL_UNIT"
    case personCapability = "SHNT_PSBLTY_NOPE"
    case groundUnderground = "GRND_UDGD_SE"
    case latProvinces = "LAT_PROVIN"
    case latMinutes = "LAT_MIN"
    case latSeconds = "LAT_SEC"
    case lonProvinces = "LOT_PROVIN"
    case lonMinutes = "LOT_MIN"
    case lonSeconds = "LOT_SEC"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    placeName = try container.decode(String.self, forKey: .placeName)
    normalUsageType = try container.decode(String.self, forKey: .normalUsageType)
    lotnoAddress = try container.decode(String.self, forKey: .lotnoAddress)
    ronaAddress = try container.decode(String.self, forKey: .ronaAddress)
    manageOrg = try container.decode(String.self, forKey: .manageOrg)
    manageOrgTel = try container.decode(String.self, forKey: .manageOrgTel)
    scale = try container.decode(Int.self, forKey: .scale)
    scaleUnit = try container.decode(String.self, forKey: .scaleUnit)
    personCapability = try container.decode(Int.self, forKey: .personCapability)
    groundUnderground = try container.decode(Int.self, forKey: .groundUnderground)
    
    latProvinces = try container.decode(Double.self, forKey: .latProvinces)
    latMinutes = try container.decode(Double.self, forKey: .latMinutes)
    latSeconds = try container.decode(Double.self, forKey: .latSeconds)
    lonProvinces = try container.decode(Double.self, forKey: .lonProvinces)
    lonMinutes = try container.decode(Double.self, forKey: .lonMinutes)
    lonSeconds = try container.decode(Double.self, forKey: .lonSeconds)
    
    // 위도, 경도 변환
    latitude = OfflineCivilDefenseShelter.convertToDecimalDegrees(degrees: latProvinces, minutes: latMinutes, seconds: latSeconds)
    longitude = OfflineCivilDefenseShelter.convertToDecimalDegrees(degrees: lonProvinces, minutes: lonMinutes, seconds: lonSeconds)
  }
  
  init(placeName: String, normalUsageType: String, lotnoAddress: String, ronaAddress: String, manageOrg: String, manageOrgTel: String, scale: Int, scaleUnit: String, personCapability: Int, groundUnderground: Int, latProvinces: Double, latMinutes: Double, latSeconds: Double, lonProvinces: Double, lonMinutes: Double, lonSeconds: Double) {
    self.placeName = placeName
    self.normalUsageType = normalUsageType
    self.lotnoAddress = lotnoAddress
    self.ronaAddress = ronaAddress
    self.manageOrg = manageOrg
    self.manageOrgTel = manageOrgTel
    self.scale = scale
    self.scaleUnit = scaleUnit
    self.personCapability = personCapability
    self.groundUnderground = groundUnderground
    self.latProvinces = latProvinces
    self.latMinutes = latMinutes
    self.latSeconds = latSeconds
    self.lonProvinces = lonProvinces
    self.lonMinutes = lonMinutes
    self.lonSeconds = lonSeconds
    
    // 위도, 경도 변환
    self.latitude = OfflineCivilDefenseShelter.convertToDecimalDegrees(degrees: latProvinces, minutes: latMinutes, seconds: latSeconds)
    self.longitude = OfflineCivilDefenseShelter.convertToDecimalDegrees(degrees: lonProvinces, minutes: lonMinutes, seconds: lonSeconds)
  }
  
  static func convertToDecimalDegrees(degrees: Double, minutes: Double, seconds: Double) -> Double {
    return degrees + (minutes / 60.0) + (seconds / 3600.0)
  }
}

struct OfflineDisasterShelter {
  let placeName: String
  let ronaAddress: String
  let shelterCode: Int
  let latitude: Double
  let longitude: Double
  
  enum CodingKeys: String, CodingKey {
    case placeName = "REARE_NM"
    case address = "RONA_DADDR"
    case shelterCode = "SHLT_SE_CD"
    case latitude = "LAT"
    case longitude = "LOT"
  }
}
