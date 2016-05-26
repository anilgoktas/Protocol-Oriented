//
//  NotificationObservableType.swift
//
//
//  Created by Anıl Göktaş on 5/25/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol NotificationObservableType: class {
    var objectDidConfigureNotificationName: String { get }
    static var objectsDidConfigureNotificationName: String { get }
}

extension NotificationObservableType {
    
    func postDidUpdateNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(objectDidConfigureNotificationName, object: nil)
    }
    
    static func postDidUpdateNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(objectsDidConfigureNotificationName, object: nil)
    }
    
}