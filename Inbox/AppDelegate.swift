//
//  AppDelegate.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/21/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var contactImporter : ContactImporter?
    private var contextSyncer : ContextSynchronizer?
    
    //firbase context properties
    private var contactImportSync : ContextSynchronizer?
    private var firebaseSync : ContextSynchronizer?
    private var firebaseService : FirebaseService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FIRApp.configure()
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = CoreDataHelper.sharedInstance.coordinator
        
        let contactsContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        contactsContext.persistentStoreCoordinator = CoreDataHelper.sharedInstance.coordinator
        contextSyncer = ContextSynchronizer(mainContext: mainContext, backgroundContext: contactsContext)
        let firebaseContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        firebaseContext.persistentStoreCoordinator = CoreDataHelper.sharedInstance.coordinator
        
        let firebaseService = FirebaseService(context: firebaseContext)
        self.firebaseService = firebaseService
        
        contactImportSync = ContextSynchronizer(mainContext: contactsContext, backgroundContext: firebaseContext)
        contactImportSync?.remoteStore = firebaseService
        firebaseSync = ContextSynchronizer(mainContext: mainContext, backgroundContext: firebaseContext)
        firebaseSync?.remoteStore = firebaseService
        
        contactImporter = ContactImporter(context: contactsContext)
        
//        importContacts(backgroundContext)
        

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
        
        if firebaseService.hasAuthenticated() {
            
            firebaseService.startSyncing()
            contactImporter?.listenForChanges()

            window?.rootViewController = tabBarController
            self.window?.makeKeyAndVisible()
        } else {

//            let vc = SignUpViewController()
//            vc.remoteStore = firebaseService
//            vc.rootViewController = tabBarController
//            vc.contactImporter = contactImporter
        
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            vc.remoteStore = firebaseService
            vc.rootViewController = tabBarController
            vc.contactImporter = contactImporter
            window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
        }
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
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
    }
    
    func importContacts(_ context: NSManagedObjectContext) {
        
        let dataSeeded = UserDefaults.standard.bool(forKey: "contactsAdded")
        
        guard !dataSeeded else { return }
        
        contactImporter?.fetchContacts()
        
        UserDefaults.standard.set(true, forKey: "contactsAdded")
    }
    
}




