//
//  PoiViewModel.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.


import RxSwift
import KakaoMapsSDK

class PoiViewModel {
  
  private let disposeBag = DisposeBag()
  
  // POI 데이터 스트림
  let shelterPois = PublishSubject<[PoiData]>()
  let aedPois = PublishSubject<[PoiData]>()
  let emergencyReportPois = PublishSubject<[PoiData]>()
  
  func setupPoiData() {
    let shelters = ShelterData.shared.setShelters().map { $0 as PoiData }
    let aeds = AedData.shared.setAeds().map { $0 as PoiData }
    let notifications = EmergencyReportData.shared.setNotifications().map { $0 as PoiData }
    
    print("Shelters:", shelters)  // 데이터를 확인하기 위해 추가
    print("Aeds:", aeds)
    print("Notifications:", notifications)
    
    shelterPois.onNext(shelters)
    aedPois.onNext(aeds)
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
      .subscribe(onNext: { [weak self] pois in
        self?.createPoiStyle(
          styleID: "shelterStyle",
          imageName: "ShelterMarker.png",
          mapController: mapController
        )
        
        self?.createPoi(
          poiData: pois,
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
  
  func createPoi(poiData: [PoiData], layerID: String, styleID: String, mapController: KMController) {
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
      let point = MapPoint(longitude: poi.longitude, latitude: poi.latitude)
      
      if let poiItem = layer.addPoi(option: options, at: point) {
        print("POI added at (\(poi.longitude), \(poi.latitude)) with ID: \(poi.id)")
        poiItem.show()
      } else {
        print("Error: Failed to add POI with ID: \(poi.id) at (\(poi.longitude), \(poi.latitude))")
      }
    }
  }
  
  func showShelters(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
  
    shelterPois
      .subscribe(onNext: { pois in
        self.createPoi(
          poiData: pois,
          layerID: "shelterLayer",
          styleID: "shelterStyle",
          mapController: mapController
        )
      })
      .disposed(by: disposeBag)
  }
  
  func hideShelters(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "shelterLayer") {
      layer.clearAllItems()  // 모든 아이템을 숨김
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
    
    aedPois
      .subscribe(onNext: { pois in
        self.createPoi(
          poiData: pois,
          layerID: "aedLayer",
          styleID: "aedStyle",
          mapController: mapController
        )
      })
      .disposed(by: disposeBag)
  }
  
  func hideAeds(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "aedLayer") {
      layer.clearAllItems()  // 모든 아이템을 숨김
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
    
    emergencyReportPois
      .subscribe(onNext: { pois in
        self.createPoi(
          poiData: pois,
          layerID: "emergencyReportLayer",
          styleID: "emergencyReportStyle",
          mapController: mapController
        )
      })
      .disposed(by: disposeBag)
  }
  
  func hideEmergencyReport(mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: "emergencyReportLayer") {
      layer.clearAllItems()  // 모든 아이템을 숨김
      print("Emergency Report POIs 숨김 완료")
    } else {
      print("Error: Failed to get layer with ID emergencyReportLayer")
    }
  }
}
