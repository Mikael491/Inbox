//
//  NewGroupViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/30/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class NewGroupViewController: UIViewController {

    var context : NSManagedObjectContext?
    var conversationStartedDelegate : ConversationStartedDelegate?
    
    let subjectField = UITextField()
    let characterNumberLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "New Group"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(NewGroupViewController.dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(NewGroupViewController.pushNextViewController))
        
        subjectField.placeholder = "Subject"
        subjectField.delegate = self
        subjectField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subjectField)
        
        characterNumberLabel.textColor = UIColor.gray
        characterNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterNumberLabel)
        
        let border = UIView()
        border.backgroundColor = UIColor.lightGray
        border.translatesAutoresizingMaskIntoConstraints = false
        subjectField.addSubview(border)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView() {
        
    }
    
    func pushNextViewController() {
        
    }

}

extension NewGroupViewController : UITextFieldDelegate {
    
}

























