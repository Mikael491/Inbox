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
    private let rootRef = FIRDatabase.fi
    
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    func hasAuthenticated() -> Bool {
        return true
    }
}
