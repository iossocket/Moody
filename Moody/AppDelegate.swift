//
//  AppDelegate.swift
//  Moody
//
//  Created by XueliangZhu on 11/28/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let managedObjectContext = createMoodyMainContext()
        let nav = window?.rootViewController as! UINavigationController
        (nav.topViewController as! RootViewController).managedObjectContext = managedObjectContext
        return true
    }
}


func createMoodyMainContext() -> NSManagedObjectContext {
    let bundles = [Bundle(for: Mood.self)]
    guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
        fatalError("modal not found")
    }
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URL.getDocumentUrlByName("Moody.moody"), options: nil)
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    return context
}
