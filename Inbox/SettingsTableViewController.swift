//
//  SettingsTableViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 9/4/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController, Authenticatable {

    private var source = ["Logout"]
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = source[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        switch (cell?.textLabel?.text)! {
        case "Logout":
            logout()
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionName = String()
        switch section {
        case 0:
            sectionName = "Authentication"
            break
        default:
            sectionName = ""
            break
        }
        return sectionName
    }
    
    func logout() {
        let auth = FIRAuth.auth()
        do {
            try auth?.signOut()
            self.removeUserFromDefaults()
            self.tabBarController?.dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.makeLoginVC(tabVC: self.tabBarController!)
        } catch let signoutError as NSError {
            print("There was an error signing out: \(signoutError)")
        }
    }

}
