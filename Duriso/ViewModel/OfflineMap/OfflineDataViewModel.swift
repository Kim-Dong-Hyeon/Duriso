//
//  OfflineDataViewModel.swift
//  Duriso
//
//  Created by 김동현 on 9/18/24.
//

import Foundation

import RxCocoa
import RxSwift

class OfflineDataViewModel {
  // Output
  let aeds = BehaviorRelay<[OfflineAED]>(value: [])
  let civilDefenseShelters = BehaviorRelay<[OfflineCivilDefenseShelter]>(value: [])
  let disasterShelters = BehaviorRelay<[OfflineDisasterShelter]>(value: [])
  let filteredItems = BehaviorRelay<[Any]>(value: [])
  
  // Input
  let category = BehaviorRelay<String>(value: "제세동기")
  let city = BehaviorRelay<String>(value: "")
  let district = BehaviorRelay<String>(value: "")
  let town = BehaviorRelay<String>(value: "")
  
  private let disposeBag = DisposeBag()
  
  init() {
    loadData()
    setupFiltering()
  }
  
  private func loadData() {
    let aedData = CSVManager.readCSV(fileName: "aeds")
    let aeds = aedData.compactMap { dict -> OfflineAED? in
      guard let org = dict["org"],
            let clerkTel = dict["clerkTel"],
            let buildAddress = dict["buildAddress"],
            let buildPlace = dict["buildPlace"],
            let manager = dict["manager"],
            let managerTel = dict["managerTel"],
            let wgs84LatString = dict["wgs84Lat"],
            let wgs84LonString = dict["wgs84Lon"],
            let sido = dict["sido"],
            let gugun = dict["gugun"],
            let mfg = dict["mfg"],
            let model = dict["model"],
            let wgs84Lat = Double(wgs84LatString),
            let wgs84Lon = Double(wgs84LonString) else {
        return nil
      }
      return OfflineAED(org: org, clerkTel: clerkTel, buildAddress: buildAddress, buildPlace: buildPlace, manager: manager, managerTel: managerTel, latitude: wgs84Lat, longitude: wgs84Lon, sido: sido, gugun: gugun, mfg: mfg, model: model)
    }
    self.aeds.accept(aeds)
    
    let civilDefenseShelterData = CSVManager.readCSV(fileName: "civildefenseshelters")
    let disasterShelterData = CSVManager.readCSV(fileName: "disastershelters")
    
    let civilDefenseShelters = civilDefenseShelterData.compactMap { parseCivilDefenseShelter($0) }
    let disasterShelters = disasterShelterData.compactMap { parseDisasterShelter($0) }
    
    self.civilDefenseShelters.accept(civilDefenseShelters)
    self.disasterShelters.accept(disasterShelters)
    
    print("All data loaded. AEDs: \(aeds.count), Civil Defense Shelters: \(civilDefenseShelters.count), Disaster Shelters: \(disasterShelters.count)")
    
    // 초기 필터링 수행
    filterData(category: "제세동기", city: "", district: "", town: "")
  }
  
  private func setupFiltering() {
    Observable.combineLatest(category, city, district, town)
      .subscribe(onNext: { [weak self] category, city, district, town in
        print("Filtering with: category=\(category), city=\(city), district=\(district), town=\(town)")
        self?.filterData(category: category, city: city, district: district, town: town)
      })
      .disposed(by: disposeBag)
  }
  
  private func filterData(category: String, city: String, district: String, town: String) {
    switch category {
    case "제세동기":
      let filtered = aeds.value.filter { aed in
        (city.isEmpty || aed.sido.contains(city)) &&
        (district.isEmpty || aed.gugun.contains(district)) &&
        (town.isEmpty || aed.buildAddress.contains(town))
      }
      print("Filtered AEDs: \(filtered.count)")
      filteredItems.accept(filtered)
    case "민방위대피소":
      let filtered = civilDefenseShelters.value.filter { shelter in
        let addressComponents = extractAddressComponents(from: shelter.ronaAddress)
        return (city.isEmpty || addressComponents.city.contains(city)) &&
        (district.isEmpty || addressComponents.district.contains(district)) &&
        (town.isEmpty || addressComponents.town.contains(town))
      }
      print("Filtered Civil Defense Shelters: \(filtered.count)")
      filteredItems.accept(filtered)
    case "재난대피소":
      let filtered = disasterShelters.value.filter { shelter in
        let addressComponents = extractAddressComponents(from: shelter.ronaAddress)
        return (city.isEmpty || addressComponents.city.contains(city)) &&
        (district.isEmpty || addressComponents.district.contains(district)) &&
        (town.isEmpty || addressComponents.town.contains(town))
      }
      print("Filtered Disaster Shelters: \(filtered.count)")
      filteredItems.accept(filtered)
    default:
      print("Unknown category: \(category)")
      filteredItems.accept([])
    }
  }
  
