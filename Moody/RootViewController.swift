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
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        
        let request = Mood.sortedFetchRequest
        request.returnsObjectsAsFaults = false // ?
        request.fetchBatchSize = 20
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDataSource(tableView: tableView, dataProvider: dataProvider, delegate: self)
        tableView.delegate = self
    }
    
    @IBAction func addNew(_ sender: Any) {
        managedObjectContext.performChanges { [weak self] in
            guard let strongSelf = self else { return }
            _ = Mood.insertIntoContext(moc: strongSelf.managedObjectContext, image: UIImage())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? MoodDetailViewController else { fatalError("Wrong view controller type") }
        guard let mood = dataSource.selectedObject else {
            fatalError("Showing detail, but no selected mood")
        }
        vc.mood = mood
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

extension RootViewController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("hehe")
    }
}

