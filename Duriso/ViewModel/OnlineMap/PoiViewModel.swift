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
    
    // POI 데이터를 전달받는 메서드 (주소를 추가로 전달)
    func didTapPOI(poiID: String, latitude: Double, longitude: Double, type: BottomSheetType, address: String)
}

class PoiViewModel {
  
  static let shared = PoiViewModel()
  weak var delegate: PoiViewModelDelegate?
  
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
  
  private func createLodPoi<T>(
    items: [T],
    layerID: String,
    styleID: String,
    mapController: KMController,
    getPoiID: (T) -> String,
    getCoordinates: (T) -> (latitude: Double, longitude: Double),
    getAddress: (T) -> String?,           // 주소 추출 함수 추가
    getAdditionalInfo: (T) -> String?,
    getAdditionalInfo2: (T) -> String?,
    getAdditionalInfo3: (T) -> String?,// 추가 정보 추출 함수 추가
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
    
    var currentCLLocation: CLLocation? = nil
    if let radius = radius, let currentLocation = LocationManager.shared.currentLocation {
      currentCLLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }
    
    for item in items {
      let coordinates = getCoordinates(item)
      let poiID = getPoiID(item)
      let address = getAddress(item) ?? "Unknown Address"
      let additionalInfo1 = getAdditionalInfo(item) ?? "Unknown Info"
      let additionalInfo2 = getAdditionalInfo2(item) ?? "Unknown Info"
      let additionalInfo3 = getAdditionalInfo3(item) ?? "Unknown Info"
      
      print("poiID: \(poiID)")
      
      // POI 생성
      if let poiItem = layer.addPoi(option: PoiOptions(styleID: styleID, poiID: poiID), at: MapPoint(longitude: coordinates.longitude, latitude: coordinates.latitude)) {
        poiItem.show()
        poiItem.clickable = true
        
        // POI에 userObject 설정 - 기본 값 포함
        poiItem.userObject = NSDictionary(dictionary: [
          "poiID": poiID,
          "latitude": coordinates.latitude,
          "longitude": coordinates.longitude,
          "address": address,
          "additionalInfo": additionalInfo1
        ])
        
        _ = poiItem.addPoiTappedEventHandler(target: self) { (self) in
          return { param in
            print("POI tapped: \(param.poiItem.itemID)")
            self.poiTapped(param)
          }
        }
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
      getAddress: { $0.location },              // AED의 설치 위치를 주소로 사용
      getAdditionalInfo: { $0.adminName },
      getAdditionalInfo2: { $0.adminNumber},
      getAdditionalInfo3: { _ in nil }// 관리자 이름을 추가 정보로 사용
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
      getPoiID: { $0.shelterName },
      getCoordinates: { ($0.latitude, $0.longitude) },
      getAddress: { $0.address },               // 쉘터의 주소
      getAdditionalInfo: { $0.shelterTypeName },
      getAdditionalInfo2: { _ in nil },
      getAdditionalInfo3: { _ in nil } // 추가 정보가 없을 경우
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
        print("\(layerID) POIs 표시 완료")
      } else {
        layer.hideAllPois() // 모든 POI를 숨김
        print("\(layerID) POIs 숨김 완료")
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
    let poiItem = param.poiItem
    let poiID = poiItem.itemID
    let layerID = poiItem.layerID
    
    print("POI ID: \(poiID), Layer ID: \(layerID)")
    
    // 공통 정보: poiID, latitude, longitude 추출
    guard let userObject = poiItem.userObject as? [String: Any],
          let poiID = userObject["poiID"] as? String,
          let latitude = userObject["latitude"] as? Double,
          let longitude = userObject["longitude"] as? Double else {
      print("User object information is missing or invalid")
      return
    }
    
    // layerID에 따라 다른 함수를 호출
    switch layerID {
    case "shelterLayer":
      handleShelterPoi(poiID: poiID, latitude: latitude, longitude: longitude, userObject: userObject)
    case "aedLayer":
      handleAedPoi(poiID: poiID, latitude: latitude, longitude: longitude, userObject: userObject)
    case "emergencyReportLayer":
      handleEmergencyReportPoi(poiID: poiID, latitude: latitude, longitude: longitude, userObject: userObject)
    default:
      print("Unknown Layer ID: \(layerID)")
    }
  }
  
  func handleShelterPoi(poiID: String, latitude: Double, longitude: Double, userObject: [String: Any]) {
      // userObject에서 주소와 추가 정보를 추출
      let address = userObject["address"] as? String ?? "Unknown Address"
      let shelterType = userObject["additionalInfo"] as? String ?? "Unknown Shelter Type"
      
      // 주소와 쉘터 타입이 nil인 경우 경고 출력
      if address == "Unknown Address" || shelterType == "Unknown Shelter Type" {
          print("Warning: Some shelter information is missing")
      }
      
      print("Shelter Info: Address: \(address), Shelter Type: \(shelterType)")
      
      // delegate를 통해 POI 정보 전달 (위도/경도 대신 주소를 전달)
      delegate?.didTapPOI(poiID: poiID, latitude: latitude, longitude: longitude, type: .shelter, address: address)
  }
  
  func handleAedPoi(poiID: String, latitude: Double, longitude: Double, userObject: [String: Any]) {
    // 관리자 정보와 AED 설치 위치 추출
    if let adminName = userObject["adminName"] as? String,
       let adminNumber = userObject["adminNumber"] as? String,
       let location = userObject["location"] as? String {
      // 추가 정보를 처리하거나 저장
      print("AED Info: Admin Name: \(adminName), Admin Number: \(adminNumber), Location: \(location)")
      
      // delegate를 통해 POI 정보 전달
      delegate?.didTapPOI(poiID: poiID, latitude: latitude, longitude: longitude, type: .aed, address: location)
    } else {
      print("AED information is missing")
    }
  }
  
  func handleEmergencyReportPoi(poiID: String, latitude: Double, longitude: Double, userObject: [String: Any]) {
    // 보고서 이름과 주소 추출
    if let reportName = userObject["name"] as? String,
       let reportAddress = userObject["address"] as? String {
      // 추가 정보를 처리하거나 저장
      print("Emergency Report Info: Name: \(reportName), Address: \(reportAddress)")
      
      // delegate를 통해 POI 정보 전달
      delegate?.didTapPOI(poiID: poiID, latitude: latitude, longitude: longitude, type: .emergencyReport, address: reportAddress)
    } else {
      print("Emergency Report information is missing")
    }
  }
}
