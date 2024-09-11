//
//  PoiViewModel.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.

import CoreLocation

import RxSwift
import KakaoMapsSDK


protocol PoiViewModelDelegate: AnyObject {
  // POI가 탭되었을 때 호출되는 메서드
  func presentMapBottomSheet(with type: BottomSheetType)
}

class PoiViewModel {
  
  static let shared = PoiViewModel()
  weak var delegate: PoiViewModelDelegate?
  
  private var cachedShelterPois: [Shelter] = []
  
  private init() {
    print("PoiViewModel initialized: \(Unmanaged.passUnretained(self).toOpaque())")
  }
  
  private let disposeBag = DisposeBag()
  let shelterNetworkManager = ShelterNetworkManager()
  let aedNetworkManager = AedNetworkManager()
  
  // POI 데이터 스트림
  let shelterPois = PublishSubject<[Shelter]>()
  let aedPois = PublishSubject<[Aed]>()
  let emergencyReportPois = PublishSubject<[EmergencyReport]>()
  
  /// POI 데이터를 설정하는 함수.
  /// 현재 위치를 기준으로 2km 반경의 데이터를 요청함.
  func setupPoiData() {
    guard let currentLocation = LocationManager.shared.currentLocation else {
      print("Error: Current location is nil")
      return
    }
    
    let boundingBox = calculateBoundingBox(for: currentLocation, radius: 2000) // 2km 반경
    
    // 쉘터 데이터 요청
    shelterNetworkManager.fetchShelters(boundingBox: boundingBox)
      .subscribe(onNext: { shelterResponse in
        let shelters = shelterResponse.body
        self.cachedShelterPois = shelters // 데이터를 캐싱
        self.shelterPois.onNext(shelters)
      }, onError: { error in
        print("Error fetching shelters: \(error)")
      }).disposed(by: disposeBag)
    
    // AED 데이터 요청
    aedNetworkManager.fetchAeds(boundingBox: boundingBox)
      .subscribe(onNext: { aedResponse in
        let aeds = aedResponse.body
        self.aedPois.onNext(aeds)
      }, onError: { error in
        print("Error fetching AEDs: \(error)")
      }).disposed(by: disposeBag)
    
    // 긴급 보고 데이터 처리
    let emergencyReports = EmergencyReportData.shared.setEmergencyReports()
    emergencyReportPois.onNext(emergencyReports)
  }
  
  /// 주어진 위치와 반경을 바탕으로 바운딩 박스를 계산하는 함수.
  /// - Parameters:
  ///   - location: 현재 위치
  ///   - radius: 반경(미터 단위)
  /// - Returns: 시작 및 종료 위도와 경도를 포함하는 바운딩 박스
  func calculateBoundingBox(for location: CLLocation, radius: Double) -> (startLat: Double, endLat: Double, startLot: Double, endLot: Double) {
    let earthRadius = 6371000.0 // 지구 반지름 (미터 단위)
    let deltaLat = (radius / earthRadius) * (180.0 / .pi)
    let deltaLon = (radius / (earthRadius * cos(.pi * location.coordinate.latitude / 180.0))) * (180.0 / .pi)
    
    let startLat = location.coordinate.latitude - deltaLat
    let endLat = location.coordinate.latitude + deltaLat
    let startLot = location.coordinate.longitude - deltaLon
    let endLot = location.coordinate.longitude + deltaLon
    
    return (startLat, endLat, startLot, endLot)
  }
  
