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
    private let rootRef = Firebase(url: "https://Inbox.firebaseio.com")
    
    init (context: NSManagedObjectContext) {
        self.context = context
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
    
    func signUp(phoneNumber: String, email: String, password: String, success: () -> (), error: (String) -> ()) {
        
    }
}
