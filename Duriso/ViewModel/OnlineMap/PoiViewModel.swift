//
//  PoiViewModel.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.


import RxSwift
import KakaoMapsSDK

class MapViewModel {
  
  private let disposeBag = DisposeBag()
  let shelterPois = PublishSubject<[PoiData]>()
  let aedPois = PublishSubject<[PoiData]>()
  let notificationPois = PublishSubject<[PoiData]>()
  
  func setupPoiData() {
    let shelters = ShelterData.shared.setShelters().map { $0 as PoiData }
    let aeds = AedData.shared.setAeds().map { $0 as PoiData }
    let notifications = NotificationData.shared.setNotifications().map { $0 as PoiData }
    
    shelterPois.onNext(shelters)
    aedPois.onNext(aeds)
    notificationPois.onNext(notifications)
  }
  
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
    
    notificationPois
      .subscribe(onNext: { [weak self] pois in
        self?.createPoiStyle(
          styleID: "notificationStyle",
          imageName: "NotificationMarker.png",
          mapController: mapController
        )
        
        self?.createPoi(
          poiData: pois,
          layerID: "notificationLayer",
          styleID: "notificationStyle",
          mapController: mapController
        )
      }, onError: { error in
        print("Error receiving Notification POIs: \(error)")
      }).disposed(by: disposeBag)
  }
  
  private func createPoiStyle(styleID: String, imageName: String, mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil.")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    
    // 이미지 파일을 불러와서 아이콘 스타일을 설정
    if let image = UIImage(named: imageName) {
      let icon = PoiIconStyle(
        symbol: image,
        anchorPoint: CGPoint(x: 0.5, y: 1.0)
      )
      let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
      let poiStyle = PoiStyle(styleID: styleID, styles: [perLevelStyle])
      labelManager.addPoiStyle(poiStyle)
      print("POI Style created with styleID: \(styleID) and imageName: \(imageName)")
    } else {
      print("Error: Failed to load image: \(imageName)")
    }
  }
  
  private func createPoi(poiData: [PoiData],
                         layerID: String, styleID: String, mapController: KMController) {
    
    guard let mapView = mapController.getView("mapview") as? KakaoMap else { return }
    
    let labelManager = mapView.getLabelManager()
    
    guard let layer = labelManager.getLabelLayer(layerID: layerID) else { return }
    
    layer.clearAllItems()
    
    for poi in poiData {
      let options = PoiOptions(styleID: styleID, poiID: poi.id)
      let point = MapPoint(longitude: poi.longitude, latitude: poi.latitude)
      
      if let poiItem = layer.addPoi(option: options, at: point) {
        poiItem.clickable = true
        poiItem.show()
      } else {
        print("Error: Failed to add POI with ID: \(poi.id) at (\(poi.longitude), \(poi.latitude))")
      }
    }
  }
}
