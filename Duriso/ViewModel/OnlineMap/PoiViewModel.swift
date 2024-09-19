//
//  PoiViewModel.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.

import CoreLocation

import FirebaseFirestore
import RxSwift
import KakaoMapsSDK

protocol PoiViewModelDelegate: AnyObject {
  func didTapShelter(poiID: String, shelterType: String, address: String)
  func didTapAed(poiID: String, address: String, adminName: String, adminNumber: String, managementAgency: String, location: String)
  func didTapEmergencyReport(poiID: String, address: String)
}

class PoiViewModel {
  
  static let shared = PoiViewModel()
  weak var delegate: PoiViewModelDelegate?
  private let boardFirebaseService = BoardFirebaseService()
  
  private let disposeBag = DisposeBag()
  let shelterNetworkManager = ShelterNetworkManager()
  let aedDataManager = AedDataManager()
  
  // POI 데이터 스트림
  let shelterPois = PublishSubject<[Shelter]>()
  let aedPois = PublishSubject<[Aed]>()
  let emergencyReportPois = PublishSubject<[Posts]>() // Posts로 변경
  
  /// POI 데이터를 설정하는 함수.
  /// 현재 위치를 기준으로 2km 반경의 데이터를 요청함.
  func setupPoiData() {
    guard let currentLocation = LocationManager.shared.currentLocation else {
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
    
    // AED 데이터 요청 및 처리
    if let aedResponse = aedDataManager.loadAeds() {
      let aeds = aedResponse.body
      
      // 필터링
      let filteredAeds = self.filterAedsInBoundingBox(aeds: aeds, boundingBox: boundingBox)
      self.aedPois.onNext(filteredAeds)
    } else {
      aedDataManager.fetchAllAeds()
        .subscribe(onNext: { [weak self] response in
          let aeds = response.body
          let filteredAeds = self?.filterAedsInBoundingBox(aeds: aeds, boundingBox: boundingBox)
          self?.aedPois.onNext(filteredAeds ?? []) // API에서 가져온 데이터 사용
        }, onError: { error in
          print("Error fetching AEDs: \(error)")
        }).disposed(by: disposeBag)
    }
    
    // 긴급 보고 데이터 처리
    boardFirebaseService.fetchPosts()
      .subscribe(onNext: { [weak self] posts in
        // 게시글 데이터를 처리하여 POI로 변환하거나 지도에 표시
        self?.emergencyReportPois.onNext(posts)
      }, onError: { error in
        print("Error fetching posts: \(error)")
      }).disposed(by: disposeBag)
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
  
  private func filterAedsInBoundingBox(aeds: [Aed], boundingBox: (startLat: Double, endLat: Double, startLot: Double, endLot: Double)) -> [Aed] {
    return aeds.filter { aed in
      return aed.latitude >= boundingBox.startLat && aed.latitude <= boundingBox.endLat &&
      aed.longitude >= boundingBox.startLot && aed.longitude <= boundingBox.endLot
    }
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
                createPoiFunction: self.emergencyReportCreatePoi, // 수정된 함수
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
    getAdditionalInfo3: (T) -> String?,
    getAdditionalInfo4: (T) -> String?,// 추가 정보 추출 함수 추가
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
    
    var _: CLLocation? = nil
    
    if let radius = radius, let currentLocation = LocationManager.shared.currentLocation {
      let currentCLLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
    }
    
    for item in items {
      let coordinates = getCoordinates(item)
      let poiID = getPoiID(item)
      let address = getAddress(item) ?? "제공받은 데이터가 없습니다."
      let additionalInfo1 = getAdditionalInfo(item) ?? "제공받은 데이터가 없습니다."
      let additionalInfo2 = getAdditionalInfo2(item) ?? "제공받은 데이터가 없습니다."
      let additionalInfo3 = getAdditionalInfo3(item) ?? "제공받은 데이터가 없습니다."
      let additionalInfo4 = getAdditionalInfo4(item) ?? "제공받은 데이터가 없습니다."
      
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
          "additionalInfo1": additionalInfo1,
          "additionalInfo2": additionalInfo2,
          "additionalInfo3": additionalInfo3,
          "additionalInfo4": additionalInfo4
        ])
        
        _ = poiItem.addPoiTappedEventHandler(target: self) { (self) in
          return { param in
            //            print("POI tapped: \(param.poiItem.itemID)")
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
      getAddress: { $0.address },
      getAdditionalInfo: { $0.location },
      getAdditionalInfo2: { $0.adminName },
      getAdditionalInfo3: { $0.adminNumber },
      getAdditionalInfo4: { $0.managementAgency },
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
      getPoiID: { $0.shelterName ?? "제공받은 데이터가 없습니다." },
      getCoordinates: { ($0.latitude, $0.longitude) },
      getAddress: { $0.address },               // 쉘터의 주소
      getAdditionalInfo: { $0.shelterTypeName },
      getAdditionalInfo2: { _ in nil },
      getAdditionalInfo3: { _ in nil },
      getAdditionalInfo4: { _ in nil },
      radius: 2000
    )
  }
  
  /// 긴급 제보 POI 생성 함수.
  /// - Parameters:
  ///   - reports: 긴급 제보 데이터 리스트
  ///   - layerID: 지도 레이어 ID
  ///   - styleID: 스타일 ID
  ///   - mapController: 지도 컨트롤러
  private func emergencyReportCreatePoi(posts: [Posts], layerID: String, styleID: String, mapController: KMController) {
      guard let mapView = mapController.getView("mapview") as? KakaoMap else { return }
      
      let labelManager = mapView.getLabelManager()
      guard let layer = labelManager.getLabelLayer(layerID: layerID) else {
        print("Error: Failed to get layer with ID \(layerID)")
        return
      }
      
      // 기존 아이템 제거
      layer.clearAllItems()
      
      if posts.isEmpty { return }
      
    for post in posts {
      let poiID = post.postid
      let point = MapPoint(longitude: post.postlongitude, latitude: post.postlatitude)
      let options = PoiOptions(styleID: styleID, poiID: poiID)
      
      if let poiItem = layer.addPoi(option: options, at: point) {
        poiItem.show() // POI 표시
        poiItem.clickable = true
        
        // POI에 userObject 설정 - Posts 데이터 저장
        poiItem.userObject = NSDictionary(dictionary: [
          "poiID": poiID,
          "latitude": post.postlatitude,
          "longitude": post.postlongitude,
          "address": post.dong + " " + post.gu
        ])
        
        // POI 클릭 이벤트 핸들러 추가
        _ = poiItem.addPoiTappedEventHandler(target: self) { (self) in
          return { param in
            //            print("POI tapped: \(param.poiItem.itemID)")
            self.poiTapped(param)
          }
        }
      }
    }
  }
  
  /// 공통적으로 POI 레이어의 아이템을 숨기거나 표시하는 함수.
  /// - Parameters:
  ///   - mapController: 지도 컨트롤러
  ///   - layerID: 레이어 ID
  ///   - show: 표시 여부 (true: 표시, false: 숨김)
  private func togglePoisVisibility(mapController: KMController, layerID: String, show: Bool) {
    guard let mapView = mapController.getView("mapview") as? KakaoMap else { return }
    
    let labelManager = mapView.getLabelManager()
    if let layer = labelManager.getLabelLayer(layerID: layerID) {
      if show {
        layer.showAllPois() // 모든 POI를 표시
        //        print("\(layerID) POIs 표시 완료")
      } else {
        layer.hideAllPois() // 모든 POI를 숨김
        //        print("\(layerID) POIs 숨김 완료")
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
  
  // POI 클릭 이벤트를 처리하는 함수
  func poiTapped(_ param: PoiInteractionEventParam) {
    let poiItem = param.poiItem
    guard let userObject = poiItem.userObject as? [String: Any],
          let poiID = userObject["poiID"] as? String else {
      print("Error: POI ID is nil or invalid.")
      return
    }
    
    // layerID에 따라 다른 함수를 호출
    switch param.poiItem.layerID {
    case "shelterLayer":
      handleShelterPoi(poiID: poiID, userObject: userObject)
    case "aedLayer":
      handleAedPoi(poiID: poiID, userObject: userObject)
    case "emergencyReportLayer":
      handleEmergencyReportPoi(poiID: poiID,  userObject: userObject)
    default:
      print("Error: POI style ID is unknown.")
    }
  }
  
  // AED POI를 처리하는 함수
  func handleAedPoi(poiID: String, userObject: [String: Any]) {
    
    // userObject에서 추가 정보 가져오기
    let location = userObject["additionalInfo1"] as? String ?? "제공받은 데이터가 없습니다."
    let adminName = userObject["additionalInfo2"] as? String ?? "제공받은 데이터가 없습니다."
    let adminNumber = userObject["additionalInfo3"] as? String ?? "제공받은 데이터가 없습니다."
    let managementAgency = userObject["additionalInfo4"] as? String ?? "제공받은 데이터가 없습니다."
    let address = userObject["address"] as? String ?? "제공받은 데이터가 없습니다."
    
    // delegate를 통해 AED POI 데이터 전달
    delegate?.didTapAed(poiID: poiID, address: address, adminName: adminName, adminNumber: adminNumber, managementAgency: managementAgency, location: location)
  }
  
  // Shelter POI를 처리하는 함수
  func handleShelterPoi(poiID: String, userObject: [String: Any]) {
    let address = userObject["address"] as? String ?? "제공받은 데이터가 없습니다."
    let shelterType = userObject["additionalInfo1"] as? String ?? "제공받은 데이터가 없습니다."
    
    // delegate를 통해 Shelter POI 데이터 전달
    delegate?.didTapShelter(poiID: poiID, shelterType: shelterType, address: address)
  }
  
  // Emergency Report POI를 처리하는 함수
  func handleEmergencyReportPoi(poiID: String, userObject: [String: Any]) {
    let reportName = userObject["name"] as? String ?? "제공받은 데이터가 없습니다."
    let reportAddress = userObject["address"] as? String ?? "제공받은 데이터가 없습니다."
    
    // delegate를 통해 Emergency Report POI 데이터 전달
    delegate?.didTapEmergencyReport(poiID: poiID, address: reportAddress)
  }
  
  func fetchDataForLocation(latitude: Double, longitude: Double) {
    let boundingBox = calculateBoundingBox(for: CLLocation(latitude: latitude, longitude: longitude), radius: 2000) // 2km 반경
    
    // 쉘터 데이터 요청
    shelterNetworkManager.fetchShelters(boundingBox: boundingBox)
      .subscribe(onNext: { shelterResponse in
        let shelters = shelterResponse.body
        self.shelterPois.onNext(shelters)
      }, onError: { error in
        print("Error fetching shelters: \(error)")
      }).disposed(by: disposeBag)
    
    // AED 데이터 요청 및 처리
    aedDataManager.fetchAllAeds()
      .subscribe(onNext: { [weak self] response in
        let aeds = response.body
        let filteredAeds = self?.filterAedsInBoundingBox(aeds: aeds, boundingBox: boundingBox)
        self?.aedPois.onNext(filteredAeds ?? []) // 필터링된 데이터 전달
      }, onError: { error in
        print("Error fetching AEDs: \(error)")
      }).disposed(by: disposeBag)
    
    // 긴급 보고 데이터 처리
    boardFirebaseService.fetchPosts()
      .subscribe(onNext: { [weak self] posts in
        // 게시글 데이터를 처리하여 POI로 변환하거나 지도에 표시
        self?.emergencyReportPois.onNext(posts)
      }, onError: { error in
        print("Error fetching posts: \(error)")
      }).disposed(by: disposeBag)
  }
}
