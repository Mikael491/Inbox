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
    
    private var context : NSManagedObjectContext
    fileprivate let rootRef = Firebase(url: "https://inbox-6c25d.firebaseio.com/")
    
    private var currentPhoneNumber: String? {
        set(phoneNumber) {
            UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        }
        get {
            return UserDefaults.standard.string(forKey: "phoneNumber")!
        }
    }
    
    init (context: NSManagedObjectContext) {
        self.context = context
        print("Custom Root: \(rootRef)")
        print("Internal Root: \(rootRef?.root)")
    }
    
    func hasAuthenticated() -> Bool {
        return rootRef?.authData != nil
    }
}

extension FirebaseService : RemoteStore {

    func startSyncing() {
        
    }
    
    func store(insert inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject]) {
        
    }
    
    func signUp(phoneNumber: String, email: String, password: String, success: @escaping () -> (), error errorCallback: @escaping (String) -> ()) {
        rootRef?.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
            if (error != nil) {
                print(error?.localizedDescription)
                errorCallback((error?.localizedDescription)!)
            } else {
                let newUser = [
                    "phoneNumber" : phoneNumber
                ]
                print("Result: \(result)")
                let uid = result?["uid"] as! String
                self.rootRef?.child(byAppendingPath: "users").child(byAppendingPath: uid).setValue(newUser)
                self.rootRef?.authUser(email, password: password, withCompletionBlock: { (error, result) in
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
