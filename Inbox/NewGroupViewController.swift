//
//  NewGroupViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/30/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UIViewController {

    var context : NSManagedObjectContext?
    var conversationStartedDelegate : ConversationStartedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Group"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
