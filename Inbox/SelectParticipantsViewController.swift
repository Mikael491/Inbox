//
//  SelectParticipantsViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/1/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class SelectParticipantsViewController: UIViewController {

    var context : NSManagedObjectContext?
    var conversation : Conversation?
    var conversationStartedDelegate : ConversationStartedDelegate?
    
    private var searchField : UITextField!
    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let cellidentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Participants"
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(SelectParticipantsViewController.createConversation))
        showCreateButton(show: false)
        automaticallyAdjustsScrollViewInsets = true
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellidentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        searchField = createSearchField()
        tableView.tableHeaderView = searchField
        
        setupMainView(subview: tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSearchField() -> UITextField {
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        searchField.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        searchField.placeholder = "Type contact name..."
        
        let holderView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        searchField.leftView = holderView
        searchField.leftViewMode = .always
        
        let image = UIImage(named: "contact_icon")?.withRenderingMode(.alwaysTemplate)
        let contactImage = UIImageView(image: image)
        contactImage.tintColor = UIColor.darkGray
        contactImage.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(contactImage)
        
        let contactImageConstraints = [
            contactImage.widthAnchor.constraint(equalTo: holderView.widthAnchor, constant: -20),
            contactImage.heightAnchor.constraint(equalTo: holderView.heightAnchor, constant: -20),
            contactImage.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
            contactImage.centerYAnchor.constraint(equalTo: holderView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(contactImageConstraints)
        
        return searchField
    }
    
    func showCreateButton(show: Bool) {
        if show {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func createConversation() {
        
    }

}
