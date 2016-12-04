//
//  UITableViewFetchedResutsController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/3/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import Foundation
import UIKit

protocol UITableViewFetchedResultsController {
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath)
}
