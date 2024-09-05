//
//  PoiData.swift
//  Duriso
//
//  Created by t2024-m0153 on 9/4/24.
//

import Foundation

protocol PoiData {
  var id: String { get }
  var name: String { get }
  var address: String { get }
  var longitude: Double { get }
  var latitude: Double { get }
}
