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
    private let bubbleImageView = UIImageView()
    private var imageName = "MessageBubble"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraint(equalTo: bubbleImageView.centerXAnchor).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: bubbleImageView.centerYAnchor).isActive = true
        
        bubbleImageView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 20)
        bubbleImageView.heightAnchor.constraint(equalTo: messageLabel.heightAnchor).isActive = true
        
        bubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bubbleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
        bubbleImageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
