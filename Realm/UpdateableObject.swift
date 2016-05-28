/*
 UpdateableObject
 
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
import SwiftyJSON
import RealmSwift

protocol UpdateableObject: class {
    associatedtype PrimaryKeyType
    
    var objectKey: PrimaryKeyType { get set }
    
    static func primaryKeyValue(json json: JSON) -> PrimaryKeyType
    func update(json json: JSON)
}

extension UpdateableObject where Self: Object, PrimaryKeyType: Any {
    
    init(json: JSON) {
        self.init()
        
        objectKey = Self.primaryKeyValue(json: json)
        update(json: json)
    }
    
    /**
     Returns all saved objects in this class as Results(lazy) array.
     
     - returns: All saved objects on the Realm.
     */
    static func objects() -> Results<Self> {
        let realm = try! Realm()
        return realm.objects(Self)
    }
    
    /**
     Returns object saved within the Realm if it exists.
     
     - parameter primaryKey: Primary key of the object.
     
     - returns: Saved object on the Realm with the given primary key.
     */
    static func object(primaryKey primaryKey: Any) -> Self? {
        guard let realm = try? Realm() else { return nil }
        guard let primaryKeyObject = primaryKey as? AnyObject else { return nil }
        return realm.objectForPrimaryKey(self, key: primaryKeyObject)
    }
    
    /**
     Either adds object to the Realm or updates the existing one with the given JSON.
     
     - parameter json: Object JSON.
     
     - returns: Saved object on the Realm with the given JSON.
     */
    static func object(json json: JSON) -> Self? {
        guard let realm = try? Realm() else { return nil }
        
        if realm.inWriteTransaction {
            return writeObject(json: json)
        } else {
            realm.beginWrite()
            let object = writeObject(json: json)
            try! realm.commitWrite()
            return object
        }
    }
    
    /**
     Writes object with the given JSON to the Realm. This method **should only be** called **inside** Realm write transaction.
     
     - parameter json: Object JSON.
     
     - returns: Saved object on the Realm with the given JSON.
     */
    static private func writeObject(json json: JSON) -> Self? {
        guard let realm = try? Realm() else { return nil }
        
        // Check whether exists on records
        if let object = object(primaryKey: primaryKeyValue(json: json)) {
            // Update existing one
            object.update(json: json)
            return object
        } else {
            // Add new one to records
            let object = Self(json: json)
            realm.add(object, update: true)
            return object
        }
    }
    
}