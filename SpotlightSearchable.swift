//
//  SpotlightSearchable.swift
//
//
//  Created by Anıl Göktaş on 1/9/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation
import MobileCoreServices
import CoreSpotlight

protocol SpotlightSearchable: NSObjectProtocol {
    var userActivityType: UserActivityType { get }
    var userActivityUniqueIdentifier: String { get }
    var userActivityAttributeSet: CSSearchableItemAttributeSet { get }
    
    func configureUserActivity()
}

extension SpotlightSearchable where Self: UIViewController {
    
    func configureUserActivity(eligibleForSearch: Bool = true, eligibleForHandoff: Bool = true, eligibleForPublicIndexing: Bool = true) {
        let searchableItem = CSSearchableItem(uniqueIdentifier: userActivityUniqueIdentifier, domainIdentifier: userActivityType.domainIdentifier, attributeSet: userActivityAttributeSet)
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([searchableItem]) { (error) -> Void in
            guard error == nil else {
                AGPrint(error?.localizedDescription)
                return
            }
            
            // Prevent properties to be accessed from incorrect thread
            Async.main {
                // Connect attribute set to indexed searchable item
                let attributeSet = self.userActivityAttributeSet
                attributeSet.relatedUniqueIdentifier = self.userActivityUniqueIdentifier
                
                // Configure user activity
                self.userActivity = NSUserActivity(activityType: self.userActivityType.rawValue)
                self.userActivity?.eligibleForSearch = eligibleForSearch
                self.userActivity?.eligibleForHandoff = eligibleForHandoff
                self.userActivity?.eligibleForPublicIndexing = eligibleForPublicIndexing
                self.userActivity?.userInfo = [self.userActivityType.userInfoKey: self.userActivityUniqueIdentifier]
                self.userActivity?.keywords = UserActivityType.keywords
                self.userActivity?.contentAttributeSet = attributeSet
                self.userActivity?.needsSave = true
                self.userActivity?.becomeCurrent()
            }
        }
    }
    
}