  private func extractAddressComponents(from address: String) -> (city: String, district: String, town: String) {
    // 괄호 안의 내용 추출
    let bracketPattern = "\\(([^)]+)\\)"
    let bracketRegex = try? NSRegularExpression(pattern: bracketPattern, options: [])
    let nsRange = NSRange(address.startIndex..<address.endIndex, in: address)
    var town = ""
    
    if let match = bracketRegex?.firstMatch(in: address, options: [], range: nsRange) {
      if let townRange = Range(match.range(at: 1), in: address) {
        town = String(address[townRange]).components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? ""
      }
    }
    
    // 도시와 구/군 정보 추출
    let components = address.components(separatedBy: " ")
    var city = ""
    var district = ""
    
    if components.count >= 2 {
      city = components[0] + " " + components[1]
    }
    if components.count >= 3 {
      district = components[2]
    }
    
    return (city: city, district: district, town: town)
  }
  
  private func parseCivilDefenseShelter(_ dict: [String: String]) -> OfflineCivilDefenseShelter? {
    guard let placeName = dict["FCLT_NM"],
          let normalUsageType = dict["ORTM_UTLZ_TYPE"],
          let lotnoAddress = dict["FCLT_ADDR_LOTNO"],
          let ronaAddress = dict["FCLT_ADDR_RONA"],
          let manageOrg = dict["MNG_INST_NM"],
          let manageOrgTel = dict["MNG_INST_TELNO"],
          let scaleString = dict["FCLT_SCL"],
          let scale = Int(scaleString),
          let scaleUnit = dict["SCL_UNIT"],
          let personCapabilityString = dict["SHNT_PSBLTY_NOPE"],
          let personCapability = Int(personCapabilityString),
          let groundUndergroundString = dict["GRND_UDGD_SE"],
          let groundUnderground = Int(groundUndergroundString),
          let latProvinces = Double(dict["LAT_PROVIN"] ?? ""),
          let latMinutes = Double(dict["LAT_MIN"] ?? ""),
          let latSeconds = Double(dict["LAT_SEC"] ?? ""),
          let lonProvinces = Double(dict["LOT_PROVIN"] ?? ""),
          let lonMinutes = Double(dict["LOT_MIN"] ?? ""),
          let lonSeconds = Double(dict["LOT_SEC"] ?? "") else {
      print("Failed to parse Civil Defense Shelter row: \(dict)")
      return nil
    }
    
    return OfflineCivilDefenseShelter(
      placeName: placeName,
      normalUsageType: normalUsageType,
      lotnoAddress: lotnoAddress,
      ronaAddress: ronaAddress,
      manageOrg: manageOrg,
      manageOrgTel: manageOrgTel,
      scale: scale,
      scaleUnit: scaleUnit,
      personCapability: personCapability,
      groundUnderground: groundUnderground,
      latProvinces: latProvinces,
      latMinutes: latMinutes,
      latSeconds: latSeconds,
      lonProvinces: lonProvinces,
      lonMinutes: lonMinutes,
      lonSeconds: lonSeconds
    )
  }
  
  private func parseDisasterShelter(_ dict: [String: String]) -> OfflineDisasterShelter? {
    guard let placeName = dict["REARE_NM"] ?? dict["﻿REARE_NM"],
          let ronaAddress = dict["RONA_DADDR"],
          let shelterCode = Int(dict["SHLT_SE_CD"] ?? ""),
          let latitude = Double(dict["LAT"] ?? ""),
          let longitude = Double(dict["LOT"] ?? "") else {
      print("Failed to parse Disaster Shelter row: \(dict)")
      return nil
    }
    
    return OfflineDisasterShelter(placeName: placeName, ronaAddress: ronaAddress, shelterCode: shelterCode, latitude: latitude, longitude: longitude)
  }
}
