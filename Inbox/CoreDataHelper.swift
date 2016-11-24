//
//  CoreDataHelper.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/24/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper{
    
    static let sharedInstance = CoreDataHelper()
    
    lazy var storesDirectory: NSURL = {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    lazy var localStoreURL: URL = {
        let url = self.storesDirectory.appendingPathComponent("Inbox.sqlite")
        return url!
    }()
    lazy var modelURL: URL = {
        let bundle = Bundle.main
        if let url = bundle.url(forResource: "Model", withExtension: "momd") {
            return url
        }
        print("CRITICAL - Managed Object Model file not found")
        abort()
    }()
    
    lazy var model: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOf:self.modelURL)!
    }()
    
    lazy var coordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.localStoreURL, options: nil)
        } catch {
            print("Could not add the peristent store")
            abort()
        }
        
        return coordinator
    }()
}
