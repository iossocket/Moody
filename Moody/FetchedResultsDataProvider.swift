//
//  FetchedResultsDataProvider.swift
//  Moody
//
//  Created by XueliangZhu on 11/30/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData

class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    typealias Object = Delegate.Object
    
    init(fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    func reconfigureFetchRequest(block: (NSFetchRequest<NSFetchRequestResult>) -> ()) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: fetchedResultsController.cacheName)
        block(fetchedResultsController.fetchRequest)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("fetch request failed")
        }
        delegate?.dataProviderDidUpdate(updates: nil)
    }
    
    func object(at indexPath: IndexPath) -> Object {
        guard let result = fetchedResultsController.object(at: indexPath) as? Object else {
            fatalError("Unexpected object at \(indexPath)")
        }
        return result
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return 0
    }
    
    private let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    private var updates: [DataProviderUpdate<Object>] = []
    private weak var delegate: Delegate?
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                fatalError("Index path should be not nil")
            }
            updates.append(.Insert(indexPath))
        case .update:
            guard let indexPath = indexPath else {
                fatalError("Index path should be not nil")
            }
            let object = self.object(at: indexPath)
            updates.append(.Update(indexPath, object))
        case .move:
            guard let indexPath = indexPath else {
                fatalError("Index path should be not nil")
            }
            guard let newIndexPath = newIndexPath else {
                fatalError("New index path should be not nil")
            }
            updates.append(.Move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else {
                fatalError("Index path should be not nil")
            }
            updates.append(.Delete(indexPath))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataProviderDidUpdate(updates: updates)
    }
}
