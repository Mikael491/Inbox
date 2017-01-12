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
                        print("Error saving context when importing phoneNumber")
                    }
                }
            })
        }
    }
}
