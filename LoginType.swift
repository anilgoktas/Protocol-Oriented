//
//  LoginType.swift
// 
//
//  Created by Anıl Göktaş on 5/19/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol LoginType: class {
    var email: String? { get }
    var password: String? { get }
}

// MARK: - Login

typealias LoginResult = () throws -> JSON
typealias AsyncLoginResult = LoginResult -> Void

extension LoginType {
    
    func login(result: AsyncLoginResult) throws {
        let email = try validateEmail()
        let password = try validatePassword()
        
        let parameters = ["email": email, "password": password]
        
        ServiceManager.login(parameters: parameters).responseJSON { (response) in
            // Validate response JSON
            guard let responseJSON = response.result.value
            where response.result.error == nil
            else { result { throw ServiceError.UnknownError }; return }
            
            // Configure response
            let json = JSON(responseJSON)
            let serviceResponse = ServiceResponse(json: json)
            
            switch serviceResponse {
            case .Success:
                User.currentUser.login(email: email, json: json)
                result { return json }
            case .Error(let serviceError):
                result { throw serviceError }
            }
        }
    }
    
}

// MARK: - Validation

extension LoginType {
    
    func validateEmail() throws -> String {
        guard let email = email where email != ""
        else { throw CredentialError.EmptyEmail }
        
        // Validate syntax
        let emailRegex = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluateWithObject(email)
        else { throw CredentialError.InvalidEmail }
        
        return email
    }
    
    func validatePassword() throws -> String {
        guard let password = password where password != ""
        else { throw CredentialError.EmptyPassword }
        return password
    }
    
}

// MARK: - Alert Credentials Error

extension LoginType where Self: AlertPresentable {
    
    func alert(credentialError credentialError: CredentialError) {
        let errorDescription = credentialError.errorDescription
        alert(title: errorDescription.title, message: errorDescription.message, cancelButtonTitle: "OK")
    }
    
    func alert(serviceError serviceError: ServiceError) {
        let errorDescription = serviceError.errorDescription
        alert(title: errorDescription.title, message: errorDescription.message, cancelButtonTitle: "OK")
    }
    
}