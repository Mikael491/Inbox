//
//  AppDelegate.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/21/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var contactImporter : ContactImporter?
    private var contextSyncer : ContextSynchronizer?
    
    //firbase context properties
    private var contactImportSync : ContextSynchronizer?
    private var firebaseSync : ContextSynchronizer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CoreDataHelper.sharedInstance.coordinator
        
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = CoreDataHelper.sharedInstance.coordinator
        contextSyncer = ContextSynchronizer(mainContext: mainContext, backgroundContext: backgroundContext)
        let firebaseContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        firebaseContext.persistentStoreCoordinator = CoreDataHelper.sharedInstance.coordinator
        contactImportSync = ContextSynchronizer(mainContext: mainContext, backgroundContext: firebaseContext)
        firebaseSync = ContextSynchronizer(mainContext: mainContext, backgroundContext: firebaseContext)
        contactImporter = ContactImporter(context: backgroundContext)
        importContacts(backgroundContext)
        contactImporter?.listenForChanges()
        
        let tabBarController = UITabBarController()
        let vcData : [(UIViewController, UIImage, String)] = [(FavoritesViewController(), UIImage(named: "favorites_icon")!, "Favorites"), (ContactsViewController(), UIImage(named: "contact_icon")!, "Contacts"), (AllConversationsViewController(), UIImage(named: "chat_icon")!, "Conversations")]
        
        let viewControllers = vcData.map {
            (vc: UIViewController, image: UIImage, title: String) -> UINavigationController in
            
            if var vc = vc as? ContextViewController {
                vc.context = mainContext
            }
            let nav = UINavigationController(rootViewController: vc)
            nav.tabBarItem.image = image
            nav.title = title
            return nav
        }
        tabBarController.viewControllers = viewControllers
        window?.rootViewController = SignUpViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func importContacts(_ context: NSManagedObjectContext) {
        
        let dataSeeded = UserDefaults.standard.bool(forKey: "contactsAdded")
        
        guard !dataSeeded else { return }
        
        contactImporter?.fetchContacts()
        
        UserDefaults.standard.set(true, forKey: "contactsAdded")
    }
    
}




