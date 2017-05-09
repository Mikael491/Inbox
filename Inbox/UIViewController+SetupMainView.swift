//
//  UIViewController+SetupMainView.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupMainView(subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        let subviewContstraints = [
            subview.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(subviewContstraints)
        
    }
    
}
