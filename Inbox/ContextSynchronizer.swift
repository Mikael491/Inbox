//
//  ContextSynchronizer.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/3/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class ContextSynchronizer: NSObject {

    private var mainContext : NSManagedObjectContext?
    private var backContext : NSManagedObjectContext?
    
    init(mainContext: NSManagedObjectContext, backContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backContext = backContext
        super.init()
    }
    
}
