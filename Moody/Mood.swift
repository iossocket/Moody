//
//  Mood.swift
//  Moody
//
//  Created by XueliangZhu on 11/28/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData
import UIKit

class Mood: ManagedObject {
    @NSManaged private(set) var date: Date
    @NSManaged private(set) var colors: Array<UIColor>
    
    static func insertIntoContext(moc: NSManagedObjectContext, image: UIImage) -> Mood {
        let mood: Mood = moc.insertObject()
        mood.colors = [UIColor.red, UIColor.blue]
        mood.date = Date()
        return mood
    }
}

extension Mood: ManagedObjectType {
    static var entityName: String {
        return "Mood"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
    
    static var defaultPredicate: NSPredicate {
        return NSPredicate(format: "date like %@", "")
    }
}
