//
//  ChatCell.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/22/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    let messageLabel = UILabel()
    private let bubbleImageView = BubbleImageView()
    private var imageName = "MessageBubble"
    
    private var incomingConstraint : NSLayoutConstraint!
    private var outgoingConstraint : NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraint(equalTo: bubbleImageView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: bubbleImageView.centerYAnchor).isActive = true
        
        bubbleImageView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 50).isActive = true
        bubbleImageView.heightAnchor.constraint(equalTo: messageLabel.heightAnchor, constant: 10).isActive = true
        
        bubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        incomingConstraint = bubbleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        outgoingConstraint = bubbleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incoming(messageType: Bool) {
        if messageType {
            incomingConstraint.isActive = true
            outgoingConstraint.isActive = false
            bubbleImageView.incomingBubble()
        } else {
            incomingConstraint.isActive = false
            outgoingConstraint.isActive = true
            messageLabel.textColor = UIColor.white
            bubbleImageView.outgoingBubble()
        }
    }

}
