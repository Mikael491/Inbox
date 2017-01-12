//
//  RemoteStore.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/14/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData

protocol RemoteStore {
    func startSyncing()
    func store(insert inserted: [NSManagedObject], updated: [NSManagedObject], deleted: [NSManagedObject])
    func signUp(phoneNumber: String, email: String, password: String, success: @escaping ()->(), error: @escaping (_ errorMessage: String)->())

}

extension RemoteStore {
}
