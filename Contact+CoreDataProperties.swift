//
//  Contact+CoreDataProperties.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
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
    @NSManaged public var conversations: NSSet?

}

// MARK: Generated accessors for conversations
extension Contact {

    @objc(addConversationsObject:)
    @NSManaged public func addToConversations(_ value: Conversation)

    @objc(removeConversationsObject:)
    @NSManaged public func removeFromConversations(_ value: Conversation)

    @objc(addConversations:)
    @NSManaged public func addToConversations(_ values: NSSet)

    @objc(removeConversations:)
    @NSManaged public func removeFromConversations(_ values: NSSet)

}
