//
//  AuthError.swift
//  featrrrnew
//
//  Created by Buddie Booking on 11/27/23.
//

import Foundation
import Firebase

enum AuthError: Error {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case weakPassword
    case unknown
    
    init(authErrorCode: AuthErrorCode.Code) {
        switch authErrorCode {
        case .invalidEmail:
            self = .invalidEmail
        case .wrongPassword:
            self = .invalidPassword
        case .weakPassword:
            self = .weakPassword
        case .userNotFound:
            self = .userNotFound
        default:
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "The email you entered is invalid. Please try again"
        case .invalidPassword:
            return "Incorrect password. Please try again"
        case .userNotFound:
            return "It looks like there is no account associated with this email. Create an account to continue"
        case .weakPassword:
            return "Your password must be at least 6 characters in length. Please try again."
        case .unknown:
            return "An unknown error occured. Please try again."
        }
    }
}