  /// POI 데이터를 지도에 바인딩하는 함수.
  /// - Parameter mapController: POI를 표시할 지도 컨트롤러
  func bindPoiData(to mapController: KMController) {
    bindLodPoiType(poiObservable: aedPois,
                   styleID: "aedStyle",
                   imageName: "AEDMarker.png",
                   layerID: "aedLayer",
                   createLodPoiFunction: self.aedCreateLodPoi,
                   mapController: mapController)
    
    bindLodPoiType(poiObservable: shelterPois,
                   styleID: "shelterStyle",
                   imageName: "ShelterMarker.png",
                   layerID: "shelterLayer",
                   createLodPoiFunction: self.shelterCreateLodPoi,
                   mapController: mapController)
    
    bindPoiType(poiObservable: emergencyReportPois,
                styleID: "emergencyReportStyle",
                imageName: "NotificationMarker.png",
                layerID: "emergencyReportLayer",
                createPoiFunction: self.emergencyReportCreatePoi,
                mapController: mapController)
  }
  
  /// POI 스타일과 데이터를 바인딩하는 공통 함수.
  /// - Parameters:
  ///   - poiObservable: POI 데이터 스트림
  ///   - styleID: 스타일 ID
  ///   - imageName: 마커 이미지 이름
  ///   - layerID: 지도 레이어 ID
  ///   - createLodPoiFunction: LodPoi를 생성하는 함수
  ///   - mapController: 지도 컨트롤러
  private func bindLodPoiType<T>(
    poiObservable: Observable<[T]>,
    styleID: String,
    imageName: String,
    layerID: String,
    createLodPoiFunction: @escaping ([T], String, String, KMController) -> Void,
    mapController: KMController) {
      poiObservable
        .subscribe(onNext: { [weak self] pois in
          self?.createLodPoiStyle(styleID: styleID, imageName: imageName, mapController: mapController)
          createLodPoiFunction(pois, layerID, styleID, mapController)
        }, onError: { error in
          print("Error receiving LodPOIs for \(styleID): \(error)")
        }).disposed(by: disposeBag)
    }
  
