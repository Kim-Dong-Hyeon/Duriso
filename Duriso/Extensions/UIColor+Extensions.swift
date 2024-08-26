//
//  UIColor+Extensions.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import UIKit

extension UIColor {
  convenience init(hexCode: String, alpha: CGFloat = 1.0) {
    var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
    
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    
    assert(hexFormatted.count == 6, "Invalid hex code used.")
    
    var rgbValue: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }
  
  static let colors: [String: String] = [
    "CBlue" : "#0B7199",
    "CLightBlue" : "#A7C5D1",
    "CRed" : "#EB362A",
    "CYellow" : "#F0A22D",
    "CGreen" : "#0B9966",
    "CBlack" : "#231F20",
    "CWhite" : "#EAEBED"
  ]
  
  static func color(named name: String) -> UIColor? {
    guard let hexCode = colors[name] else { return nil }
    return UIColor(hexCode: hexCode)
  }
  
  static var CBlue: UIColor { return color(named: "CBlue")! }
  static var CLightBlue: UIColor { return color(named: "CLightBlue")! }
  static var CRed: UIColor { return color(named: "CRed")! }
  static var CYellow: UIColor { return color(named: "CYellow")! }
  static var CGreen: UIColor { return color(named: "CGreen")! }
  static var CBlack: UIColor { return color(named: "CBlack")! }
  static var CWhite: UIColor { return color(named: "CWhite")! }
}
