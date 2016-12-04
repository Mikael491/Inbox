//
//  PhoneNumber+CoreDataProperties.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/4/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData


extension PhoneNumber {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneNumber> {
        return NSFetchRequest<PhoneNumber>(entityName: "PhoneNumber");
    }

    @NSManaged public var value: String?
    @NSManaged public var kind: String?
    @NSManaged public var registered: Bool
    @NSManaged public var contact: Contact?

}
