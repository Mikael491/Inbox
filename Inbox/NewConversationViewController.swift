//
//  NewConversationViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class NewConversationViewController: UIViewController, UITableViewFetchedResultsController {
    
    fileprivate let tableView = UITableView(frame: .zero, style: .plain)
    var context : NSManagedObjectContext?
    fileprivate var fetchedResultsController : NSFetchedResultsController<Contact>?
    fileprivate let cellIdentifier = "ContactCell"
    fileprivate var tableViewFetchedResults : UITableViewFetchedResultsDelegate?
    
    var conversationStartedDelegate : ConversationStartedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(NewConversationViewController.cancelMessage(sender:)))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        automaticallyAdjustsScrollViewInsets = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        setupMainView(subview: tableView)
        
        if let context = context {
            let request : NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
            request.predicate = NSPredicate(format: "storageID != nil")
            request.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true), NSSortDescriptor(key: "lastName", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sortLetter", cacheName: nil)
            tableViewFetchedResults = UITableViewFetchedResultsDelegate(tableView: tableView, controller: self)
            fetchedResultsController?.delegate = tableViewFetchedResults
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
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        cell.textLabel?.text = contact.fullName
    }

}


extension NewConversationViewController : UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension NewConversationViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
        guard let context = context else { return }
        let conversation = Conversation.existing(directWith: contact, inContext: context) ?? Conversation.new(directWith: contact, inContext: context)
        conversation.add(participant: contact)
        conversationStartedDelegate?.conversationStarted(withConvo: conversation, inContext: context)
        dismiss(animated: false, completion: nil)
    }
    
}




































