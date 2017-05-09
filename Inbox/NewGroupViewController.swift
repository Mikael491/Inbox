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
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(NewGroupViewController.dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(NewGroupViewController.pushNextViewController))
        updateNextButton(forCharacterCount: 0)
        
        subjectField.placeholder = "Subject"
        subjectField.delegate = self
        subjectField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subjectField)
        
        characterNumberLabel.textColor = UIColor.gray
        characterNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterNumberLabel)
        updateCharacterLabel(forCharacterCount: 0)
        
        let border = UIView()
        border.backgroundColor = UIColor.lightGray
        border.translatesAutoresizingMaskIntoConstraints = false
        subjectField.addSubview(border)
        
        let constraints = [
            subjectField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            subjectField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            subjectField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            border.widthAnchor.constraint(equalTo: subjectField.widthAnchor),
            border.heightAnchor.constraint(equalToConstant: 1),
            border.leadingAnchor.constraint(equalTo: subjectField.leadingAnchor),
            border.bottomAnchor.constraint(equalTo: subjectField.bottomAnchor),
            characterNumberLabel.centerYAnchor.constraint(equalTo: subjectField.centerYAnchor),
            characterNumberLabel.trailingAnchor.constraint(equalTo: subjectField.layoutMarginsGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func pushNextViewController() {
        guard let context = context, let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else { return }
        conversation.name = subjectField.text
        
        let vc = SelectParticipantsViewController()
        vc.context = context
        vc.conversation = conversation
        //delegate is set as AllConvosVC
        vc.conversationStartedDelegate = conversationStartedDelegate
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateCharacterLabel(forCharacterCount length: Int) {
        characterNumberLabel.text = String(25 - length)
    }
    
    func updateNextButton(forCharacterCount length: Int) {
        if length == 0 {
            navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.tintColor = view.tintColor
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

}

extension NewGroupViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCount = textField.text?.characters.count ?? 0
        let newCount = currentCount + string.characters.count - range.length
        
        if newCount <= 25 {
            updateCharacterLabel(forCharacterCount: newCount)
            updateNextButton(forCharacterCount: newCount)
            return true
        }
        return false
    }
    
}

























