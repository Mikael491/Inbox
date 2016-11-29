//
//  NewConversationViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class NewConversationViewController: UIViewController {
    
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    fileprivate var context : NSManagedObjectContext?
    fileprivate var fetchedResultsController : NSFetchedResultsController<Contact>?
    fileprivate let cellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(NewConversationViewController.cancelMessage(sender:)))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
        
        if let context = context {
            let request : NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true), NSSortDescriptor(key: "lastName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: "NewConversationViewController")
            fetchedResultsController?.delegate = self
            do {
                try fetchedResultsController?.performFetch()
            } catch let error as NSError {
                print("There was an error fetching contacts in NewConversationsVC: \(error)")
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelMessage(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        cell.textLabel?.text = contact.fullName
    }

}


extension NewConversationViewController : UITableViewDataSource {
    
}

extension NewConversationViewController : UITableViewDelegate {
    
}

extension NewConversationViewController : NSFetchedResultsControllerDelegate {
    
}







































































































