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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Message"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(NewConversationViewController.cancelMessage(sender:)))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        automaticallyAdjustsScrollViewInsets = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
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
    
    func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
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
        configureCell(cell: cell, indexPath: indexPath)
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let contact = fetchedResultsController?.object(at: indexPath) else { return }
    }
    
}

extension NewConversationViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        default:
            break
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath!], with: .fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)
            configureCell(cell: cell!, indexPath: indexPath!)
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [indexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}







































































































