//
//  FirebaseModel.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 1/12/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: FIRDatabaseReference, context: NSManagedObjectContext)
}

extension Contact : FirebaseModel {
    
    static func new(forPhoneNumber phoneNumberVal: String, rootRef: FIRDatabaseReference, inContext context: NSManagedObjectContext) -> Contact {
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
        let phoneNumber = NSEntityDescription.insertNewObject(forEntityName: "PhoneNumber", into: context) as! PhoneNumber
        
        phoneNumber.contact = contact
        phoneNumber.registered = true
        phoneNumber.value = phoneNumberVal
        contact.getContactID(phoneNumber: phoneNumberVal, rootRef: rootRef, context: context)
        return contact
        
    }
    
    static func existing(withPhoneNumber phoneNumber: String, rootRef: FIRDatabaseReference, inContext context: NSManagedObjectContext) -> Contact? {
        let request : NSFetchRequest<PhoneNumber> = NSFetchRequest(entityName: "PhoneNumber")
        request.predicate = NSPredicate(format: "value=%@", phoneNumber)
        do {
            if let results = try context.fetch(request) as? [PhoneNumber], results.count > 0 {
                let contact = results.first?.contact
                if contact?.storageID == nil {
                    contact?.getContactID(phoneNumber: phoneNumber, rootRef: rootRef, context: context)
                }
                return contact
            }
        } catch {
            print("Error in Contact#existing...\(error)")
        }
        return nil
    }
    
    func getContactID(phoneNumber: String, rootRef: FIRDatabaseReference, context: NSManagedObjectContext) {
        rootRef.child("users").queryOrdered(byChild: "phoneNumber").queryEnding(atValue: phoneNumber).observeSingleEvent(of: .value, with:
            {
                snapshot in
                guard let user = snapshot.value as? NSDictionary else { return }
                let uid = user.allKeys.first as? String
                context.perform {
                    self.storageID = uid
                    do {
                        try context.save()
                    } catch {
                        print("Error saving to context extension Contact#getContactID... ")
                    }
                }
        })
    }
    
    func upload(rootRef: FIRDatabaseReference, context: NSManagedObjectContext) {
        guard let phoneNumbers = phoneNumbers?.allObjects as? [PhoneNumber] else { return }
        for number in phoneNumbers {
            rootRef.child("users")
            .queryOrdered(byChild: "phoneNumber")
            .queryEqual(toValue: number.value)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                guard let snap = snapshot.value as? NSDictionary else { return }
                let uid = snap.allKeys.first as? String
                self.storageID = uid
                number.registered = true
                context.perform {
                    do {
                        try context.save()
                    } catch {
                        print("Error saving context when importing phoneNumber...\(error)")
                    }
                    self.observeStatus(rootRef: rootRef, context: context)
                }
            })
        }
    }
    
    func observeStatus(rootRef: FIRDatabaseReference, context: NSManagedObjectContext) {
        print("============================================")
        print("hit extension Contacts#observeStatus ....")
        print("============================================")

        rootRef.child("users").child(storageID!).child("status").observe(.value, with: {
            snapshot in
            guard let status = snapshot.value as? String else { return }
            context.perform {
                self.status = status
                do {
                    try context.save()
                } catch {
                    print("Error saving, line 49 in FirebaseModel...\(error)")
                }
            }
        })
    }
    
}

extension Conversation : FirebaseModel {
    
    func observeMessages(rootRef: FIRDatabaseReference, context: NSManagedObjectContext) {
        guard let storageID = storageID else { return }
        let lastFetch = lastMessage?.timestamp?.timeIntervalSince1970 ?? 0
        
        rootRef.child("conversations").child(storageID).child("messages").queryOrderedByKey().queryStarting(atValue: String(lastFetch * 100000)).observe(.childAdded, with: {
            snapshot in
            guard let timeInterval = Double(snapshot.key) else { return }
            guard let snapshot = snapshot.value as? NSDictionary else { return }
            context.perform {
                guard let phoneNumber = snapshot["sender"] as? String, phoneNumber != FirebaseService.currentPhoneNumber else { return }
                guard let recievedMessage = snapshot["message"] as? String else { return }
                let date = NSDate(timeIntervalSince1970: timeInterval/100000)
                
                guard let messageObject = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else { return }
                messageObject.text = recievedMessage
                messageObject.timestamp = date
                messageObject.sender = Contact.existing(withPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context)
                messageObject.conversation = self
                do {
                    try context.save()
                } catch { print( "Error saving in extension Conversation#observeMessages...\(error)" ) }
            }
        })
    }
    
