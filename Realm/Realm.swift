//
//  Realm.swift
//
//
//  Created by Anıl Göktaş on 5/25/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    
    class func configureMigration(completion: () -> Void) {
        let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            // MigratableObject.migrate(..)
            completion()
        }
        
        let configuration = Realm.Configuration(schemaVersion: NSBundle.applicationBuildNumberUInt64, migrationBlock: migrationBlock)
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = configuration
        
        let _ = try! Realm()
        
        if NSBundle.applicationBuildNumberUInt64 == Realm.Configuration.defaultConfiguration.schemaVersion {
            completion()
        }
    }
    
}