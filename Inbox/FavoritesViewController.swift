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
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: cellIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupMainView(subview: tableView)
        
        if let context = context {
            let request : NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageID != nil AND favorite = true")
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        if editing {
            tableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(FavoritesViewController.deleteAll))
        } else {
            tableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem = nil
            guard let context = context , context.hasChanges else { return }
            do {
                try context.save()
            } catch {
                print("There was an error saving context in FavoritesVC: \(error)")
            }
        }
    }
    
    func deleteAll() {
        guard let contacts = fetchedResultsController?.fetchedObjects else { return }
        for contact in contacts {
            context?.delete(contact)
        }
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        guard let cell = cell as? FavoriteCell else { return }
        cell.textLabel?.text = contact.fullName
        cell.detailTextLabel?.text = contact.status ?? ""
//        cell.phoneTypeLabel.text = ((contact.phoneNumbers?.filter({
//            number in
//            guard let number = number as? PhoneNumber else { return false }
//            return number.registered
//        }).first) as! PhoneNumber).kind
        cell.phoneTypeLabel.text = (contact.phoneNumbers?.allObjects.first as! PhoneNumber).kind
        cell.accessoryType = .detailButton
    }

}


extension FavoritesViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        
        let convoContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        convoContext.parent = context
        
        let convo = Conversation.existing(directWith: contact, inContext: convoContext) ?? Conversation.new(directWith: contact, inContext: convoContext)
        
        let vc = MessageViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.context = convoContext
        vc.conversation = convo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        guard let id = contact.contactID else { return }
        let cnContact : CNContact
        do {
            cnContact = try store.unifiedContact(withIdentifier: id, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
        } catch {
            return
        }
        let vc = CNContactViewController(for: cnContact)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else {
            return
        }
        contact.favorite = false
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