    static func new(forStorageId storageId: String, rootRef: FIRDatabaseReference, inContext context: NSManagedObjectContext) -> Conversation {
        let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as! Conversation
        conversation.storageID = storageId
        rootRef.child("conversations").child(storageId).child("meta").observeSingleEvent(of: .value, with: {
            snapshot in
            guard let data = snapshot.value as? NSDictionary else { return }
            guard let participantsDict = data["participants"] as? NSMutableDictionary else { return }
            
            participantsDict.removeObject(forKey: FirebaseService.currentPhoneNumber!)
            let participants = participantsDict.allKeys.map{
                (phoneNumber: Any) -> Contact in
                let phoneNumber = phoneNumber as! String
                return Contact.existing(withPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context) ?? Contact.new(forPhoneNumber: phoneNumber, rootRef: rootRef, inContext: context)
            }
            let name = data["name"] as? String
            do {
                conversation.participants = NSSet(array: participants)
                conversation.name = name
                try context.save()
            } catch { print("Error saving in extension Conversation#new....\(error)") }
        })
        return conversation
    }
    
    static func existing(withStorageId storageID: String, inContext context: NSManagedObjectContext) -> Conversation? {
        let request : NSFetchRequest<Conversation> = NSFetchRequest(entityName: "Conversation")
        request.predicate = NSPredicate(format: "storageID=%@", storageID)
        do {
            if let results = try context.fetch(request) as? [Conversation], results.count > 0 {
                if let conversation = results.first {
                    return conversation
                }
            }
        } catch {
            print("Error returning existing conversations in extension Conversation#existing...\(error)")
        }
        return nil
    }
    
    func upload(rootRef: FIRDatabaseReference, context: NSManagedObjectContext) {
        guard storageID == nil else { return }
        let ref = rootRef.child("conversations").childByAutoId()
        storageID = ref.key
        var data: Dictionary<String,AnyObject> = [
            "id" : ref.key as AnyObject
        ]
        guard let participants = participants?.allObjects as? [Contact] else { return }
        var numbers = [FirebaseService.currentPhoneNumber! : true]
        var userIds = [FIRAuth.auth()?.currentUser?.uid]
        
        for participant in participants {
            guard let phoneNumbers = participant.phoneNumbers?.allObjects as? [PhoneNumber] else { continue }
            guard let number = phoneNumbers.filter({$0.registered}).first else { continue }
            numbers[number.value!] = true
            userIds.append(participant.storageID)
        }
        data["participants"] = numbers as AnyObject?
        if let name = name {
            data["name"] = name as AnyObject?
        }
        ref.setValue(["meta":data])
        for id in userIds {
            rootRef.child("users").child(id!).child("conversations").child(ref.key).setValue(true)
        }
    }
}

extension Message : FirebaseModel {
    func upload(rootRef: FIRDatabaseReference, context: NSManagedObjectContext) {
        if conversation?.storageID == nil {
            conversation?.upload(rootRef: rootRef, context: context)
        }
        let data = [
            "message" : text!,
            "sender" : FirebaseService.currentPhoneNumber!
        ]
        guard let conversation = conversation, let timestamp = timestamp, let storageID = conversation.storageID else { return }
        let timeInterval = String(Int(timestamp.timeIntervalSince1970 * 100000))
        rootRef.child("conversations").child(storageID).child("messages").child(timeInterval).setValue(data)
    }
}





























