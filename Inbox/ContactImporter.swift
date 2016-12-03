//
//  ContactImporter.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/2/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData
import Contacts

class ContactImporter {
    
    func fetchContacts() {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            if granted {
                do {
                    let req = CNContactFetchRequest(keysToFetch: [
                        CNContactGivenNameKey as CNKeyDescriptor,
                        CNContactFamilyNameKey as CNKeyDescriptor,
                        CNContactPhoneNumbersKey as CNKeyDescriptor
                        ])
                    try store.enumerateContacts(with: req, usingBlock: {
                        cnContact, stop in
                        
                        print(cnContact)
                        
                    })
                } catch let error as NSError {
                    print("There was an error importing contacts: \(error)")
                }
            }
            
        })
        
    }
    
}


