//
//  LocationModel.swift
//  Duriso
//
//  Created by 김동현 on 9/13/24.
//

//import Foundation
import CoreLocation
import UIKit

enum LocationAccuracyState {
  case unknown
  case reducedAccuracy
  case fullAccuracy
}

struct LocationModel {
  var coordinate: CLLocationCoordinate2D
  var accuracy: LocationAccuracyState
}

struct MapSnapshot {
  let image: UIImage
}
