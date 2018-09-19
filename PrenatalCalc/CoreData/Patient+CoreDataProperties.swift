//
//  Patient+CoreDataProperties.swift
//  PrenatalCalc
//
//  Created by Leon Yannik Lopez Rojas on 9/11/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//
//

import Foundation
import CoreData


extension Patient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }

    @NSManaged public var bed: String?
    @NSManaged public var dx: String?
    @NSManaged public var file: String?
    @NSManaged public var id: String?
    @NSManaged public var lastDate: NSDate?
    @NSManaged public var lastWeight: Double
    @NSManaged public var name: String?
    @NSManaged public var things: NSData?
    @NSManaged public var weeks: String?

}
