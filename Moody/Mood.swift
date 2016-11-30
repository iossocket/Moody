//
//  Mood.swift
//  Moody
//
//  Created by XueliangZhu on 11/28/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import CoreData
import UIKit

public final class Mood: ManagedObject {
    @NSManaged public private(set) var date: Date
    @NSManaged public private(set) var colors: Array<UIColor>
}

extension Mood: ManagedObjectType {
    public static var entityName: String {
        return "Mood"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}
