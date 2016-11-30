//
//  ViewController.swift
//  Moody
//
//  Created by XueliangZhu on 11/28/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    
    fileprivate typealias Data = FetchedResultsDataProvider<RootViewController>
    fileprivate var dataSource: TableViewDataSource<RootViewController, Data, MoodTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupTableView() {
        let request = Mood.sortedFetchRequest
        request.returnsObjectsAsFaults = false // ?
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
}

extension RootViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Mood>]?) {
        dataSource.processUpdates(updates: updates)
    }
}

extension RootViewController: DataSourceDelegate {
    func cellIdentifierForObject(_ object: Mood) -> String {
        return "MoodCell"
    }
}

