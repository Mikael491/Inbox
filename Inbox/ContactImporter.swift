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
    
    private var context : NSManagedObjectContext?
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
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
                        
                        guard let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: self.context!) as? Contact else { return }
                        contact.firstName = cnContact.givenName
                        contact.lastName = cnContact.familyName
                        contact.contactID = cnContact.identifier
                        print(contact)
                        
                    })
                } catch let error as NSError {
                    print("There was an error importing contacts: \(error)")
                } catch {
                    
                }
            } else {
                print("Not granted access to contacts...")
            }
            
        })
        
    }
    
}


