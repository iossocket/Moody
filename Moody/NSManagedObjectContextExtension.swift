//
//  NSManagedObjectContextExtension.swift
//  Moody
//
//  Created by XueliangZhu on 11/30/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    public func insertObject<A: ManagedObject>() -> A where A: ManagedObjectType {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performChanges(block: @escaping () -> ()) {
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

public struct ObjectsDidChangeNotification {
    
    init(note: Notification) {
        assert(note.name == NSNotification.Name.NSManagedObjectContextObjectsDidChange)
        notification = note
    }
    
    public var insertedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSInsertedObjectsKey)
    }
    
    public var updatedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSDeletedObjectsKey)
    }
    
    public var refreshedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSRefreshedObjectsKey)
    }
    
    public var invalidatedObjects: Set<ManagedObject> {
        return objectsForKey(key: NSInvalidatedObjectsKey)
    }
    
    public var invalidatedAllObjects: Bool {
        return notification.userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    public var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    
    // MARK: Private
    private let notification: Notification
    
    private func objectsForKey(key: String) -> Set<ManagedObject> {
        return (notification.userInfo?[key] as? Set<ManagedObject>) ?? Set()
    }
    
}

public struct ContextDidSaveNotification {
    
    public init(note: Notification) {
        guard note.name == NSNotification.Name.NSManagedObjectContextDidSave else { fatalError() }
        notification = note
    }
    
    public var insertedObjects: AnyIterator<ManagedObject> {
        return generatorForKey(key: NSInsertedObjectsKey)
    }
    
    public var updatedObjects: AnyIterator<ManagedObject> {
        return generatorForKey(key: NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: AnyIterator<ManagedObject> {
        return generatorForKey(key: NSDeletedObjectsKey)
    }
    
    public var managedObjectContext: NSManagedObjectContext {
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
