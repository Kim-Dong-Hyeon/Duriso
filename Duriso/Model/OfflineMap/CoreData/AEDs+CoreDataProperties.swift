//
//  AEDs+CoreDataProperties.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//
//

import Foundation
import CoreData


extension AEDs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AEDs> {
        return NSFetchRequest<AEDs>(entityName: "AEDs")
    }

    @NSManaged public var buildAddress: String?
    @NSManaged public var buildPlace: String?
    @NSManaged public var clerkTel: String?
    @NSManaged public var friEndTme: String?
    @NSManaged public var friSttTme: String?
    @NSManaged public var gugun: String?
    @NSManaged public var holEndTme: String?
    @NSManaged public var holSttTme: String?
    @NSManaged public var manager: String?
    @NSManaged public var managerTel: String?
    @NSManaged public var mfg: String?
    @NSManaged public var model: String?
    @NSManaged public var monEndTme: String?
    @NSManaged public var monSttTme: String?
    @NSManaged public var org: String?
    @NSManaged public var rnum: Int32
    @NSManaged public var satEndTme: String?
    @NSManaged public var satSttTme: String?
    @NSManaged public var sido: String?
    @NSManaged public var sunEndTme: String?
    @NSManaged public var sunFifYon: String?
    @NSManaged public var sunFrtYon: String?
    @NSManaged public var sunFurYon: String?
    @NSManaged public var sunScdYon: String?
    @NSManaged public var sunSttTme: String?
    @NSManaged public var sunThiYon: String?
    @NSManaged public var thuEndTme: String?
    @NSManaged public var thuSttTme: String?
    @NSManaged public var tueEndTme: String?
    @NSManaged public var tueSttTme: String?
    @NSManaged public var wedEndTme: String?
    @NSManaged public var wedSttTme: String?
    @NSManaged public var wgs84Lat: Double
    @NSManaged public var wgs84Lon: Double
    @NSManaged public var zipcode1: Int16
    @NSManaged public var zipcode2: Int16

}

extension AEDs : Identifiable {

}
