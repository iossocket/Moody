//
//  ManagedObjectObserver.swift
//  Moody
//
//  Created by XueliangZhu on 12/1/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import Foundation

class ManagedObjectObserver {
    enum ChangeType {
        case delete
        case update
    }
    
    init?(object: ManagedObjectType, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else {
            return nil
        }
        objectHasBeenDeleted = false
        token = moc.addObjectsDidChangeNotificationObserver { [unowned self] note in
            guard let changeType = self.changeTypeOfObject(object, inNotification: note) else { return }
            self.objectHasBeenDeleted = changeType == .delete
            changeHandler(changeType)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(token)
    }
    
    private var token: NSObjectProtocol!
    private var objectHasBeenDeleted: Bool = false
    
    private func changeTypeOfObject(_ object: ManagedObjectType, inNotification note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        guard let obj = object as? ManagedObject else {
            return nil
        }
        if note.invalidatedAllObjects || deleted.contains(obj) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.contains(obj) {
            let predicate = type(of: object).defaultPredicate
            if predicate.evaluate(with: object) {
                return .update
            } else if !objectHasBeenDeleted {
                return .delete
            }
        }
        return nil
    }
}
