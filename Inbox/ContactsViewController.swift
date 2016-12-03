//
//  ContactsViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/3/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class ContactsViewController: UIViewController, ContextViewController {

    var context : NSManagedObjectContext?
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let cellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ContactsViewController.addContact(sender:)))
        automaticallyAdjustsScrollViewInsets = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupMainView(subview: tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func addContact(sender: AnyObject) {
        
    }

}
