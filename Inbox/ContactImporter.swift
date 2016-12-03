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
    
    func formatPhoneNumber(number: CNPhoneNumber) -> String {
        return number.stringValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
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
                        let contactNumbers = NSMutableSet()
                        for cnVal in cnContact.phoneNumbers {
                            guard let phoneNumber = NSEntityDescription.insertNewObject(forEntityName: "PhoneNumber", into: self.context!) as? PhoneNumber else { continue }
                            phoneNumber.value = self.formatPhoneNumber(number: cnVal.value)
                            contactNumbers.add(phoneNumber)
                        }
                        contact.phoneNumbers = contactNumbers
                        
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


