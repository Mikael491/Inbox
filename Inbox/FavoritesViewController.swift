//
//  FavoritesViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/4/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import ContactsUI

class FavoritesViewController: UIViewController, UITableViewFetchedResultsController, ContextViewController {

    var context: NSManagedObjectContext?
    
    var fetchedResultsController : NSFetchedResultsController<Contact>?
    var fetchedResultsDelegate : NSFetchedResultsControllerDelegate?
    
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let cellIdentifier = "FavoriteCell"
    fileprivate let store = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "Favorites"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        tableView.tableFooterView = UIView(frame: .zero)
        
        setupMainView(subview: tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        guard let cell = cell as? FavoriteCell else { return }
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = "*********"
        cell.phoneTypeLabel.text = "mobile"
        cell.accessoryType = .detailButton
    }

}
