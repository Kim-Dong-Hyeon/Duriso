//
//  CoreDataManager.swift
//  Duriso
//
//  Created by 김동현 on 9/27/24.
//

import CoreData

import RxSwift

class CoreDataManager {
  static let shared = CoreDataManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Duriso")
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unresolved error \(error)")
      }
    }
    return container
  }()
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  func fetchAEDs() -> Observable<[AEDs]> {
    return Observable.create { observer in
      let fetchRequest: NSFetchRequest<AEDs> = AEDs.fetchRequest()
      
      do {
        let results = try self.context.fetch(fetchRequest)
        observer.onNext(results)
        observer.onCompleted()
      } catch {
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
  func fetchCivilDefenseShelters() -> Observable<[CivilDefenseShelters]> {
    return Observable.create { observer in
      let fetchRequest: NSFetchRequest<CivilDefenseShelters> = CivilDefenseShelters.fetchRequest()
      
      do {
        let results = try self.context.fetch(fetchRequest)
        observer.onNext(results)
        observer.onCompleted()
      } catch {
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
  
  func fetchDisasterShelters() -> Observable<[DisasterShelters]> {
    return Observable.create { observer in
      let fetchRequest: NSFetchRequest<DisasterShelters> = DisasterShelters.fetchRequest()
      
      do {
        let results = try self.context.fetch(fetchRequest)
        observer.onNext(results)
        observer.onCompleted()
      } catch {
        observer.onError(error)
      }
      
      return Disposables.create()
    }
  }
}
