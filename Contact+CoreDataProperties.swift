//
//  Contact+CoreDataProperties.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact");
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
