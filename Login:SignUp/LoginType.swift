/*
 LoginType
 
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
        guard let email = email where !email.isEmpty
        else { throw CredentialError.EmptyEmail }
        
        // Validate syntax
        let emailRegex = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluateWithObject(email)
        else { throw CredentialError.InvalidEmail }
        
        return email
    }
    
    func validatePassword() throws -> String {
        guard let password = password where !password.isEmpty
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