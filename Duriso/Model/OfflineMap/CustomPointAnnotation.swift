//
//  CustomPointAnnotation.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//

import MapLibre
import CoreLocation

class CustomPointAnnotation: MLNPointAnnotation {
  var poiType: POIType?
  
  init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, poiType: POIType?) {
    super.init()
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.poiType = poiType
  }
  
  override init() {
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
