//
//  AllConversationsViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class AllConversationsViewController: UIViewController {
    
    var context : NSManagedObjectContext?
//    private var fetchedResultsController : NSFetchedResultsController<Conversation>?
    
    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let cellIdentifier = "ConvoCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new-chat"), style: .plain, target: self, action: #selector(AllConversationsViewController.newConvo))
        automaticallyAdjustsScrollViewInsets = false
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let tableViewContstraints = [
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(tableViewContstraints)
        
    }
    
    func newConvo() {
        
    }

}
