/*
 KeyboardPresenter
 
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