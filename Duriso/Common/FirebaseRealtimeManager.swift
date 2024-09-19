//
//  FirebaseRealtimeManager.swift
//  Duriso
//
//  Created by 김동현 on 9/18/24.
//

import Alamofire
import Firebase
import RxSwift

class FirebaseRealtimeManager {
  private let database = Database.database().reference()
  
  func fetchAEDs() -> Observable<[OfflineAED]> {
    return Observable.create { observer in
      self.database.child("aeds").observeSingleEvent(of: .value) { snapshot in
        var aeds = [OfflineAED]()
        for child in snapshot.children {
          if let snapshot = child as? DataSnapshot,
             let dict = snapshot.value as? [String: Any] {
            let aed = OfflineAED(
              org: dict["org"] as? String ?? "",
              clerkTel: dict["clerkTel"] as? String ?? "",
              buildAddress: dict["buildAddress"] as? String ?? "",
              buildPlace: dict["buildPlace"] as? String ?? "",
              manager: dict["manager"] as? String ?? "",
              managerTel: dict["managerTel"] as? String ?? "",
              latitude: dict["wgs84Lat"] as? Double ?? 0,
              longitude: dict["wgs84Lon"] as? Double ?? 0,
              sido: dict["sido"] as? String ?? "",
              gugun: dict["gugun"] as? String ?? "",
              mfg: dict["mfg"] as? String ?? "",
              model: dict["model"] as? String ?? ""
            )
            aeds.append(aed)
          }
        }
        observer.onNext(aeds)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func fetchCivildefenseShelters() -> Observable<[OfflineCivilDefenseShelter]> {
    return Observable.create { observer in
      self.database.child("civildefenseshelters").observeSingleEvent(of: .value) { snapshot in
        var shelters = [OfflineCivilDefenseShelter]()
        for child in snapshot.children {
          if let snapshot = child as? DataSnapshot,
             let dict = snapshot.value as? [String: Any] {
            let shelter = OfflineCivilDefenseShelter(
              placeName: dict["FCLT_NM"] as? String ?? "",
              normalUsageType: dict["ORTM_UTLZ_TYPE"] as? String ?? "",
              lotnoAddress: dict["FCLT_ADDR_LOTNO"] as? String ?? "",
              ronaAddress: dict["FCLT_ADDR_RONA"] as? String ?? "",
              manageOrg: dict["MNG_INST_NM"] as? String ?? "",
              manageOrgTel: dict["MNG_INST_TELNO"] as? String ?? "",
              scale: dict["FCLT_SCL"] as? Int ?? 0,
              scaleUnit: dict["SCL_UNIT"] as? String ?? "",
              personCapability: dict["SHNT_PSBLTY_NOPE"] as? Int ?? 0,
              groundUnderground: dict["GRND_UDGD_SE"] as? Int ?? 0,
              latProvinces: dict["LAT_PROVIN"] as? Double ?? 0,
              latMinutes: dict["LAT_MIN"] as? Double ?? 0,
              latSeconds: dict["LAT_SEC"] as? Double ?? 0,
              lonProvinces: dict["LOT_PROVIN"] as? Double ?? 0,
              lonMinutes: dict["LOT_MIN"] as? Double ?? 0,
              lonSeconds: dict["LOT_SEC"] as? Double ?? 0
            )
            shelters.append(shelter)
          }
        }
        observer.onNext(shelters)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  func fetchDisasterShelters() -> Observable<[OfflineDisasterShelter]> {
    return Observable.create { observer in
      self.database.child("disastershelters").observeSingleEvent(of: .value) { snapshot in
        var shelters = [OfflineDisasterShelter]()
        for child in snapshot.children {
          if let snapshot = child as? DataSnapshot,
             let dict = snapshot.value as? [String: Any] {
            let shelter = OfflineDisasterShelter(
              placeName: dict["REARE_NM"] as? String ?? "",
              ronaAddress: dict["RONA_DADDR"] as? String ?? "",
              shelterCode: dict["SHLT_SE_CD"] as? Int ?? 0,
              latitude: dict["LAT"] as? Double ?? 0,
              longitude: dict["LOT"] as? Double ?? 0
            )
            shelters.append(shelter)
          }
        }
        observer.onNext(shelters)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
