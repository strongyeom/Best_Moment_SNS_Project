//
//  NetworkErrorCollections.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/17.
//

import Foundation

enum CommonError: Error {
    case serviceOnly
    case overNetwork
    case inValid
    case serverError
    
    var errorAPIDescription: String {
        switch self {
        case .serviceOnly:
            return "This service sesac_memolease Only"
        case .overNetwork:
            return "과호출입니다."
        case .inValid:
            return "돌아가 여긴 자네가 올 곳이 아니야"
        case .serverError:
            return "서버 오류입니다."
        }
    }
}

enum SignupError: Error {
    case isNotRequired
    case isExistUser

    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "필수 값을 채워주세요.\n 이메일, 닉네임, 비밀번호는 필수 값입니다."
        case .isExistUser:
            return "이미 가입된 유저입니다."
        }
    }
}

enum LoginError: Error {
    case isNotRequired
    case inNotUser

    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "1. 필수 값을 채워주세요. 2. 비밀번호가 일치하지 않습니다."
        case .inNotUser:
            return "가입되지 않은 유저입니다. 계정을 확인해주세요."
        }
    }
}

enum ValidateEmailError: Error {
    case isNotRequeird
    case isExistUser
    
    var errorDescription: String {
        switch self {
        case .isNotRequeird:
            return "필수값을 채워주세요"
        case .isExistUser:
            return "사용이 불가능한 이메일입니다."
        }
    }
}

enum ContentError: Error {
    case isNotAuth
    case forbidden
    case isExpiration
    
    var errorDescrtion: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}

enum RefreshError: Error {
    case isNotAuth
    case forbidden
    case isNotExpiration
    case isRefreshExpiration
    
    var errorDescription: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotExpiration:
            return "엑세스 토큰이 만료되지 않았습니다."
        case .isRefreshExpiration:
            return "리프레쉬 토큰이 만료되었습니다. 다시 로그인 해주세요"
        }
    }
}

enum LogOutError: Error {
    case isNotAuth
    case forbidden
    case isExpiration
    
    var errorDescrtion: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}