  /// POI 스타일과 데이터를 바인딩하는 공통 함수.
  /// - Parameters:
  ///   - poiObservable: POI 데이터 스트림
  ///   - styleID: 스타일 ID
  ///   - imageName: 마커 이미지 이름
  ///   - layerID: 지도 레이어 ID
  ///   - createLodPoiFunction: LodPoi를 생성하는 함수
  ///   - mapController: 지도 컨트롤러
  // LodPoi 스타일 생성
  private func createLodPoiStyle(styleID: String, imageName: String, mapController: KMController) {
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
      let lodPoiStyle = PoiStyle(styleID: styleID, styles: [perLevelStyle])
      labelManager.addPoiStyle(lodPoiStyle)
    } else {
      print("Error: Failed to load image: \(imageName)")
    }
  }
  
  /// POI 스타일과 데이터를 바인딩하는 공통 함수.
  /// - Parameters:
  ///   - poiObservable: POI 데이터 스트림
  ///   - styleID: 스타일 ID
  ///   - imageName: 마커 이미지 이름
  ///   - layerID: 지도 레이어 ID
  ///   - createPoiFunction: POI를 생성하는 함수
  ///   - mapController: 지도 컨트롤러
  private func bindPoiType<T>(poiObservable: Observable<[T]>,
                              styleID: String,
                              imageName: String,
                              layerID: String,
                              createPoiFunction: @escaping ([T], String, String, KMController) -> Void,
                              mapController: KMController) {
    poiObservable
      .subscribe(onNext: { [weak self] pois in
        self?.createPoiStyle(
          styleID: styleID,
          imageName: imageName,
          mapController: mapController
        )
        createPoiFunction(pois, layerID, styleID, mapController)
      }, onError: { error in
        print("Error receiving POIs for \(styleID): \(error)")
      }).disposed(by: disposeBag)
  }
  
  /// POI 스타일을 생성하는 함수.
  /// - Parameters:
  ///   - styleID: 스타일 ID
  ///   - imageName: 마커 이미지 이름
  ///   - mapController: 지도 컨트롤러
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
  
  /// LodPoi를 생성하는 함수.
  /// - Parameters:
  ///   - items: POI 아이템 리스트
  ///   - layerID: 레이어 ID
  ///   - styleID: 스타일 ID
  ///   - mapController: 지도 컨트롤러
  ///   - getPoiID: POI의 고유 ID를 얻는 클로저
  ///   - getCoordinates: POI의 좌표를 얻는 클로저
  ///   - radius: 반경 필터링
  private func createLodPoi<T>(
    items: [T],
    layerID: String,
    styleID: String,
    mapController: KMController,
    getPoiID: (T) -> String,
    getCoordinates: (T) -> (latitude: Double, longitude: Double),
    radius: Double? = nil
  ) {
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
    
    if items.isEmpty {
      print("No POIs to add for layerID: \(layerID)")
    }
    
    var currentCLLocation: CLLocation? = nil
    if let radius = radius, let currentLocation = LocationManager.shared.currentLocation {
      currentCLLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }
    
    for item in items {
      let coordinates = getCoordinates(item)
      let poiID = getPoiID(item)
      
      // 반경 필터링이 필요한 경우
      if let radius = radius, let currentCLLocation = currentCLLocation {
        let itemLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let distance = currentCLLocation.distance(from: itemLocation)
        if distance > radius {
          continue // 반경을 벗어난 POI는 건너뜁니다
        }
      }
      
      let options = PoiOptions(styleID: styleID, poiID: poiID)
      let point = MapPoint(longitude: coordinates.longitude, latitude: coordinates.latitude)
      
      // POI 생성
      if let poiItem = layer.addPoi(option: options, at: point) {
        poiItem.show()
        poiItem.clickable = true
        poiItem.addPoiTappedEventHandler(target: self) { (self) in
          return { param in
            print("POI tapped: \(param.poiItem.itemID)")  // 로그 추가
            self.poiTapped(param)  // POI 탭 이벤트 처리 함수 호출
          }
        }
      } else {
        print("Error: Failed to add LodPoi with ID: \(poiID) at (\(coordinates.longitude), \(coordinates.latitude))")
      }
    }
  }
  
  /// AED LodPoi 생성 함수.
  /// - Parameters:
  ///   - aeds: AED 데이터 리스트
  ///   - layerID: 지도 레이어 ID
  ///   - styleID: 스타일 ID
  ///   - mapController: 지도 컨트롤러
  private func aedCreateLodPoi(aeds: [Aed], layerID: String, styleID: String, mapController: KMController) {
    createLodPoi(
      items: aeds,
      layerID: layerID,
      styleID: styleID,
      mapController: mapController,
      getPoiID: { String($0.serialNumber) },
      getCoordinates: { ($0.latitude, $0.longitude) },
      radius: 2000
    )
  }
  
  /// 쉘터 LodPoi 생성 함수.
  /// - Parameters:
  ///   - shelters: 쉘터 데이터 리스트
  ///   - layerID: 지도 레이어 ID
  ///   - styleID: 스타일 ID
  ///   - mapController: 지도 컨트롤러
  private func shelterCreateLodPoi(shelters: [Shelter], layerID: String, styleID: String, mapController: KMController) {
    createLodPoi(
      items: shelters,
      layerID: layerID,
      styleID: styleID,
      mapController: mapController,
      getPoiID: { $0.shelterSerialNumber},
      getCoordinates: { ($0.latitude, $0.longitude) },
      radius: 2000
    )
  }
  
  /// 긴급 제보 POI 생성 함수.
  /// - Parameters:
  ///   - reports: 긴급 제보 데이터 리스트
  ///   - layerID: 지도 레이어 ID
  ///   - styleID: 스타일 ID
  ///   - mapController: 지도 컨트롤러
  private func emergencyReportCreatePoi(reports: [EmergencyReport], layerID: String, styleID: String, mapController: KMController) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    guard let layer = labelManager.getLabelLayer(layerID: layerID) else {
      print("Error: Failed to get layer with ID \(layerID)")
      return
    }
    
    // 기존 아이템 제거
    layer.clearAllItems()
    
    if reports.isEmpty {
      print("No emergency reports to add for layerID: \(layerID)")
      return
    }
    
    for report in reports {
      let poiID = report.id
      let point = MapPoint(longitude: report.longitude, latitude: report.latitude)
      let options = PoiOptions(styleID: styleID, poiID: poiID)
      
      if let poiItem = layer.addPoi(option: options, at: point) {
        poiItem.show() // POI 표시
      } else {
        print("Error: Failed to add POI with ID: \(poiID) at (\(report.longitude), \(report.latitude))")
      }
    }
  }
  
  /// 공통적으로 POI 레이어의 아이템을 숨기거나 표시하는 함수.
  /// - Parameters:
  ///   - mapController: 지도 컨트롤러
  ///   - layerID: 레이어 ID
  ///   - show: 표시 여부 (true: 표시, false: 숨김)
  private func togglePoisVisibility(mapController: KMController, layerID: String, show: Bool) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else {
      print("Error: mapView is nil")
      return
    }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: layerID) {
      if show {
        layer.showAllPois() // 모든 POI를 표시
      } else {
        layer.hideAllPois() // 모든 POI를 숨김
      }
    } else {
      print("Error: Failed to get layer with ID \(layerID)")
    }
  }
  
  /// Shelter POI 숨기기
  func hideShelters(mapController: KMController) {
    togglePoisVisibility(mapController: mapController, layerID: "shelterLayer", show: false)
  }
  
  /// Shelter POI 표시
  func showShelters(mapController: KMController) {
    togglePoisVisibility(mapController: mapController, layerID: "shelterLayer", show: true)
  }
  
  /// AED POI 숨기기
  func hideAeds(mapController: KMController) {
    togglePoisVisibility(mapController: mapController, layerID: "aedLayer", show: false)
  }
  
  /// AED POI 표시
  func showAeds(mapController: KMController) {
    togglePoisVisibility(mapController: mapController, layerID: "aedLayer", show: true)
  }
  
  /// Emergency Report POI 숨기기
  func hideEmergencyReport(mapController: KMController) {
    togglePoisVisibility(mapController: mapController, layerID: "emergencyReportLayer", show: false)
  }
  
  /// Emergency Report POI 표시
  func showEmergencyReport(mapController: KMController) {
    togglePoisVisibility(mapController: mapController, layerID: "emergencyReportLayer", show: true)
  }
  
  func poiTapped(_ param: PoiInteractionEventParam) {
    let poiID = param.poiItem.itemID
    let layerID = param.poiItem.layerID
    
    print("POI ID: \(poiID), Layer ID: \(layerID)")
    
    let bottomSheetType: BottomSheetType
    
    switch layerID {
    case "shelterLayer":
      bottomSheetType = .shelter
      if let shelter = findShelterByID(poiID) {
        print("Found shelter for MNG_SN: \(poiID)")
        
        // ShelterViewController 생성 후 먼저 데이터를 설정
        let shelterVC = ShelterViewController()
        shelterVC.shelterupdatePoiData(with: shelter)
        
        // 데이터를 설정한 후에 BottomSheet를 프레젠트
        delegate?.presentMapBottomSheet(with: bottomSheetType)
        
        // 이후 MapBottomSheetViewController에서 ShelterViewController 설정
        if let bottomSheetVC = delegate as? MapBottomSheetViewController {
          bottomSheetVC.panelContentsViewController = shelterVC
        }
      } else {
        print("No shelter found for MNG_SN: \(poiID)")
      }
    case "aedLayer":
      bottomSheetType = .aed
      // 추가 처리
    case "emergencyReportLayer":
      bottomSheetType = .emergencyReport
      // 추가 처리
    default:
      print("Unknown Layer ID: \(layerID)")
      return
    }
  }
  
  func findShelterByID(_ id: String) -> Shelter? {
    // 관리일련번호(MNG_SN)를 기준으로 찾기
    return cachedShelterPois.first { $0.shelterSerialNumber == id }
  }
}
