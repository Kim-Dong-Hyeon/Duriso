//
//  DisasterShelters+CoreDataClass.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//
//

import Foundation
import CoreData

@objc(DisasterShelters)
public class DisasterShelters: NSManagedObject {
  public static let className = "DisasterShelters"
  public enum Key {
    static let rnum = "rnum"
    static let lat = "lat"
    static let lot = "lot"
    static let reareNm = "reareNm"
    static let ronaDaddr = "ronaDaddr"
    static let shltSeCd = "shltSeCd"
    static let shltSeNm = "shltSeNm"
  }
}
