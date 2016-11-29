//
//  Message+CoreDataProperties.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var incoming: Bool
    @NSManaged public var text: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var conversation: Conversation?

}
