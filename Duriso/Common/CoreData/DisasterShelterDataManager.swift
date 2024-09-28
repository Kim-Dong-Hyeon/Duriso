//
//  DisasterShelterDataManager.swift
//  Duriso
//
//  Created by 김동현 on 9/27/24.
//

import CoreData

class DisasterShelterDataManager {
  static let shared = DisasterShelterDataManager()
  
  private let context = CoreDataManager.shared.context
  
  func saveDisasterShelterData(shelterArray: [FirebaseDisasterShelter]) {
    clearData(entityName: DisasterShelters.className) // 기존 데이터를 지웁니다.
    
    for shelter in shelterArray {
      let entity = NSEntityDescription.insertNewObject(forEntityName: DisasterShelters.className, into: context) as! DisasterShelters
      entity.rnum = shelter.rnum
      entity.lat = shelter.lat
      entity.lot = shelter.lot
      entity.reareNm = shelter.reareNm
      entity.ronaDaddr = shelter.ronaDaddr
      entity.shltSeCd = shelter.shltSeCd?.stringValue
      entity.shltSeNm = shelter.shltSeNm
    }
    
    do {
      try context.save()
      print("DisasterShelter data saved to Core Data")
    } catch {
      print("Failed to save DisasterShelter data: \(error)")
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
  
  func fetchDisasterShelterData() -> [DisasterShelters] {
    let fetchRequest: NSFetchRequest<DisasterShelters> = DisasterShelters.fetchRequest()
    
    do {
      let shelterList = try context.fetch(fetchRequest)
      return shelterList
    } catch {
      print("Failed to fetch DisasterShelter data: \(error)")
      return []
    }
  }
}
