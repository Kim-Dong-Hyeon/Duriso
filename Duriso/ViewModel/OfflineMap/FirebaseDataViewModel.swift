//
//  FirebaseDataViewModel.swift
//  Duriso
//
//  Created by 김동현 on 9/24/24.
//

import Foundation

import RxSwift

class FirebaseDataViewModel {
  private let disposeBag = DisposeBag()
  
  // Observable로 데이터를 스트림 형태로 노출
  let aedData = PublishSubject<[AEDs]>()
  let civilDefenseShelterData = PublishSubject<[CivilDefenseShelters]>()
  let disasterShelterData = PublishSubject<[DisasterShelters]>()
  //  let fireEscapeMaskData = PublishSubject<FirebaseFireEscapeMask>()
  let error = PublishSubject<String>()
  
  
  func fetchDataFromFirebase() {
    FirebaseRealtimeManager.shared.fetchAEDData()
      .subscribe(onNext: { [weak self] aedArray in
        guard let self = self else { return }
        print("Firebase에서 AED 데이터를 성공적으로 가져왔습니다: \(aedArray.count)개")
        AEDDataManager.shared.saveAEDData(aedArray: aedArray)
        self.fetchDataFromCoreDataIfNeeded()
      }, onError: { [weak self] error in
        self?.error.onNext("Failed to fetch data from Firebase: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
    
    FirebaseRealtimeManager.shared.fetchCivilDefenseShelterData()
      .subscribe(onNext: { [weak self] shelterArray in
        guard let self = self else { return }
        print("Firebase에서 Civil Defense Shelter 데이터를 성공적으로 가져왔습니다: \(shelterArray.count)개")
        CivilDefenseShelterDataManager.shared.saveCivilDefenseShelterData(shelterArray: shelterArray)
        self.fetchDataFromCoreDataIfNeeded()
      }, onError: { [weak self] error in
        self?.error.onNext("Failed to fetch data from Firebase: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
    
    FirebaseRealtimeManager.shared.fetchDisasterShelterData()
      .subscribe(onNext: { [weak self] shelterArray in
        guard let self = self else { return }
        print("Firebase에서 Disaster Shelter 데이터를 성공적으로 가져왔습니다: \(shelterArray.count)개")
        DisasterShelterDataManager.shared.saveDisasterShelterData(shelterArray: shelterArray)
        self.fetchDataFromCoreDataIfNeeded()
      }, onError: { [weak self] error in
        self?.error.onNext("Failed to fetch data from Firebase: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchDataFromCoreDataIfNeeded() {
    let AEDs = AEDDataManager.shared.fetchAEDData()
    let CivilDefenseShelters = CivilDefenseShelterDataManager.shared.fetchCivilDefenseShelterData()
    let DisasterShelters = DisasterShelterDataManager.shared.fetchDisasterShelterData()
    
    if AEDs.isEmpty || CivilDefenseShelters.isEmpty || DisasterShelters.isEmpty {
      fetchDataFromCoreData()
    }
  }
  
  func fetchDataFromCoreData() {
    DispatchQueue.main.async {
      let AEDs = AEDDataManager.shared.fetchAEDData()
      self.aedData.onNext(AEDs)
      print("AED 데이터 저장 확인: \(AEDs.count)개의 데이터가 저장되었습니다.")
      
      let CivilDefenseShelters = CivilDefenseShelterDataManager.shared.fetchCivilDefenseShelterData()
      self.civilDefenseShelterData.onNext(CivilDefenseShelters)
      print("Civil Defense Shelter 데이터 저장 확인: \(CivilDefenseShelters.count)개의 데이터가 저장되었습니다.")
      
      let DisasterShelters = DisasterShelterDataManager.shared.fetchDisasterShelterData()
      self.disasterShelterData.onNext(DisasterShelters)
      print("Disaster Shelter 데이터 저장 확인: \(DisasterShelters.count)개의 데이터가 저장되었습니다.")
      
      if AEDs.isEmpty || CivilDefenseShelters.isEmpty || DisasterShelters.isEmpty {
        print("Core Data에 데이터가 없습니다. Firebase에서 데이터를 가져옵니다.")
        self.fetchDataFromFirebase()
      }
    }
  }
}
