/*
 SpotlightSearchable
 
 Copyright © 2016 Anıl Göktaş.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

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