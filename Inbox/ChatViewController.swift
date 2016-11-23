//
//  ViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/21/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    fileprivate var messages = [Message]()
    fileprivate var cellIdentifier = "Cell"
    private let messageTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        
        let blur = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blur)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let messageAreaView = UIView()
        messageAreaView.translatesAutoresizingMaskIntoConstraints = false
        messageAreaView.backgroundColor = UIColor.clear
        visualEffectView.frame = messageAreaView.bounds
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.isScrollEnabled = true
        messageTextView.backgroundColor = UIColor.white
        let sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(UIColor.gray, for: .normal)
        sendButton.setContentHuggingPriority(251, for: .horizontal)
        visualEffectView.contentView.addSubview(messageTextView)
        visualEffectView.contentView.addSubview(sendButton)
        messageAreaView.addSubview(visualEffectView)
        view.addSubview(messageAreaView)
        let messageAreaConstraints = [
            messageAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageAreaView.heightAnchor.constraint(equalToConstant: 50),
            visualEffectView.topAnchor.constraint(equalTo: messageAreaView.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: messageAreaView.bottomAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: messageAreaView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: messageAreaView.trailingAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: visualEffectView.contentView.leadingAnchor, constant: 10),
            messageTextView.centerYAnchor.constraint(equalTo: visualEffectView.contentView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: visualEffectView.contentView.trailingAnchor, constant: -10),
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: visualEffectView.contentView.centerYAnchor),
            messageTextView.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(messageAreaConstraints)
        
        var localIncoming = true
        for _ in 0...10 {
            let message = Message()
            message.text = "My name is Mikael, I am an iOS Engineer!"
            message.incoming = localIncoming
            localIncoming = !localIncoming
            messages.append(message)
        }
        
    }

}

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(messageType: message.incoming)
        return cell
    }
    
}

extension ChatViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}























