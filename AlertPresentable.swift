//
//  AlertPresentable.swift
//
//
//  Created by Anıl Göktaş on 11/7/15.
//  Copyright © 2015 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol AlertPresentable: class {
    func alert(title title: String, message: String, cancelButtonTitle: String)
}

extension AlertPresentable where Self: UIViewController {
    
    func alert(title title: String, message: String, cancelButtonTitle: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertSomethingWentWrong() {
        alert(title: "Oops!", message: "Something went wrong, please try again.", cancelButtonTitle: "OK")
    }
    
}