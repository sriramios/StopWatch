//
//  LapTableViewDataSource.swift
//  StopWatch
//
//  Created by Sriram on 24/10/19.
//  Copyright © 2019 Sriram. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LapTableViewDataSource: NSObject {
    weak var lapFetchResultController: NSFetchedResultsController<LapInfo>?
    weak var lapTableView: UITableView?
    weak var managedObjectContext: NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<LapInfo> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<LapInfo> = LapInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.DataModel.FetchKey.createdAt, ascending: false)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    init(with managedObjectContext: NSManagedObjectContext , tableView: UITableView) {
        super.init()
        self.managedObjectContext = managedObjectContext
        self.lapFetchResultController = fetchedResultsController

        lapTableView = tableView
        lapTableView?.dataSource = self
        lapTableView?.tableFooterView = UIView(frame: .zero)
    }
    
    
}

//MARK: UITableViewDataSource Methods
extension LapTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let laps = lapFetchResultController?.fetchedObjects else { return 0 }
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LapTableViewCell.resueIdentifier, for: indexPath) as? LapTableViewCell else {
            fatalError("Invalid indexpath")
        }
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    func configureCell(cell: LapTableViewCell, indexPath: IndexPath) {
        if let lap = lapFetchResultController?.object(at: indexPath) {
            cell.updateView(name: "Lap \(lap.lap)", timeInterval: lap.timeInterval.convertString())
        }
    }
}

extension LapTableViewDataSource: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        lapTableView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            lapTableView?.deleteRows(at: [indexPath!], with: UITableView.RowAnimation.automatic)
        case .insert:
            lapTableView?.insertRows(at: [newIndexPath!], with: UITableView.RowAnimation.automatic)
        case .move: break
        case .update:
            
            if let indxPth = indexPath , let cellForIndex =  lapTableView?.cellForRow(at: indxPth) as? LapTableViewCell {
                self.configureCell(cell: cellForIndex, indexPath: indxPth)
            }
            break
        @unknown default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        lapTableView?.endUpdates()
    }
}
