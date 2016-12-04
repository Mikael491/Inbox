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
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: cellIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupMainView(subview: tableView)
        
        if let context = context {
            let request : NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true),
                                       NSSortDescriptor(key: "firstName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsDelegate = UITableViewFetchedResultsDelegate(tableView: tableView, controller: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("There was an error fetching contacts in FavoritesVC: \(error)")
            }
        }
        
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


extension FavoritesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
    }
    
}

extension FavoritesViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else { return nil }
        let currentSection = sections[section]
        return currentSection.name
    }
    
}





