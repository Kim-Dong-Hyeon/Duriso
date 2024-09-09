//
//  PoiViewModel.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.


import RxSwift
import KakaoMapsSDK

class PoiViewModel {
  
  private let disposeBag = DisposeBag()
  let shelterNetworkManager = ShelterNetworkManager()
  
  // POI 데이터 스트림
  let shelterPois = PublishSubject<[Shelter]>()
  let aedPois = PublishSubject<[PoiData]>()
  let emergencyReportPois = PublishSubject<[PoiData]>()
  
  func setupPoiData() {
    shelterNetworkManager.fetchShelters()
      .subscribe(onNext: { ShelterResponse in
        // 성공적으로 대피소 데이터를 가져왔을 때
        let shelters = ShelterResponse.body
        for shelter in shelters {
          print("Shelter Name: \(shelter.shelterName), Address: \(shelter.address)")
        }
        
        // shelterPois 스트림에 데이터 방출
        self.shelterPois.onNext(shelters)
      }, onError: { error in
        // 에러 발생 시
        print("Error fetching shelters: \(error)")
      }).disposed(by: disposeBag)
    
    let aeds = AedData.shared.setAeds().map { $0 as PoiData }
    let notifications = EmergencyReportData.shared.setNotifications().map { $0 as PoiData }
    
    aedPois.onNext(aeds)
    print("AED POIs 데이터 설정: \(aeds)")
    emergencyReportPois.onNext(notifications)
  }
  
  // POI 데이터를 바인딩하고 생성
  func bindPoiData(to mapController: KMController) {
    aedPois
      .subscribe(onNext: { [weak self] pois in
        self?.createPoiStyle(
          styleID: "aedStyle",
          imageName: "AEDMarker.png",
          mapController: mapController
        )
        
        self?.createPoi(
          poiData: pois,
          layerID: "aedLayer",
          styleID: "aedStyle",
          mapController: mapController
        )
      }, onError: { error in
        print("Error receiving AED POIs: \(error)")
      }).disposed(by: disposeBag)
    
    shelterPois
      .subscribe(onNext: { [weak self] shelters in
        self?.createPoiStyle(
          styleID: "shelterStyle",
          imageName: "ShelterMarker.png",
          mapController: mapController
        )
        
        self?.ShelterCreatePoi(
          shelters: shelters,
          layerID: "shelterLayer",
          styleID: "shelterStyle",
          mapController: mapController
        )
      }, onError: { error in
        print("Error receiving Shelter POIs: \(error)")
      }).disposed(by: disposeBag)
    
    emergencyReportPois
      .subscribe(onNext: { [weak self] pois in
        self?.createPoiStyle(
          styleID: "emergencyReportStyle",
          imageName: "NotificationMarker.png",
          mapController: mapController
        )
        
        self?.createPoi(
          poiData: pois,
          layerID: "emergencyReportLayer",
          styleID: "emergencyReportStyle",
          mapController: mapController
        )
      }, onError: { error in
        print("Error receiving Emergency Report POIs: \(error)")
      }).disposed(by: disposeBag)
  }
  
  // POI 스타일 생성
  private func createPoiStyle(styleID: String, imageName: String, mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil.")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let image = UIImage(named: imageName) {
      let icon = PoiIconStyle(
        symbol: image,
        anchorPoint: CGPoint(x: 0.5, y: 1.0)
      )
      let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
      let poiStyle = PoiStyle(styleID: styleID, styles: [perLevelStyle])
      labelManager.addPoiStyle(poiStyle)
    } else {
      print("Error: Failed to load image: \(imageName)")
    }
  }
  
  // POI 생성 (PoiData를 사용할 때)
  private func createPoi(poiData: [PoiData], layerID: String, styleID: String, mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    guard let layer = labelManager.getLabelLayer(layerID: layerID) else {
      print("Error: Failed to get layer with ID \(layerID)")
      return
    }
    
    layer.clearAllItems()
    
    if poiData.isEmpty {
      print("No POIs to add for layerID: \(layerID)")
    }
    
    for poi in poiData {
      let options = PoiOptions(styleID: styleID, poiID: poi.id)
      let point = MapPoint(longitude: poi.longitude, latitude: poi.latitude) // 경도, 위도 순서
      if let poiItem = layer.addPoi(option: options, at: point) {
        print("POI added at (\(poi.longitude), \(poi.latitude)) with ID: \(poi.id)")
        poiItem.show()
      } else {
        print("Error: Failed to add POI with ID: \(poi.id) at (\(poi.longitude), \(poi.latitude))")
      }
    }
  }
  
  private func ShelterCreatePoi(shelters: [Shelter], layerID: String, styleID: String, mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    guard let layer = labelManager.getLabelLayer(layerID: layerID) else {
      print("Error: Failed to get layer with ID \(layerID)")
      return
    }
    
    layer.clearAllItems()
    
    if shelters.isEmpty {
      print("No POIs to add for layerID: \(layerID)")
    }
    
    for shelter in shelters {
      let longitude = shelter.longitude
      let latitude = shelter.latitude
      let options = PoiOptions(styleID: styleID, poiID: shelter.shelterName)
      let point = MapPoint(longitude: longitude, latitude: latitude)
      
      if let poiItem = layer.addPoi(option: options, at: point) {
        print("POI added at (\(shelter.longitude), \(shelter.latitude)) with ID: \(shelter.shelterName)")
        poiItem.show()
      } else {
        print("Error: Failed to add POI with ID: \(shelter.shelterName) at (\(shelter.longitude), \(shelter.latitude))")
      }
    }
  }
  
  func showShelters(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "shelterLayer") {
      layer.showAllPois() // 모든 아이템을 숨김
      print("Shelter POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID shelterLayer")
    }
  }
  
  func hideShelters(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "shelterLayer") {
      layer.hideAllPois() // 모든 아이템을 숨김
      print("Shelter POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID shelterLayer")
    }
  }
  
  func showAeds(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "aedLayer") {
      layer.showAllPois()
      print("AED POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID aedLayer")
    }
  }
  
  func hideAeds(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "aedLayer") {
      layer.hideAllPois()
      print("AED POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID aedLayer")
    }
  }
  
  func showEmergencyReport(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "emergencyReportLayer") {
      layer.showAllPois()
      print("emergencyReport POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID aedLayer")
    }
  }
  
  func hideEmergencyReport(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "emergencyReportLayer") {
      layer.hideAllPois()
      print("Emergency Report POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID emergencyReportLayer")
    }
  }
}
