//
//  URLExtension.swift
//  Moody
//
//  Created by XueliangZhu on 11/28/16.
//  Copyright © 2016 ThoughtWorks. All rights reserved.
//

import Foundation

extension URL {
//    static var documentsURL: URL {
//        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//    }
    
    static func getDocumentUrlByName(_ name: String) -> URL {
        let url: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url.appendingPathComponent(name)
    }
}
