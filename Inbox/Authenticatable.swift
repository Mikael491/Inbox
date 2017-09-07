//
//  Authenticatable.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 9/6/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import Firebase

@objc protocol Authenticatable {
    @objc optional func saveToDefaults()
    @objc optional func removeFromDefaults()
}

extension Authenticatable {
    func saveUserToDefaults(object: AnyObject? = nil) {
        UserDefaults.standard.set(object ?? true, forKey: "currentUser")
    }
    
    func removeUserFromDefaults() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
