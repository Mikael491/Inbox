//
//  Message+CoreDataClass.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/24/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData


public class Message: NSManagedObject {

    var isIncoming : Bool {
        get {
            return incoming
        }
        set(incoming) {
            self.incoming = incoming
        }
    }
    
}
