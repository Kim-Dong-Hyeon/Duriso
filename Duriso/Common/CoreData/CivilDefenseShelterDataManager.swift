//
//  CivilDefenseShelterDataManager.swift
//  Duriso
//
//  Created by 김동현 on 9/27/24.
//

import CoreData

class CivilDefenseShelterDataManager {
  static let shared = CivilDefenseShelterDataManager()
  
  private let context = CoreDataManager.shared.context
  
  func saveCivilDefenseShelterData(shelterArray: [FirebaseCivilDefenseShelter]) {
    clearData(entityName: CivilDefenseShelters.className) // 기존 데이터를 지웁니다.
    
    for shelter in shelterArray {
      let entity = NSEntityDescription.insertNewObject(forEntityName: CivilDefenseShelters.className, into: context) as! CivilDefenseShelters
      entity.rnum = shelter.rnum
      entity.fcltCd = shelter.fcltCd
      entity.grndUdgdSe = shelter.grndUdgdSe?.stringValue
      entity.ortmUtlzType = shelter.ortmUtlzType
      entity.sggCd = shelter.sggCd?.stringValue
      entity.fcltSeCd = shelter.fcltSeCd?.stringValue
      entity.roadNmCd = shelter.roadNmCd?.stringValue
      entity.lotMin = shelter.lotMin
      entity.shntPsbltyNope = shelter.shntPsbltyNope
      entity.fcltScl = shelter.fcltScl
      entity.lotSec = shelter.lotSec
      entity.emdNm = shelter.emdNm
      entity.fcltAddrRona = shelter.fcltAddrRona
      entity.seCd = shelter.seCd?.stringValue
      entity.opnYn = shelter.opnYn
      entity.latSec = shelter.latSec
      entity.latProvin = shelter.latProvin
      entity.latMin = shelter.latMin
      entity.mngInstTelno = shelter.mngInstTelno?.stringValue
      entity.fcltNm = shelter.fcltNm
      entity.fcltDsgnDay = shelter.fcltDsgnDay?.stringValue
      entity.mngInstNm = shelter.mngInstNm
      entity.fcltAddrLotno = shelter.fcltAddrLotno
      entity.sclUnit = shelter.sclUnit
      entity.lotProvin = shelter.lotProvin
      entity.emdCd = shelter.emdCd
      entity.latitude = shelter.latitude
      entity.longitude = shelter.longitude
    }
    
    do {
      try context.save()
      print("CivilDefenseShelter data saved to Core Data")
    } catch {
      print("Failed to save CivilDefenseShelter data: \(error)")
    }
  }
  
  private func clearData(entityName: String) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try context.execute(deleteRequest)
      try context.save()
    } catch {
      print("Failed to clear data: \(error)")
    }
  }
  
  func fetchCivilDefenseShelterData() -> [CivilDefenseShelters] {
    let fetchRequest: NSFetchRequest<CivilDefenseShelters> = CivilDefenseShelters.fetchRequest()
    
    do {
      let shelterList = try context.fetch(fetchRequest)
      return shelterList
    } catch {
      print("Failed to fetch CivilDefenseShelter data: \(error)")
      return []
    }
  }
}
