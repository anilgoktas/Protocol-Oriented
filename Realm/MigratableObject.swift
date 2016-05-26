//
//  MigratableObject.swift
//
//
//  Created by Anıl Göktaş on 5/26/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation
import RealmSwift

protocol MigratableObject {
    static func migrate(migration migration: Migration, oldSchemaVersion: UInt64)
}

extension MigratableObject {
    
    static func migrate(migration migration: Migration, oldSchemaVersion: UInt64) {
        
    }
    
}