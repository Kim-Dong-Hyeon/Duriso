//
//  CivilDefenseShelters+CoreDataClass.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//
//

import Foundation
import CoreData

@objc(CivilDefenseShelters)
public class CivilDefenseShelters: NSManagedObject {
  public static let className = "CivilDefenseShelters"
  public enum Key {
    static let rnum = "rnum"
    static let fcltCd = "fcltCd"
    static let grndUdgdSe = "grndUdgdSe"
    static let ortmUtlzType = "ortmUtlzType"
    static let sggCd = "sggCd"
    static let fcltSeCd = "fcltSeCd"
    static let roadNmCd = "roadNmCd"
    static let lotMin = "lotMin"
    static let shntPsbltyNope = "shntPsbltyNope"
    static let fcltScl = "fcltScl"
    static let lotSec = "lotSec"
    static let emdNm = "emdNm"
    static let fcltAddrRona = "fcltAddrRona"
    static let seCd = "seCd"
    static let opnYn = "opnYn"
    static let latSec = "latSec"
    static let latProvin = "latProvin"
    static let latMin = "latMin"
    static let mngInstTelno = "mngInstTelno"
    static let fcltNm = "fcltNm"
    static let fcltDsgnDay = "fcltDsgnDay"
    static let mngInstNm = "mngInstNm"
    static let fcltAddrLotno = "fcltAddrLotno"
    static let sclUnit = "sclUnit"
    static let lotProvin = "lotProvin"
    static let emdCd = "emdCd"
  }
}
