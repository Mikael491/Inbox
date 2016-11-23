//
//  UITableView+Scroll.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/23/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

extension UITableView {
    
    func scrollToBottom() {
        self.scrollToRow(at: IndexPath.init(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true)
    }
    
}
