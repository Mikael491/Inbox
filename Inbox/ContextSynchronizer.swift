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
    private var backgroundContext : NSManagedObjectContext?
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContextSynchronizer.syncMainContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: mainContext)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContextSynchronizer.syncBackgroundContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext)
        
    }
    
    func syncMainContext(notification: Notification) {
        backgroundContext?.perform({
            self.backgroundContext?.mergeChanges(fromContextDidSave: notification)
        })
    }
    
    func syncBackgroundContext(notification: Notification) {
        mainContext?.perform({
            self.mainContext?.mergeChanges(fromContextDidSave: notification)
        })
    }
    
}
