//
//  NetworkErrorCollections.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/17.
//

import Foundation

enum CommonError: Int, Error, CaseIterable {
    case serviceOnly = 420
    case overNetwork = 429
    case inValid = 444
    case serverError = 500
    
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

enum AddPostError: Int, Error {
    case isRequest = 400
    case isNotPost = 410
    case isNotAuth = 401
    case forbidden = 403
    case isExpiration = 419
    
    var errorDescrtion: String {
        switch self {
        case .isRequest:
            return "잘못된 요청입니다.\n파일의 제한사항과 맞지 않습니다."
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotPost:
            return "생성된 게시글이 없습니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}

enum ReadPostError: Int, Error {
    case isNotRequest = 400
    case isNotAuth = 401
    case forbidden = 403
    case isExpiration = 419
    
    var errorDescrtion: String {
        switch self {
        case .isNotRequest:
            return "잘못된 요청입니다."
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "잘못된 접근 입니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}


enum RefreshError: Int, Error {
    case isNotAuth = 401
    case forbidden = 403
    case isNotExpiration = 409
    case isRefreshExpiration = 418
    
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

enum PutProfileError: Int, Error {
    case isNotRequired = 400
    case isNotAuth = 401
    case forbidden = 403
    case isExpiration = 419
    
    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "파일 형식 맞지 않습니다."
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}

enum ModifyError: Int, Error {
    case isNotRequired = 400
    case isNotAccess = 401
    case forbidden = 403
    case isNotFind = 410
    case isExpiration = 419
    case isNotAuth = 445
    
    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "파일 형식 맞지 않습니다."
        case .isNotAccess:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotFind:
            return "수정할 게시글을 찾을 수 없습니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        case .isNotAuth:
            return "게시글 수정 권한이 없습니다."
        }
    }
}
