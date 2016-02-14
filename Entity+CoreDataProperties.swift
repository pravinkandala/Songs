//
//  Entity+CoreDataProperties.swift
//  Songs
//
//  Created by Pravin Kandala on 2/14/16.
//  Copyright © 2016 Pravin Kandala. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entity {

    @NSManaged var sName: String?
    @NSManaged var sAlbum: String?
    @NSManaged var sRelease: String?

}
