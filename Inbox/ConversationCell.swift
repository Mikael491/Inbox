//
//  ConversationCell.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let messageLabel = UILabel()
    let detaLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) failed to initialize.")
    }

}
