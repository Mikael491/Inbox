//
//  Message+CoreDataClass.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData


public class Message: NSManagedObject {

    var isIncoming : Bool {
        return sender != nil
    }
    
}
