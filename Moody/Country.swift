//
//  Country.swift
//  Moody
//
//  Created by XueliangZhu on 12/1/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData

class Country: ManagedObject {
    @NSManaged internal var updatedAt: Date
    
    public private(set) var iso3166Code: ISO3166.Country {
        get {
            guard let c = ISO3166.Country(rawValue: numericISO3166Code) else {
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

extension Country: ManagedObjectType {
    
    static var defaultPredicate: NSPredicate {
        return NSPredicate(format: "updatedAt like %@", "")
    }
    
    static var entityName: String {
        return "Country"
    }
    
    static var defaultSortDescriptions: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }
}

extension Country: LocalizedStringConvertible {
    public var localizedDescription: String {
        return iso3166Code.localizedDescription
    }
}

