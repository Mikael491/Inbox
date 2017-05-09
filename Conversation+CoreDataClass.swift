//
//  Conversation+CoreDataClass.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData


public class Conversation: NSManagedObject {

    var lastMessage: Message? {
        
        let request : NSFetchRequest<Message> = NSFetchRequest(entityName: "Message")
        request.predicate = NSPredicate(format: "conversation = %@", self)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        
        do {
            guard let results = try managedObjectContext?.fetch(request) as [Message]! else { return nil }
            return results.first
        } catch let error as NSError {
            print("There was an error fetching last message: \(error)")
        }
        return nil
    }
    
    func add(participant contact: Contact) {
        mutableSetValue(forKey: "participants").add(contact)
    }
    
    static func existing(directWith contact: Contact, inContext context: NSManagedObjectContext) -> Conversation? {
        
        let request : NSFetchRequest<Conversation> = NSFetchRequest(entityName: "Conversation")
        request.predicate = NSPredicate(format: "ANY participants = %@ AND participants.@count = 1", contact)
        do {
            guard let results = try context.fetch(request) as? [Conversation] else { return nil }
            return results.first
        } catch {
            
        }
        
        return nil
    }
    
    static func new(directWith contact: Contact, inContext context: NSManagedObjectContext) -> Conversation {
        let convo = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as! Conversation
        convo.add(participant: contact)
        return convo
    }
    
}
