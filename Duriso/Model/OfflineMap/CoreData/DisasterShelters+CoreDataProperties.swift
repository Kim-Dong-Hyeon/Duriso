//
//  DisasterShelters+CoreDataProperties.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//
//

import Foundation
import CoreData


extension DisasterShelters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DisasterShelters> {
        return NSFetchRequest<DisasterShelters>(entityName: "DisasterShelters")
    }

    @NSManaged public var rnum: Int32
    @NSManaged public var reareNm: String?
    @NSManaged public var lot: Double
    @NSManaged public var ronaDaddr: String?
    @NSManaged public var shltSeNm: String?
    @NSManaged public var lat: Double
    @NSManaged public var shltSeCd: String?

}

extension DisasterShelters : Identifiable {

}
