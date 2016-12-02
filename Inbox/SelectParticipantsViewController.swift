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
    
    fileprivate var searchField : UITextField!
    fileprivate let tableView = UITableView(frame: CGRect.zero, style: .plain)
    fileprivate let cellIdentifier = "ContactCell"
    
    fileprivate var contactsToDisplay = [Contact]()
    fileprivate var allContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Participants"
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(SelectParticipantsViewController.createConversation))
        showCreateButton(show: false)
        automaticallyAdjustsScrollViewInsets = true
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        searchField = createSearchField()
        searchField.delegate = self
        tableView.tableHeaderView = searchField
        tableView.dataSource = self
        
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
    
    func endSearch() {
        contactsToDisplay = selectedContacts
        tableView.reloadData()
    }

}


extension SelectParticipantsViewController : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = allContacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = contact.fullName
        cell.selectionStyle = .none
        return cell
    }
    
}

extension SelectParticipantsViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else {
            endSearch()
            return true
        }
        
        let text = NSString(string: currentText).replacingCharacters(in: range, with: string)
        if text.characters.count == 0 {
            endSearch()
            return true
        }
        
        contactsToDisplay = allContacts.filter({ (contact) -> Bool in
            let match = contact.fullName.range(of: text) != nil
            return match
        })
        tableView.reloadData()
        return true
    }
}
















































