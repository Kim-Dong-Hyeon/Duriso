//
//  AEDDataManager.swift
//  Duriso
//
//  Created by 김동현 on 9/27/24.
//

import CoreData

class AEDDataManager {
  static let shared = AEDDataManager()
  
  private let context = CoreDataManager.shared.context
  
  func saveAEDData(aedArray: [FirebaseAED]) {
    clearData(entityName: AEDs.className) // 기존 데이터를 지웁니다.
    
    for aed in aedArray {
      let entity = NSEntityDescription.insertNewObject(forEntityName: AEDs.className, into: context) as! AEDs
      entity.rnum = aed.rnum
      entity.org = aed.org
      entity.clerkTel = aed.clerkTel?.stringValue
      entity.buildPlace = aed.buildPlace?.stringValue
      entity.wgs84Lat = aed.wgs84Lat
      entity.wgs84Lon = aed.wgs84Lon
      entity.sido = aed.sido
      entity.gugun = aed.gugun
      entity.buildAddress = aed.buildAddress
      entity.manager = aed.manager
      entity.managerTel = aed.managerTel?.stringValue
      entity.mfg = aed.mfg?.stringValue
      entity.model = aed.model?.stringValue
      entity.monSttTme = aed.monSttTme?.stringValue
      entity.monEndTme = aed.monEndTme?.stringValue
      entity.tueSttTme = aed.tueSttTme?.stringValue
      entity.tueEndTme = aed.tueEndTme?.stringValue
      entity.wedSttTme = aed.wedSttTme?.stringValue
      entity.wedEndTme = aed.wedEndTme?.stringValue
      entity.thuSttTme = aed.thuSttTme?.stringValue
      entity.thuEndTme = aed.thuEndTme?.stringValue
      entity.friSttTme = aed.friSttTme?.stringValue
      entity.friEndTme = aed.friEndTme?.stringValue
      entity.satSttTme = aed.satSttTme?.stringValue
      entity.satEndTme = aed.satEndTme?.stringValue
      entity.sunSttTme = aed.sunSttTme?.stringValue
      entity.sunEndTme = aed.sunEndTme?.stringValue
      entity.holSttTme = aed.holSttTme?.stringValue
      entity.holEndTme = aed.holEndTme?.stringValue
      entity.sunFrtYon = aed.sunFrtYon
      entity.sunScdYon = aed.sunScdYon
      entity.sunThiYon = aed.sunThiYon
      entity.sunFurYon = aed.sunFurYon
      entity.sunFifYon = aed.sunFifYon
      entity.zipcode1 = aed.zipcode1?.int16Value ?? 0
      entity.zipcode2 = aed.zipcode2?.int16Value ?? 0
    }
    
    do {
      try context.save()
      print("AED data saved to Core Data")
    } catch {
      print("Failed to save AED data: \(error)")
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
  
  func fetchAEDData() -> [AEDs] {
    let fetchRequest: NSFetchRequest<AEDs> = AEDs.fetchRequest()
    
    do {
      let aedList = try context.fetch(fetchRequest)
      return aedList
    } catch {
      print("Failed to fetch AED data: \(error)")
      return []
    }
  }
}
