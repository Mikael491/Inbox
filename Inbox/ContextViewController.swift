//
//  ContextViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/3/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import CoreData

protocol ContextViewController {
    var context : NSManagedObjectContext? { get set }
}
