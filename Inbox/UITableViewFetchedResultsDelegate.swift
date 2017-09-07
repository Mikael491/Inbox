//
//  UITableViewFetchedResultsDelegate.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 11/29/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import CoreData

class UITableViewFetchedResultsDelegate: NSObject, NSFetchedResultsControllerDelegate {

    fileprivate var tableView : UITableView?
    fileprivate var controller : UITableViewFetchedResultsController?
    
    init(tableView: UITableView, controller: UITableViewFetchedResultsController) {
        self.tableView = tableView
        self.controller = controller
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView?.insertSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView?.deleteSections(NSIndexSet.init(index: sectionIndex) as IndexSet, with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            guard let cell = tableView?.cellForRow(at: indexPath!) else { break }
            
            print("This is the controller: \(self.controller), the cell: \(cell), the indexPath: \(indexPath)")
            
            self.controller?.configureCell(cell: cell, atIndexPath: indexPath!)
            tableView?.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
            tableView?.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView?.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
}

