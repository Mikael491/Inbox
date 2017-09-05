//
//  AllConversationsViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class AllConversationsViewController: UIViewController, UITableViewFetchedResultsController, ConversationStartedDelegate, ContextViewController {
    
    //TODO: fix issue with blank chat on first(signup) init
    //TODO: Conversation indicator cells blank
    
    var context : NSManagedObjectContext?
    fileprivate var fetchedResultsController : NSFetchedResultsController<Conversation>?
    
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let cellIdentifier = "ConvoCell"
    fileprivate var tableViewFetchedResults : UITableViewFetchedResultsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.title = "Conversations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new-chat"), style: .plain, target: self, action: #selector(AllConversationsViewController.newConvo))
        automaticallyAdjustsScrollViewInsets = true
        
        tableView.register(ConversationCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableHeaderView = createHeader()
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
//        fakeData()
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
    
    func configureCell (cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        
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
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func createHeader() -> UIView {
        let header = UIView()
        let groupButton = UIButton()
        groupButton.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(groupButton)

        groupButton.setTitle("New Group", for: .normal)
        groupButton.setTitleColor(view.tintColor, for: .normal)
        groupButton.addTarget(self, action: #selector(AllConversationsViewController.newGroupButtonTapped(sender:)), for: .touchUpInside)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(border)
        border.backgroundColor = UIColor.lightGray
        
        let constraints = [
            groupButton.heightAnchor.constraint(equalTo: header.heightAnchor),
            groupButton.trailingAnchor.constraint(equalTo: header.layoutMarginsGuide.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1.0),
            border.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            border.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        header.setNeedsLayout()
        header.layoutIfNeeded()
        
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        
        return header
    }
    
    func newGroupButtonTapped(sender: AnyObject) {
        let vc = NewGroupViewController()
        let tempContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        tempContext.parent = context
        vc.context = tempContext
        vc.conversationStartedDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
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
        let vc = MessageViewController()
        vc.conversation = convo
        vc.context = context
        vc.hidesBottomBarWhenPushed = true
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
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else { return nil }
        let currentSection = sections[section]
        return currentSection.name
    }
    
}





























