//
//  CardDetails+CoreDataProperties.swift
//  
//
//  Created by Arav Khandelwal on 25/07/24.
//
//

import Foundation
import CoreData


extension CardDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardDetails> {
        return NSFetchRequest<CardDetails>(entityName: "CardDetails")
    }

    @NSManaged public var imageURL: String
    @NSManaged public var age: Int32
    @NSManaged public var fullName: String
    @NSManaged public var fullAddress: String
    @NSManaged public var idValue: String
    @NSManaged public var status: String

}
