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
    
    var remoteStore : RemoteStore?
    
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContextSynchronizer.syncMainContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: mainContext)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContextSynchronizer.syncBackgroundContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: backgroundContext)
        
    }
    
    func syncMainContext(notification: Notification) {
        backgroundContext?.perform({
            
            let inserted = self.objectsForKey(key: NSInsertedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext!)
            let updated = self.objectsForKey(key: NSUpdatedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext!)
            let deleted = self.objectsForKey(key: NSDeletedObjectsKey, dictionary: notification.userInfo!, context: self.backgroundContext!)
            
            
            self.backgroundContext?.mergeChanges(fromContextDidSave: notification)
            
            self.remoteStore?.store(insert: inserted, updated: updated, deleted: deleted)
        })
    }
    
    func syncBackgroundContext(notification: Notification) {
        mainContext?.perform({
            self.mainContext?.mergeChanges(fromContextDidSave: notification)
        })
    }
    
    private func objectsForKey(key: String, dictionary: [AnyHashable : Any], context: NSManagedObjectContext) -> [NSManagedObject] {
        guard let set = (dictionary[key] as? NSSet) else { return [] }
        guard let objects = set.allObjects as? [NSManagedObject] else { return [] }
        return objects.map{context.object(with: $0.objectID)}
    }
    
}
