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

enum SignupError: Int, Error {
    case isNotRequired = 400
    case isExistUser = 409
    
    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "필수 값을 채워주세요.\n 이메일, 닉네임, 비밀번호는 필수 값입니다."
        case .isExistUser:
            return "이미 가입된 유저입니다."
        }
    }
}

enum LoginError: Int, Error {
    case isNotRequired = 400
    case inNotUser = 401
    
    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "1. 필수 값을 채워주세요. 2. 비밀번호가 일치하지 않습니다."
        case .inNotUser:
            return "가입되지 않은 유저입니다. 계정을 확인해주세요."
        }
    }
}

enum ValidateEmailError: Int, Error {
    case isNotRequeird = 400
    case isExistUser = 409
    
    var errorDescription: String {
        switch self {
        case .isNotRequeird:
            return "필수값을 채워주세요"
        case .isExistUser:
            return "사용이 불가능한 이메일입니다."
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

enum LogOutError: Int, Error {
    case isNotAuth = 401
    case forbidden = 403
    case isExpiration = 419
    
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

enum LikeError: Int, Error {
    case isNotAuth = 401
    case forbidden = 403
    case isNotPost = 410
    case isExpiration = 419
    
    var errorDescripion: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotPost:
            return "게시글을 찾을 수 없습니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}

enum RemovePostError: Int, Error {
    case isNotAuth = 401
    case forbidden = 403
    case isNotPost = 410
    case isExpiration = 419
    case isNotRemove = 445
    
    var errorDescription: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotPost:
            return "게시글을 찾을 수 없습니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        case .isNotRemove:
            return "게시글 삭제 권한이 없습니다."
        }
    }
}

enum CommentPostError: Int, Error {
    case isRequired = 400
    case isNotAuth = 401
    case forbidden = 403
    case isNotPost = 410
    case isExpiration = 419
    
    var errorDescription: String {
        switch self {
        case .isRequired:
            return "필수값이 누락되었습니다."
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotPost:
            return "댓글을 추가할 게시글을 찾을 수 없습니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}


enum CommentRemoveError: Int, Error {
    case isNotAuth = 401
    case forbidden = 403
    case isNotPost = 410
    case isExpiration = 419
    case isNotRemoveRequired = 415
    
    var errorDescription: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isNotPost:
            return "삭제할 댓글을 찾을 수 없습니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        case .isNotRemoveRequired:
            return "댓글 삭제 권한이 없습니다."
        }
    }
}

enum GetProfileError: Int, Error {
    case isNotAuth = 401
    case forbidden = 403
    case isExpiration = 419
    
    var errorDescription: String {
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

enum FollowerError: Int, Error {
    case isNotRequired = 400
    case isNotAuth = 401
    case forbidden = 403
    case alreadyFollow = 409
    case DoNotCheck = 410
    case isExpiration = 419
    
    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "잘못된 요청입니다"
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .alreadyFollow:
            return "이미 팔로잉 된 계정입니다."
        case .DoNotCheck:
            return "팔로잉 되어 있지 않은 계정입니다."
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        }
    }
}

enum DeleteFollowerError: Int, Error {
    case isNotRequired = 400
    case isNotAuth = 401
    case forbidden = 403
    case DoNotCheck = 410
    case isExpiration = 419
    
    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "잘못된 요청입니다"
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .DoNotCheck:
            return "팔로잉 되어 있지 않은 계정입니다."
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
