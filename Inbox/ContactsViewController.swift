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

class ContactsViewController: UIViewController, ContextViewController, UITableViewFetchedResultsController, ContactSelector {

    var context : NSManagedObjectContext?
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let cellIdentifier = "ContactCell"
    
    fileprivate var fetchedResultsController : NSFetchedResultsController<Contact>?
    fileprivate var fetchedResultsDelegate : NSFetchedResultsControllerDelegate?
    
    private var searchController : UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ContactsViewController.addContact(sender:)))
        automaticallyAdjustsScrollViewInsets = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupMainView(subview: tableView)
        
        if let context = context {
            
            let request : NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
            request.sortDescriptors = [NSSortDescriptor(key: "lastName", ascending: true), NSSortDescriptor(key: "firstName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsDelegate = UITableViewFetchedResultsDelegate(tableView: tableView, controller: self)
            fetchedResultsController?.delegate = fetchedResultsDelegate
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("There was an error fetching contacts in ContactsVC: \(error)")
            }
        }
        
        let resultsVC = ContactSearchResultsViewController()
        resultsVC.contacts = fetchedResultsController?.fetchedObjects as [Contact]!
        resultsVC.contactSelector = self
        
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController?.searchResultsUpdater = resultsVC
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController?.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func addContact(sender: AnyObject) {
        
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) as? Contact! else { return }
        cell.textLabel?.text = contact.fullName
    }
    
    func selectedContact(contact: Contact) {
        guard let id = contact.contactID else { return }
        let store = CNContactStore()
        let cnContact : CNContact
        do {
            cnContact = try store.unifiedContact(withIdentifier: id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            return
        }
        let vc = CNContactViewController(for: cnContact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        searchController?.isActive = false
    }

}


extension ContactsViewController : UITableViewDataSource {
    
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
    
}

extension ContactsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) as? Contact! else { return }
        selectedContact(contact: contact)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}







































