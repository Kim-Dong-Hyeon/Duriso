//
//  OfflineMapViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import MapLibre

class OfflineMapViewController: UIViewController, MLNMapViewDelegate {
  var mapView: MLNMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView = MLNMapView(frame: view.bounds)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(mapView)
    
    mapView.delegate = self
  }
  
  // MLNMapViewDelegate method called when map has finished loading
  func mapView(_: MLNMapView, didFinishLoading _: MLNStyle) {
  }
}

@available(iOS 17.0, *)
#Preview {
  OfflineMapViewController()
}
