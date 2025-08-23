//
//  FirebaseAuthErrorMapper.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import FirebaseAuth

enum FirebaseAuthError: Int, Error {
    case networkError = 17020
    case userNotFound = 17004
    case wrongPassword = 17009
    case invalidEmail = 17008
    case emailAlreadyInUse = 17007
    case weakPassword = 17026
    case userDisabled = 17005
    case tooManyRequests = 17010
    case operationNotAllowed = 17006
    case unknown = -1
    case invalidGoogleAuth
    case missingClientID
    case missingFacebookToken
    
    var localizedMessage: String {
        switch self {
        case .networkError:
            return "Unable to connect to the internet. Please check your connection."
        case .userNotFound, .wrongPassword:
            return "Incorrect email or password."
        case .invalidEmail:
            return "Invalid email address. Please use a correct format."
        case .emailAlreadyInUse:
            return "This email address is already in use."
        case .weakPassword:
            return "Your password is too weak. Please choose a stronger password."
        case .userDisabled:
            return "This user account has been disabled."
        case .tooManyRequests:
            return "Too many login attempts. Please try again later."
        case .operationNotAllowed:
            return "This operation is currently not allowed. Please contact support."
        case .invalidGoogleAuth:
            return "Google authentication credentials could not be retrieved."
        case .missingClientID:
            return "Google Client ID not found. Please check your Firebase configuration."
        case .missingFacebookToken:
            return "There was an issue with Facebook login. Please try again."
        case .unknown:
            return "An error occurred. Please try again."
        }
    }
    
    static func message(for error: Error) -> String {
        if let customError = error as? FirebaseAuthError {
            return customError.localizedMessage
        }

        let nsError = error as NSError
        let code = FirebaseAuthError(rawValue: nsError.code) ?? .unknown
        return code.localizedMessage
    }
}


