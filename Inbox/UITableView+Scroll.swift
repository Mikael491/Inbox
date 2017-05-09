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
        if self.numberOfSections > 1 {
            let lastSection = self.numberOfSections - 1
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: lastSection) - 1, section: lastSection), at: .bottom, animated: true)
        } else if numberOfRows(inSection: 0) > 0 && self.numberOfSections == 1 {
            self.scrollToRow(at: IndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
}
