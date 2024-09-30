//
//  CivilDefenseShelters+CoreDataProperties.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//
//

import Foundation
import CoreData


extension CivilDefenseShelters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CivilDefenseShelters> {
        return NSFetchRequest<CivilDefenseShelters>(entityName: "CivilDefenseShelters")
    }

    @NSManaged public var emdCd: Int32
    @NSManaged public var emdNm: String?
    @NSManaged public var fcltAddrLotno: String?
    @NSManaged public var fcltAddrRona: String?
    @NSManaged public var fcltCd: String?
    @NSManaged public var fcltDsgnDay: String?
    @NSManaged public var fcltNm: String?
    @NSManaged public var fcltScl: Int32
    @NSManaged public var fcltSeCd: String?
    @NSManaged public var grndUdgdSe: String?
    @NSManaged public var latMin: Int16
    @NSManaged public var latProvin: Int16
    @NSManaged public var latSec: Int16
    @NSManaged public var lotMin: Int16
    @NSManaged public var lotProvin: Int16
    @NSManaged public var lotSec: Int16
    @NSManaged public var mngInstNm: String?
    @NSManaged public var mngInstTelno: String?
    @NSManaged public var opnYn: String?
    @NSManaged public var ortmUtlzType: String?
    @NSManaged public var rnum: Int32
    @NSManaged public var roadNmCd: String?
    @NSManaged public var sclUnit: String?
    @NSManaged public var seCd: String?
    @NSManaged public var sggCd: String?
    @NSManaged public var shntPsbltyNope: Int32
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension CivilDefenseShelters : Identifiable {

}
