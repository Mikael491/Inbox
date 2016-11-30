//
//  ConversationBeganDelegate.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData

protocol ConversationStartedDelegate {
    func conversationStarted(withConvo convo: Conversation, inContext: NSManagedObjectContext)
}
