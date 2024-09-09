//
//  Font+Extensions.swift
//  Duriso
//
//  Created by 이주희 on 8/26/24.
//

import UIKit

struct Font {
  let name: String
  let size: CGFloat
  
  func font() -> UIFont? {
    return UIFont(name: name, size: size)
  }
  
}

struct CustomFont {
  static let Display: Font = Font(name: "NotoSansKR-Bold", size: 28.0)
  
  static let Head: Font = Font(name: "NotoSansKR-Bold", size: 24.0)
  static let Head2: Font = Font(name: "NotoSansKR-Bold", size: 20.0)
  static let Head3: Font = Font(name: "NotoSansKR-Bold", size: 16.0)
  static let Head4: Font = Font(name: "NotoSansKR-Bold", size: 12.0)
  
  static let Body: Font = Font(name: "NotoSansKR-Regular", size: 20.0)
  static let Body2: Font = Font(name: "NotoSansKR-Regular", size: 16.0)
  static let Body3: Font = Font(name: "NotoSansKR-Regular", size: 14.0)
  
  static let sub: Font = Font(name: "NotoSansKR-Light", size: 16.0)
  static let sub2: Font = Font(name: "NotoSansKR-Light", size: 12.0)
  
  static let Deco: Font = Font(name: "HSSaemaul", size: 32.0)
  static let Deco2: Font = Font(name: "HSSaemaul", size: 28.0)
  static let Deco3: Font = Font(name: "HSSaemaul", size: 24.0)
  static let Deco4: Font = Font(name: "HSSaemaul", size: 20.0)
  static let Deco5: Font = Font(name: "HSSaemaul", size: 18.0)
  
  static func allFonts() -> [(font: UIFont?, name: String, size: CGFloat)] {
    return [
      (Display.font(), Display.name, Display.size),
      (Head.font(), Head.name, Head.size),
      (Body.font(), Body.name, Body.size),
      (Deco.font(), Deco.name, Deco.size)
    ]
  }
}
