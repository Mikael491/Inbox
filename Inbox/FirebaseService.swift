//
//  FirebaseService.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 1/11/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class FirebaseService {
    
    fileprivate var context : NSManagedObjectContext
    fileprivate let rootRef = FIRDatabase.database().reference(fromURL: "https://inbox-6c25d.firebaseio.com/")
    fileprivate let authData = FIRAuth.auth()
    
    fileprivate(set) static var currentPhoneNumber: String? {
        set(phoneNumber) {
            UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        }
        get {
            return UserDefaults.standard.string(forKey: "phoneNumber")!
        }
    }
    
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    func hasAuthenticated() -> Bool {
        return UserDefaults.standard.string(forKey: "phoneNumber") != nil
    }
    fileprivate func upload(model: NSManagedObject) {
        guard let model = model as? FirebaseModel else { return }
        model.upload(rootRef: rootRef, context: context)
    }
    
    func fetchAppContacts() -> [Contact] {
        do {
            let request: NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageID != nil")
            if let results = try self.context.fetch(request) as? [Contact] {
                return results
            }
            
        } catch {
            print("Error fetching app contacts in line 61 of FirebaseModel...\(error)")
            return []
        }
    }
    
    //following function is strictly for readability and cleanliness
    fileprivate func observeUserStatus(contact: Contact) {
        contact.observeStatus(rootRef: rootRef, context: context)
    }
    
    fileprivate func observeStatuses() {
        let contacts = fetchAppContacts()
        contacts.forEach(observeUserStatus)
        //TODO: fix issue of inability obtaining status of contacts on signup
    }
    
}

extension FirebaseService : RemoteStore {

    func startSyncing() {
        context.perform {
            self.observeStatuses()
        }
    }
    
    func store(insert inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        inserted.forEach { (object) in
            upload(model: object)
        }
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func signUp(phoneNumber: String, email: String, password: String, success: @escaping () -> (), error errorCallback: @escaping (String) -> ()) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (result, error) in
            if (error != nil) {
                print((error?.localizedDescription)!)
                errorCallback((error?.localizedDescription)!)
            } else {
                let newUser = [
                    "phoneNumber" : phoneNumber
                ]
                print("Result: \(result)")
                let uid = result?.uid
                FirebaseService.currentPhoneNumber = phoneNumber
                self.rootRef.child("users").child(uid!).setValue(newUser)
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (result, error) in
                    if (error != nil) {
                        errorCallback((error?.localizedDescription)!)
                    } else {
                        success()
                    }
                })
            }
        })
    }
    
}
