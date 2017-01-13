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





























