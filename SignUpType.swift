//
//  SignUpType.swift
//
//
//  Created by Anıl Göktaş on 5/19/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

protocol SignUpType: LoginType {
    var fullName: String? { get }
    var passwordRepeat: String? { get }
    var city: String? { get }
    var genderString: String? { get }
    var birthDateString: String? { get }
}

// MARK: - SignUp

typealias SignUpResult = () throws -> JSON
typealias AsyncSignUpResult = SignUpResult -> Void

extension SignUpType {
    
    func signUp(result: AsyncSignUpResult) throws {
        let fullName = try validateFullName()
        let email = try validateEmail()
        let city = try validateCity()
        let birthDateString = try validateBirthDateString()
        let genderString = try validateGenderString()
        let password = try validatePassword()
        
        let parameters = ["email": email, "password": password, "name": fullName, "city": city, "gender": genderString, "birthdate": birthDateString]
        
        ServiceManager.signUp(parameters: parameters).responseJSON { (response) in
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

extension SignUpType {
    
    func validateFullName() throws -> String {
        guard let fullName = fullName where !fullName.isEmpty
        else { throw CredentialError.EmptyFullName }
        return fullName
    }
    
    func validateCity() throws -> String {
        guard let city = city where !city.isEmpty
        else { throw CredentialError.EmptyCity }
        return city
    }
    
    func validateGenderString() throws -> String {
        guard let genderString = genderString where !genderString.isEmpty
        else { throw CredentialError.EmptyGender }
        return genderString
    }
    
    func validateBirthDateString() throws -> String {
        guard let birthDateString = birthDateString where !birthDateString.isEmpty
        else { throw CredentialError.EmptyBirthDate }
        return birthDateString
    }
    
    func validatePassword() throws -> String {
        guard let password = password where !password.isEmpty
        else { throw CredentialError.EmptyPassword }
        guard let passwordRepeat = passwordRepeat where !passwordRepeat.isEmpty
        else { throw CredentialError.EmptyPassword }
        guard password == passwordRepeat else { throw CredentialError.PasswordsDontMatch }
        return password
    }
    
}