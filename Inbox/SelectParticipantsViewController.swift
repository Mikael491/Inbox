//
//  SelectParticipantsViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/1/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class SelectParticipantsViewController: UIViewController {

    var context : NSManagedObjectContext?
    var conversation : Conversation?
    var conversationStartedDelegate : ConversationStartedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Participants"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
