//
//  ViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/21/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    fileprivate var tableView : UITableView!
    fileprivate var cellIdentifier = "Cell"
    private let messageTextView = UITextView()
    private var bottomConstraint : NSLayoutConstraint!
    
    fileprivate var sections = [Date: [Message]]()
    fileprivate var dates = [Date]()
    
    var context : NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect.init(origin: view.frame.origin, size: view.frame.size), style: .grouped)
        
        view.addSubview(tableView)
        
        //TODO: Configure TableView programatically
        let tableViewConstrinats = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstrinats)
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        //TODO: animate bottom inset with keyboard show and disappear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        
        
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
        sendButton.addTarget(self, action: #selector(ChatViewController.sendTapped(sender:)), for: .touchUpInside)
        sendButton.setContentHuggingPriority(251, for: .horizontal)
        visualEffectView.contentView.addSubview(messageTextView)
        visualEffectView.contentView.addSubview(sendButton)
        messageAreaView.addSubview(visualEffectView)
        view.addSubview(messageAreaView)
        bottomConstraint = messageAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        let messageAreaConstraints = [
            messageAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.handleSwipe(gesture:)))
        swipeGesture.direction = .down
        messageAreaView.addGestureRecognizer(swipeGesture)
        
        var date = Date()
        var localIncoming = true
        for i in 0...10 {
            let message = Message()
            message.text = "My name is Mikael, I am an iOS Engineer!"
            message.timestamp = date
            message.incoming = localIncoming
            localIncoming = !localIncoming
            addMessage(message: message)
        
//            if i%2 == 0 {
//                date = Date(timeInterval: 60 * 60 * 24, since: date)
//            }
            
        }
        
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.scrollToBottom()
    }
    
    func keyboardWillShow(notification: Notification) {
        updateMessageAreaBottomConstraint(notification)
    }
    
    func keyboardWillHide(notification: Notification) {
        updateMessageAreaBottomConstraint(notification)
    }
    
    func updateMessageAreaBottomConstraint(_ notification: Notification) {
        if let userInfo = notification.userInfo, let frame = userInfo[UIKeyboardFrameEndUserInfoKey], let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] {
            let newFrame = view.convert((frame as! NSValue).cgRectValue, from: (UIApplication.shared.delegate?.window)!)
            bottomConstraint.constant = newFrame.origin.y - view.frame.height
            UIView.animate(withDuration: animationDuration as! TimeInterval, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func handleSwipe(gesture: UISwipeGestureRecognizer) {
        messageTextView.resignFirstResponder()
    }
    
    func sendTapped(sender: UIButton) {
        guard let text = messageTextView.text , text.characters.count > 0 else { return }
        guard let context = context else { return }
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else { return }
        message.text = text
        message.incoming = false
        message.timestamp = NSDate()
        addMessage(message: message)
        tableView.reloadData()
        tableView.scrollToBottom()
        messageTextView.text = ""
    }
    
    
    func addMessage(message: Message) {
        
        guard let date = message.timestamp else { return }
        let calander = Calendar.current
        let day = calander.startOfDay(for: date as Date)
        
        var messages = sections[day]
        if messages == nil {
            dates.append(day)
            messages = [Message]()
        }
        messages?.append(message)
        sections[day] = messages
    }
    
}

extension ChatViewController : UITableViewDataSource {
    
    func getMessages(_ section: Int) -> [Message] {
        let date = dates[section]
        return sections[date]!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMessages(section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatCell
        let messages = getMessages(indexPath.section)
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.text
        cell.incoming(messageType: message.incoming)
        
//        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        let paddingView = UIView()
        headerView.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        let dateLabel = UILabel()
        paddingView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: Set constraints for header views and date lable
        
        let constraints = [
            paddingView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            paddingView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
            paddingView.heightAnchor.constraint(equalTo: dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraint(equalTo: dateLabel.widthAnchor, constant: 10),
            headerView.widthAnchor.constraint(equalTo: paddingView.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        //TODO: Update date label style
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        dateLabel.text = formatter.string(from: dates[section])
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: dateLabel.font.fontName, size: 12)
        
//        paddingView.layer.cornerRadius = 10
//        paddingView.layer.masksToBounds = true
//        paddingView.backgroundColor = UIColor.gray
    
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

extension ChatViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}























