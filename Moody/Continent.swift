//
//  Continent.swift
//  Moody
//
//  Created by XueliangZhu on 12/1/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData

class Continent: ManagedObject {
    @NSManaged internal var updatedAt: Date
    
    public private(set) var iso3166Code: ISO3166.Continent {
        get {
            guard let c = ISO3166.Continent(rawValue: numericISO3166Code) else {
                fatalError("Unknown country code")
            }
            return c
        }
        set {
            numericISO3166Code = newValue.rawValue
        }
    }
    
    @NSManaged private var numericISO3166Code: Int16
}

extension Continent: ManagedObjectType {
    
    static var defaultPredicate: NSPredicate {
        return NSPredicate(format: "updatedAt like %@", "")
    }

    static var entityName: String {
        return "Continent"
    }
    
    static var defaultSortDescriptions: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}
