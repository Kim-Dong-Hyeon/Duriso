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
  
  init() {
    // 앱 시작 시 Core Data에서 데이터를 먼저 불러옵니다.
    fetchDataFromCoreData()
  }
  
  func fetchDataFromFirebase() {
    FirebaseRealtimeManager.shared.fetchAEDData()
      .subscribe(onNext: { [weak self] aedArray in
        print("Firebase에서 AED 데이터를 성공적으로 가져왔습니다: \(aedArray.count)개")
        AEDDataManager.shared.saveAEDData(aedArray: aedArray)
        self?.fetchDataFromCoreData()
      }, onError: { [weak self] error in
        print("Failed to fetch AED data from Firebase: \(error.localizedDescription)")
        self?.error.onNext("Failed to fetch data from Firebase: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
    
    FirebaseRealtimeManager.shared.fetchCivilDefenseShelterData()
      .subscribe(onNext: { [weak self] shelterArray in
        print("Firebase에서 Civil Defense Shelter 데이터를 성공적으로 가져왔습니다: \(shelterArray.count)개")
        CivilDefenseShelterDataManager.shared.saveCivilDefenseShelterData(shelterArray: shelterArray)
        self?.fetchDataFromCoreData()
      }, onError: { [weak self] error in
        print("Failed to fetch Civil Defense Shelter data from Firebase: \(error.localizedDescription)")
        self?.error.onNext("Failed to fetch data from Firebase: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
    
    FirebaseRealtimeManager.shared.fetchDisasterShelterData()
      .subscribe(onNext: { [weak self] shelterArray in
        print("Firebase에서 Disaster Shelter 데이터를 성공적으로 가져왔습니다: \(shelterArray.count)개")
        DisasterShelterDataManager.shared.saveDisasterShelterData(shelterArray: shelterArray)
        self?.fetchDataFromCoreData()
      }, onError: { [weak self] error in
        print("Failed to fetch Disaster Shelter data from Firebase: \(error.localizedDescription)")
        self?.error.onNext("Failed to fetch data from Firebase: \(error.localizedDescription)")
      })
      .disposed(by: disposeBag)
  }
  
  func fetchDataFromCoreData() {
    let AEDs = AEDDataManager.shared.fetchAEDData()
    aedData.onNext(AEDs)
    print("AED 데이터 저장 확인: \(AEDs.count)개의 데이터가 저장되었습니다.")
    
    // 데이터 샘플 출력 (최대 5개)
    for (index, aed) in AEDs.prefix(5).enumerated() {
      print("AED 샘플 데이터 \(index + 1): \(aed.rnum), \(aed.org ?? "Unknown")")
    }
    
    let CivilDefenseShelters = CivilDefenseShelterDataManager.shared.fetchCivilDefenseShelterData()
    civilDefenseShelterData.onNext(CivilDefenseShelters)
    print("Civil Defense Shelter 데이터 저장 확인: \(CivilDefenseShelters.count)개의 데이터가 저장되었습니다.")
    
    // 데이터 샘플 출력 (최대 5개)
    for (index, shelter) in CivilDefenseShelters.prefix(5).enumerated() {
      print("Civil Defense Shelter 샘플 데이터 \(index + 1): \(shelter.rnum), \(shelter.fcltNm ?? "Unknown")")
    }
    
    let DisasterShelters = DisasterShelterDataManager.shared.fetchDisasterShelterData()
    disasterShelterData.onNext(DisasterShelters)
    print("Disaster Shelter 데이터 저장 확인: \(DisasterShelters.count)개의 데이터가 저장되었습니다.")
    
    // 데이터 샘플 출력 (최대 5개)
    for (index, shelter) in DisasterShelters.prefix(5).enumerated() {
      print("Disaster Shelter 샘플 데이터 \(index + 1): \(shelter.rnum), \(shelter.reareNm ?? "Unknown")")
    }
    
    // Core Data에 데이터가 없을 경우 Firebase에서 데이터 가져오기
    if AEDs.isEmpty || CivilDefenseShelters.isEmpty || DisasterShelters.isEmpty {
      print("Core Data에 데이터가 없습니다. Firebase에서 데이터를 가져옵니다.")
      fetchDataFromFirebase()
    }
  }
}
