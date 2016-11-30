//
//  Conversation+CoreDataProperties.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation");
    }

    @NSManaged public var lastMessageTime: NSDate?
    @NSManaged public var message: NSSet?
    @NSManaged public var participants: NSSet?

}

// MARK: Generated accessors for message
extension Conversation {

    @objc(addMessageObject:)
    @NSManaged public func addToMessage(_ value: Message)

    @objc(removeMessageObject:)
    @NSManaged public func removeFromMessage(_ value: Message)

    @objc(addMessage:)
    @NSManaged public func addToMessage(_ values: NSSet)

    @objc(removeMessage:)
    @NSManaged public func removeFromMessage(_ values: NSSet)

}

// MARK: Generated accessors for participants
extension Conversation {

    @objc(addParticipantsObject:)
    @NSManaged public func addToParticipants(_ value: Contact)

    @objc(removeParticipantsObject:)
    @NSManaged public func removeFromParticipants(_ value: Contact)

    @objc(addParticipants:)
    @NSManaged public func addToParticipants(_ values: NSSet)

    @objc(removeParticipants:)
    @NSManaged public func removeFromParticipants(_ values: NSSet)

}
