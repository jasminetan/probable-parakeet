//
//  CoreDataProperties.swift
//  CoreDataPhotos
//
//  Created by Jasmine Tan on 4/10/20.
//  Copyright © 2020 Jasmine Tan. All rights reserved.
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var journal: String?
    @NSManaged public var notes: String?
    @NSManaged public var photo: NSData?
    @NSManaged public var title: String?

}
