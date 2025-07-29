//
//  FirebaseAuthErrorMapper.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 29.07.2025.
//

import FirebaseAuth

enum FirebaseAuthError: Int {
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
    
    var localizedMessage: String {
        switch self {
        case .networkError:
            return "İnternet bağlantısı kurulamadı. Lütfen bağlantınızı kontrol edin."
        case .userNotFound, .wrongPassword:
            return "E-posta veya şifre hatalı."
        case .invalidEmail:
            return "Geçersiz e-posta adresi. Lütfen doğru bir format kullanın."
        case .emailAlreadyInUse:
            return "Bu e-posta adresi zaten kullanılıyor."
        case .weakPassword:
            return "Şifreniz çok zayıf. Lütfen daha güçlü bir şifre belirleyin."
        case .userDisabled:
            return "Bu kullanıcı hesabı devre dışı bırakılmış."
        case .tooManyRequests:
            return "Çok fazla giriş denemesi yapıldı. Lütfen daha sonra tekrar deneyin."
        case .operationNotAllowed:
            return "Bu işlem şu anda devre dışı. Lütfen destekle iletişime geçin."
        case .unknown:
            return "Bir hata oluştu. Lütfen tekrar deneyin."
        }
    }
    
    static func message(for error: Error) -> String {
        let nsError = error as NSError
        let code = FirebaseAuthError(rawValue: nsError.code) ?? .unknown
        return code.localizedMessage
    }
}


