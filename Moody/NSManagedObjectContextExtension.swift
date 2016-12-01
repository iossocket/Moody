//
//  NSManagedObjectContextExtension.swift
//  Moody
//
//  Created by XueliangZhu on 11/30/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func insertObject<A: ManagedObject>() -> A where A: ManagedObjectType {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}

extension NSManagedObjectContext {
    func addContextDidSaveNotificationObserver(handler: @escaping (ContextDidSaveNotification) -> ()) -> NSObjectProtocol {
        let nc = NotificationCenter.default
        return nc.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: self, queue: nil) { note in
            let wrappedNote = ContextDidSaveNotification(note: note)
            handler(wrappedNote)
        }
    }
    
    func addObjectsDidChangeNotificationObserver(handler: @escaping (ObjectsDidChangeNotification) -> ()) -> NSObjectProtocol {
        let nc = NotificationCenter.default
        return nc.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: self, queue: nil) { note in
            let wrappedNote = ObjectsDidChangeNotification(note: note)
            handler(wrappedNote)
        }
    }
}

struct ObjectsDidChangeNotification {
    
    init(note: Notification) {
        assert(note.name == NSNotification.Name.NSManagedObjectContextObjectsDidChange)
        notification = note
    }
    
    var insertedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSInsertedObjectsKey)
    }
    
    var updatedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSUpdatedObjectsKey)
    }
    
    var deletedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSDeletedObjectsKey)
    }
    
    var refreshedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSRefreshedObjectsKey)
    }
    
    var invalidatedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSInvalidatedObjectsKey)
    }
    
    var invalidatedAllObjects: Bool {
        return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    
    // MARK: Private
    private let notification: Notification
    
    private func objectsForKey(key: String) -> Set<ManagedObject> {
        return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
    }
    
}

struct ContextDidSaveNotification {
    
    init(note: Notification) {
        guard note.name == NSNotification.Name.NSManagedObjectContextDidSave else { fatalError() }
        notification = note
    }
    
    var insertedObjects: AnyIterator<ManagedObject> {
        return generatorForKey(key: NSInsertedObjectsKey)
    }
    
    var updatedObjects: AnyIterator<ManagedObject> {
        return generatorForKey(key: NSUpdatedObjectsKey)
    }
    
    var deletedObjects: AnyIterator<ManagedObject> {
        return generatorForKey(key: NSDeletedObjectsKey)
    }
    
    var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    
    // MARK: Private
    private let notification: Notification
    
    private func generatorForKey(key: String) -> AnyIterator<ManagedObject> {
        guard let set = notification.userInfo?[key] as? NSSet else {
            return AnyIterator { nil }
        }
        let innerGenerator = set.makeIterator()
        return AnyIterator { return innerGenerator.next() as? ManagedObject }
    }
    
}
