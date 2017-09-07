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

class ContactImporter : NSObject {
    
    private var context : NSManagedObjectContext?
    private var lastCNNotificationTime : NSDate?
    var contactsImported: Bool = false
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func listenForChanges() {
        CNContactStore.authorizationStatus(for: .contacts)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactImporter.addressbookDidChange(notification:)), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
    }
    
    func addressbookDidChange(notification: Notification) {
        let now = NSDate()
        guard lastCNNotificationTime == nil || now.timeIntervalSince(lastCNNotificationTime! as Date) > 1 else { return }
        lastCNNotificationTime = now
        fetchContacts()
    }
    
    func formatPhoneNumber(number: CNPhoneNumber) -> String {
        return number.stringValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
    
    func fetchExisting() -> (contacts: [String:Contact], phoneNumbers: [String:PhoneNumber]) {
        
        var phoneNumbers = [String : PhoneNumber]()
        var contacts = [String : Contact]()
        
        do {
            let request : NSFetchRequest<Contact> = NSFetchRequest<Contact>(entityName: "Contact")
            request.relationshipKeyPathsForPrefetching = ["phoneNumbers"]
            if let contactsResult = try context?.fetch(request) {
                for contact in contactsResult {
                    contacts[contact.contactID!] = contact
                    for phoneNumber in contact.phoneNumbers! {
                        let phoneNumber = phoneNumber as! PhoneNumber
                        phoneNumbers[phoneNumber.value!] = phoneNumber
                    }
                }
            }
        } catch let error as NSError {
            print("There was an error fetching existing contacts: \(error)")
        }
        return (contacts, phoneNumbers)
    }
    
    
    func fetchContacts() {
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            self.context?.perform {
                
                if granted {
                    do {
                        
                        let (contacts, phoneNumbers) = self.fetchExisting()
                        
                        let req = CNContactFetchRequest(keysToFetch: [
                            CNContactGivenNameKey as CNKeyDescriptor,
                            CNContactFamilyNameKey as CNKeyDescriptor,
                            CNContactPhoneNumbersKey as CNKeyDescriptor
                            ])
                        try store.enumerateContacts(with: req, usingBlock: {
                            cnContact, stop in
                            
                            guard let contact = contacts[cnContact.identifier] ?? NSEntityDescription.insertNewObject(forEntityName: "Contact", into: self.context!) as? Contact else { return }
                            contact.firstName = cnContact.givenName
                            contact.lastName = cnContact.familyName
                            contact.contactID = cnContact.identifier
                            contact.favorite = true
                            for cnVal in cnContact.phoneNumbers {
                                guard let phoneNumber = phoneNumbers[cnVal.value.stringValue] ?? NSEntityDescription.insertNewObject(forEntityName: "PhoneNumber", into: self.context!) as? PhoneNumber else { continue }
                                phoneNumber.kind = CNLabeledValue<NSString>.localizedString(forLabel: cnVal.label ?? "")
                                phoneNumber.value = self.formatPhoneNumber(number: cnVal.value)
                                phoneNumber.contact = contact
                            }
                            
                        })
                        try self.context?.save()
                    } catch let error as NSError {
                        print("There was an error importing contacts: \(error)")
                    } catch {
                        
                    }
                    self.contactsImported = true
                } else {
                    self.contactsImported = false
                    print("Not granted access to contacts...")
                }
                
            }

        })
        
    }
    
}


