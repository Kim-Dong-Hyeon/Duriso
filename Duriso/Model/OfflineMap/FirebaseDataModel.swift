//
//  FirebaseDataModel.swift
//  Duriso
//
//  Created by 김동현 on 9/23/24.
//

import Foundation

struct FirebaseAED: Codable {
  let rnum: Int32
  let org: String?
  let clerkTel: CustomDecodable?
  let buildAddress: String?
  let buildPlace: CustomDecodable?
  let wgs84Lat: Double
  let wgs84Lon: Double
  let sido: String?
  let gugun: String?
  let manager: String?
  let managerTel: CustomDecodable?
  let mfg: CustomDecodable?
  let model: CustomDecodable?
  let monSttTme: CustomDecodable?
  let monEndTme: CustomDecodable?
  let tueSttTme: CustomDecodable?
  let tueEndTme: CustomDecodable?
  let wedSttTme: CustomDecodable?
  let wedEndTme: CustomDecodable?
  let thuSttTme: CustomDecodable?
  let thuEndTme: CustomDecodable?
  let friSttTme: CustomDecodable?
  let friEndTme: CustomDecodable?
  let satSttTme: CustomDecodable?
  let satEndTme: CustomDecodable?
  let sunSttTme: CustomDecodable?
  let sunEndTme: CustomDecodable?
  let holSttTme: CustomDecodable?
  let holEndTme: CustomDecodable?
  let sunFrtYon: String?
  let sunScdYon: String?
  let sunThiYon: String?
  let sunFurYon: String?
  let sunFifYon: String?
  let zipcode1: CustomDecodable?
  let zipcode2: CustomDecodable?
}

struct FirebaseCivilDefenseShelter: Codable {
  let rnum: Int32
  let fcltCd: String?
  let grndUdgdSe: CustomDecodable?
  let ortmUtlzType: String?
  let sggCd: CustomDecodable?
  let fcltSeCd: CustomDecodable?
  let roadNmCd: CustomDecodable?
  let lotMin: Int16
  let shntPsbltyNope: Int32
  let fcltScl: Int32
  let lotSec: Int16
  let emdNm: String?
  let fcltAddrRona: String?
  let seCd: CustomDecodable?
  let opnYn: String?
  let latSec: Int16
  let latProvin: Int16
  let latMin: Int16
  let mngInstTelno: CustomDecodable?
  let fcltNm: String?
  let fcltDsgnDay: CustomDecodable?
  let mngInstNm: String?
  let fcltAddrLotno: String?
  let sclUnit: String?
  let lotProvin: Int16
  let emdCd: Int32
  
  enum CodingKeys: String, CodingKey {
    case rnum = "RNUM"
    case fcltCd = "FCLT_CD"
    case grndUdgdSe = "GRND_UDGD_SE"
    case ortmUtlzType = "ORTM_UTLZ_TYPE"
    case sggCd = "SGG_CD"
    case fcltSeCd = "FCLT_SE_CD"
    case roadNmCd = "ROAD_NM_CD"
    case lotMin = "LOT_MIN"
    case shntPsbltyNope = "SHNT_PSBLTY_NOPE"
    case fcltScl = "FCLT_SCL"
    case lotSec = "LOT_SEC"
    case emdNm = "EMD_NM"
    case fcltAddrRona = "FCLT_ADDR_RONA"
    case seCd = "SE_CD"
    case opnYn = "OPN_YN"
    case latSec = "LAT_SEC"
    case latProvin = "LAT_PROVIN"
    case latMin = "LAT_MIN"
    case mngInstTelno = "MNG_INST_TELNO"
    case fcltNm = "FCLT_NM"
    case fcltDsgnDay = "FCLT_DSGN_DAY"
    case mngInstNm = "MNG_INST_NM"
    case fcltAddrLotno = "FCLT_ADDR_LOTNO"
    case sclUnit = "SCL_UNIT"
    case lotProvin = "LOT_PROVIN"
    case emdCd = "EMD_CD"
  }
  
  var latitude: Double {
    return convertToDecimalDegrees(degrees: Double(latProvin), minutes: Double(latMin), seconds: Double(latSec))
  }
  
  var longitude: Double {
    return convertToDecimalDegrees(degrees: Double(lotProvin), minutes: Double(lotMin), seconds: Double(lotSec))
  }
  
  private func convertToDecimalDegrees(degrees: Double, minutes: Double, seconds: Double) -> Double {
    return degrees + (minutes / 60.0) + (seconds / 3600.0)
  }
}

struct FirebaseDisasterShelter: Codable {
  let rnum: Int32
  let lat: Double
  let lot: Double
  let reareNm: String
  let ronaDaddr: String
  let shltSeCd: CustomDecodable?
  let shltSeNm: String
  
  enum CodingKeys: String, CodingKey {
    case rnum = "RNUM"
    case lat = "LAT"
    case lot = "LOT"
    case reareNm = "REARE_NM"
    case ronaDaddr = "RONA_DADDR"
    case shltSeCd = "SHLT_SE_CD"
    case shltSeNm = "SHLT_SE_NM"
  }
}

struct FirebaseFireEscapeMask: Codable {
  let test: String
}

struct AppVersion: Codable {
  let forceUpdateMessage: String
  let lastestVersion: String
  let minimumVersion: String
  let optionalUpdateMessage: String
  
  enum CodingKeys: String, CodingKey {
    case forceUpdateMessage = "force_update_message"
    case lastestVersion = "lastest_version"
    case minimumVersion = "minimum_version"
    case optionalUpdateMessage = "optional_update_message"
  }
}

struct DataVersion: Codable {
  let aedDataVersion: String
  let civilDefenseShelterDataVersion: String
  let disasterShelterDataVersion: String
  let fireEscapeMaskDataVersion: String
}
