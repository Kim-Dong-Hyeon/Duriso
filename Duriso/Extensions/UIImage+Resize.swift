//
//  UIImage+Resize.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//

import UIKit

extension UIImage {
  func resized(to size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    defer { UIGraphicsEndImageContext() }
    
    draw(in: CGRect(origin: .zero, size: size))
    
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
