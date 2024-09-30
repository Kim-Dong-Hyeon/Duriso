//
//  AEDs+CoreDataClass.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//
//

import Foundation
import CoreData

@objc(AEDs)
public class AEDs: NSManagedObject {
  public static let className: String = "AEDs"
  public enum Key {
    static let rnum = "rnum"
    static let org = "org"
    static let clerkTel = "clerkTel"
    static let buildAddress = "buildAddress"
    static let buildPlace = "buildPlace"
    static let wgs84Lat = "wgs84Lat"
    static let wgs84Lon = "wgs84Lon"
    static let sido = "sido"
    static let gugun = "gugun"
    static let manager = "manager"
    static let managerTel = "managerTel"
    static let mfg = "mfg"
    static let model = "model"
    static let monSttTme = "monSttTme"
    static let monEndTme = "monEndTme"
    static let tueSttTme = "tueSttTme"
    static let tueEndTme = "tueEndTme"
    static let wedSttTme = "wedSttTme"
    static let wedEndTme = "wedEndTme"
    static let thuSttTme = "thuSttTme"
    static let thuEndTme = "thuEndTme"
    static let friSttTme = "friSttTme"
    static let friEndTme = "friEndTme"
    static let satSttTme = "satSttTme"
    static let satEndTme = "satEndTme"
    static let sunSttTme = "sunSttTme"
    static let sunEndTme = "sunEndTme"
    static let holSttTme = "holSttTme"
    static let holEndTme = "holEndTme"
    static let sunFrtYon = "sunFrtYon"
    static let sunScdYon = "sunScdYon"
    static let sunThiYon = "sunThiYon"
    static let sunFurYon = "sunFurYon"
    static let sunFifYon = "sunFifYon"
    static let zipcode1 = "zipcode1"
    static let zipcode2 = "zipcode2"
  }
}
