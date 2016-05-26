//
//  NotificationObserverType.swift
//
//
//  Created by Anıl Göktaş on 5/25/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol NotificationObserverType: NSObjectProtocol {
    func observeNotification(observable: NotificationObservableType, usingClosure: (notification: NSNotification) -> Void)
    func observeNotification<T: NotificationObservableType>(observable: T.Type, usingClosure: (notification: NSNotification) -> Void)
}

extension NotificationObserverType {
    
    func observeNotification(observable: NotificationObservableType, usingClosure: (notification: NSNotification) -> Void) {
        NSNotificationCenter.defaultCenter().addObserverForName(observable.objectDidConfigureNotificationName, object: nil, queue: .mainQueue(), usingBlock: usingClosure)
    }
    
    func observeNotification<T: NotificationObservableType>(observable: T.Type, usingClosure: (notification: NSNotification) -> Void) {
        NSNotificationCenter.defaultCenter().addObserverForName(observable.objectsDidConfigureNotificationName, object: nil, queue: .mainQueue(), usingBlock: usingClosure)
    }
    
}