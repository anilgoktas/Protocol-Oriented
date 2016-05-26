//
//  LoginViewDelegate.swift
//
//
//  Created by Anıl Göktaş on 4/27/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

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