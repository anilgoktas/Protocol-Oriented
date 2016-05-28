/*
 LoginTypePresenter
 
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

protocol LoginTypePresenter: class {
    func userDidSignUp()
    func userDidLogin()
    func userDidCancelLogin()
    func userDidLogOut()
}

extension LoginTypePresenter where Self: UIViewController {
    
    func showLoginView() {
        if
        let shouldLoginNavigationController = R.storyboard.login.initialViewController(),
        let shouldLoginViewController = shouldLoginNavigationController.viewControllers.first as? ShouldLoginViewController {
            // Present LoginViewController with configuration
            shouldLoginViewController.presenter = self
            presentViewController(shouldLoginNavigationController, animated: true, completion: nil)
        }
    }
    
    func userDidSignUp() { dismissViewControllerAnimated(true, completion: nil) }
    
    func userDidLogin() { dismissViewControllerAnimated(true, completion: nil) }
    
    func userDidCancelLogin() { }
    
    func userDidLogOut() { User.currentUser.logOut() }
    
//    func loginWithFacebook() {
//        let facebookLoginManager = FBSDKLoginManager()
//        facebookLoginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) in
//            if error != nil {
//                // Error
//                print(error.localizedDescription)
//            } else if result.isCancelled {
//                // Cancelled
//                print("login is cancelled")
//                self.userDidCancelLogin()
//            } else if result.grantedPermissions.contains("email") {
//                // Successful
//                self.userDidLogin()
//                appDelegate.configureModel()
//                User.currentUser.login()
//            } else {
//                // Warn user app requires email
//            }
//        }
//    }
    
//    func loginWithTwitter() {
//        Twitter.sharedInstance().logInWithCompletion { (session, error) in
//            guard let session = session where error == nil else { return }
//            print("logged in with twitter \(session.userName)")
//            self.userDidLogin()
//            appDelegate.configureModel()
//            User.currentUser.login()
//        }
//    }
    
}