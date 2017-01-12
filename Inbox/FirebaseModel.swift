//
//  FirebaseModel.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 1/12/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseModel {
    func upload(rootRef: FIRDatabaseReference, context: NSManagedObjectContext)
}
