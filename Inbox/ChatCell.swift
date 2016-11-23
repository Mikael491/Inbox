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
    
    private var incomingConstraints : [NSLayoutConstraint]!
    private var outgoingConstraints : [NSLayoutConstraint]!
    
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
        
        incomingConstraints = [
            bubbleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bubbleImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: 50)
        ]
        outgoingConstraints = [
            bubbleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bubbleImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: -50)
        ]
        
        bubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        bubbleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func incoming(messageType: Bool) {
        if messageType {
            NSLayoutConstraint.deactivate(outgoingConstraints)
            NSLayoutConstraint.activate(incomingConstraints)
            bubbleImageView.incomingBubble()
            messageLabel.textColor = UIColor.black
        } else {
            NSLayoutConstraint.deactivate(incomingConstraints)
            NSLayoutConstraint.activate(outgoingConstraints)
            messageLabel.textColor = UIColor.white
            bubbleImageView.outgoingBubble()
        }
    }

}
