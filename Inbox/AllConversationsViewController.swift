//
//  AllConversationsViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class AllConversationsViewController: UIViewController, UITableViewFetchedResultsController, ConversationStartedDelegate {
    
    var context : NSManagedObjectContext?
    fileprivate var fetchedResultsController : NSFetchedResultsController<Conversation>?
    
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let cellIdentifier = "ConvoCell"
    fileprivate var tableViewFetchedResults : UITableViewFetchedResultsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new-chat"), style: .plain, target: self, action: #selector(AllConversationsViewController.newConvo))
        automaticallyAdjustsScrollViewInsets = true
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupMainView(subview: tableView)
        
        if let context = context {
            
            let request : NSFetchRequest<Conversation> = NSFetchRequest(entityName: "Conversation")
            request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTime", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            tableViewFetchedResults = UITableViewFetchedResultsDelegate(tableView: tableView, controller: self)
            fetchedResultsController?.delegate = tableViewFetchedResults
            do {
                try fetchedResultsController?.performFetch()
            } catch let error as NSError {
                print("There was an error performing fetch on AllConversationsVC: \(error)")
            }
        }
        fakeData()
    }
    
    func newConvo() {
        let vc = NewConversationViewController()
        let newConverationContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        newConverationContext.parent = context
        vc.context = newConverationContext
        vc.conversationStartedDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = UIColor.white
        self.present(nav, animated: true, completion: nil)
    }
    
    func fakeData() {
        
        guard let context = context else { return }
        let convo = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation
    }
    
    func configureCell (cell: UITableViewCell, indexPath: IndexPath) {
        
        let cell = cell as! ConversationCell
        guard let convo = fetchedResultsController?.object(at: indexPath) else { return } //not casting necessary b/c fetchResultsVC is generic
        guard let contact = convo.participants?.anyObject() as? Contact else { return }
        guard let lastMessage = convo.lastMessage, let timestamp = lastMessage.timestamp, let text = lastMessage.text else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/DD/YY"
        cell.nameLabel.text = contact.fullName
        cell.messageLabel.text = text
        cell.dateLabel.text = formatter.string(from: timestamp as Date)
    }
    
    func conversationStarted(withConvo convo: Conversation, inContext: NSManagedObjectContext) {
        let vc = MessageViewController()
        vc.context = inContext
        vc.conversation = convo
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension AllConversationsViewController : UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let convo = fetchedResultsController?.object(at: indexPath) else { return }
        print(convo)
        let vc = MessageViewController()
        vc.conversation = convo
        vc.context = context
        self.navigationController?.pushViewController(vc, animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}

extension AllConversationsViewController : UITableViewDataSource {
    
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
    
}





























