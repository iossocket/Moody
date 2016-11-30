//
//  DataProvider.swift
//  Moody
//
//  Created by XueliangZhu on 11/30/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import UIKit

protocol DataProvider: class {
    associatedtype Object
    func object(at indexPath: IndexPath) -> Object
    func numberOfItemsInSection(section: Int) -> Int
}

protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}


enum DataProviderUpdate<Object> {
    case Insert(IndexPath)
    case Update(IndexPath, Object)
    case Move(IndexPath, IndexPath)
    case Delete(IndexPath)
}
