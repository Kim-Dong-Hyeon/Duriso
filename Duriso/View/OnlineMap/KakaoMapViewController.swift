//
//  KakaoMapViewController.swift
//  Duriso
//
//  Created by 이주희 on 9/1/24.
//

import UIKit
import RxCocoa
import RxSwift
import KakaoMapsSDK

class KakaoMapViewController: UIViewController, MapControllerDelegate {
  
  var mapContainer: KMViewContainer?
  var mapController: KMController?
  private let disposeBag = DisposeBag()
  var viewModel: PoiViewModel = PoiViewModel.shared
  var currentLocationMarker: Poi?
  
  override func loadView() {
    if mapContainer == nil {
      let kmViewContainer = KMViewContainer(frame: UIScreen.main.bounds)
      self.view = kmViewContainer
      self.mapContainer = kmViewContainer
    } else {
      print("Reusing existing mapContainer")
      self.view = mapContainer
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let mapContainer = mapContainer {
      mapController = KMController(viewContainer: mapContainer)
      mapController?.delegate = self
      mapController?.prepareEngine()
      mapController?.activateEngine()
    }
    
    guard let mapController = mapController else {
      print("Error: mapController is nil")
      return
    }
    
    print("mapController initialized successfully")
    
    viewModel.setupPoiData()
    viewModel.bindPoiData(to: mapController)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mapController?.activateEngine()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mapController?.pauseEngine()
  }
  
  func authenticationSucceeded() {
    mapController?.activateEngine()
  }
  
  func authenticationFailed(_ errorCode: Int, desc: String) {
    print("Error code: \(errorCode), description: \(desc)")
  }
  
  func addViews() {
    guard let mapController = mapController else { return }
    
    // 이미 mapview가 추가되어 있는지 확인
    if mapController.getView("mapview") != nil {
      print("mapview already added.")
      return
    }
    
    let defaultPosition = MapPoint(longitude: 126.977969, latitude: 37.566535) // 서울시청 좌표
    let mapviewInfo = MapviewInfo(
      viewName: "mapview",
      viewInfoName: "map",
      defaultPosition: defaultPosition,
      defaultLevel: 17
    )
    mapController.addView(mapviewInfo)
  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    guard let mapController = mapController else {
      print("Error: mapController is nil after addViewSucceeded")
      return
    }
    
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil after addViewSucceeded")
      return
    }
    
    print("mapView initialized successfully after addViewSucceeded")
    goToCurrentLocation()
    
    // 지도 엔진이 준비된 후에 레이어 생성
    updatePOILayers()
    
    // POI 데이터 설정 및 바인딩
    viewModel.setupPoiData()
    viewModel.bindPoiData(to: mapController)
  }
  
  func addViewFailed(_ viewName: String, viewInfoName: String) {
    print("Error: Failed to add view \(viewName)")
  }
  
  func updatePOILayers() {
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil in updatePOILayers")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    
    // 레이어 제거
    let layerIDs = ["shelterLayer", "aedLayer", "emergencyReportLayer"]
    for layerID in layerIDs {
      if let existingLayer = labelManager.getLabelLayer(layerID: layerID) {
        existingLayer.clearAllItems()
        labelManager.removeLabelLayer(layerID: layerID)
        print("\(layerID) layer removed successfully.")
      }
    }
    
    // 레이어 생성
    createLabelLayer()
  }
  
  func goToCurrentLocation() {
    // 현재 위치 정보를 가져옴
    if let currentLocation = LocationManager.shared.currentLocation {
      let latitude = currentLocation.coordinate.latitude
      let longitude = currentLocation.coordinate.longitude
      
      // 현재 위치 마커를 업데이트
      updateCurrentLocation(latitude: latitude, longitude: longitude)
      
      // 카메라를 현재 위치로 이동
      moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
      
    } else {
      print("Current location is not available.")
    }
    
  }
  func createLabelLayer() {
    print("createLabelLayer called")
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil in createLabelLayer")
      return
    }
    let labelManager = mapView.getLabelManager()
    
    // 레이어 ID 목록
    let layerIDs = ["shelterLayer", "aedLayer", "emergencyReportLayer"]
    
    // 기존 레이어 제거
    for layerID in layerIDs {
      if let existingLayer = labelManager.getLabelLayer(layerID: layerID) {
        existingLayer.clearAllItems()
        labelManager.removeLabelLayer(layerID: layerID)
        print("\(layerID) layer removed successfully.")
      }
    }
    
    // 새 레이어 생성
    for (index, layerID) in layerIDs.enumerated() {
      let zOrder = 20000 + index
      createLabelLayer(withID: layerID, zOrder: zOrder, labelManager: labelManager)
    }
  }
  
  private func createLabelLayer(withID layerID: String, zOrder: Int, labelManager: LabelManager) {
    let labelLayer = LabelLayerOptions(
      layerID: layerID,
      competitionType: .none,
      competitionUnit: .symbolFirst,
      orderType: .rank,
      zOrder: zOrder
    )
    if let layerResult = labelManager.addLabelLayer(option: labelLayer) {
      print("\(layerID) label layer created successfully: \(layerResult)")
    } else {
      print("Failed to create \(layerID) label layer.")
    }
  }
  
  func updateCurrentLocation(latitude: Double, longitude: Double) {
    let currentPosition = MapPoint(longitude: longitude, latitude: latitude)
    
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let manager = mapView.getLabelManager()
    
    if currentLocationMarker == nil {
      print("Creating new current location marker")
      
      let iconStyle = PoiIconStyle(symbol: UIImage(named: "map_ico_marker.png"))
      let poiStyle = PoiStyle(
        styleID: "currentLocationStyle",
        styles: [PerLevelPoiStyle(iconStyle: iconStyle, level: 0)]
      )
      manager.addPoiStyle(poiStyle)
      print("POI style added")
      
      let layerOptions = LabelLayerOptions(
        layerID: "default",
        competitionType: .none,
        competitionUnit: .symbolFirst,
        orderType: .rank,
        zOrder: 1000
      )
      let layer = manager.getLabelLayer(layerID: "default")
      ?? manager.addLabelLayer(option: layerOptions)
      
      let poiOption = PoiOptions(styleID: "currentLocationStyle")
      
      currentLocationMarker = layer?.addPoi(option: poiOption, at: currentPosition)
//      print("POI added at position: (\(latitude), \(longitude))")
    } else {
      print("Updating current location marker position")
      currentLocationMarker?.position = currentPosition
    }
    
    currentLocationMarker?.show()
    print("Current location marker shown")
    
    moveCameraToCurrentLocation(latitude: latitude, longitude: longitude)
  }
  
  func moveCameraToCurrentLocation(latitude: Double, longitude: Double, zoomLevel: Int = 17) {
    let currentPosition = MapPoint(longitude: longitude, latitude: latitude)
    guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
    
    // 현재 위치로 카메라 이동
    let cameraUpdate = CameraUpdate.make(
      target: currentPosition,
      zoomLevel: zoomLevel,
      mapView: mapView
    )
    mapView.moveCamera(cameraUpdate)
    print("Camera moved to current position")
  }
}
