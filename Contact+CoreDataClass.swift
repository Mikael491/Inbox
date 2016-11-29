//
//  Contact+CoreDataClass.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/28/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData


public class Contact: NSManagedObject {

    var sortLetter : String {
        let letter = lastName?.characters.first ?? lastName?.characters.first
        let s = String(letter!)
        return s
    }
    
    var fullName : String {
        var name = ""
        if let firstName = firstName {
            name += firstName
        }
        if let lastName = lastName {
            if name.characters.count > 0 {
                name += " "
            }
            name += lastName
        }
        return name
    }
    
}
