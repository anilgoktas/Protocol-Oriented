//
//  KeyboardPresenter.swift
//
//
//  Created by Anıl Göktaş on 5/21/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol KeyboardPresenter: class {
    var keyboardScrollView: UIScrollView { get }
    var activeField: UITextField? { get set }
}

extension KeyboardPresenter where Self: UIViewController {
    
    func configureObserversForKeyboard() {
        notificationCenter.addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: mainOperationQueue) { [weak self] (notification) in
            self?.keyboardDidShow(notification)
        }
        notificationCenter.addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: mainOperationQueue) { [weak self] (notification) in
            self?.keyboardWillBeHidden(notification)
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        guard
        let activeField = activeField,
        let keyboardSizeValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        else { return }
        
        let keyboardSize = keyboardSizeValue.CGRectValue()
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        keyboardScrollView.contentInset = contentInsets
        keyboardScrollView.scrollIndicatorInsets = contentInsets
        
        var frame = view.frame
        frame.size.height -= keyboardSize.size.height
        if !CGRectContainsPoint(frame, activeField.frame.origin) {
            keyboardScrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero
        keyboardScrollView.contentInset = contentInsets
        keyboardScrollView.scrollIndicatorInsets = contentInsets
    }
    
}