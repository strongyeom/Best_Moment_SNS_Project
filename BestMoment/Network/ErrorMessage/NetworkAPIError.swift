//
//  NetworkAPIError.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/15.
//

import Foundation

enum SectionAPI {
    case signup
    case login
    case valid
    case addPost
    case getPost
    case modifyPost
    case refresh
    case deleteAccount
    case like
    case removePost
    case commentPost
    case removeComment
    case getLikes
    case getProfile
    case putProfile
    case follow
    case unFollower
    case searchUserPost
    case anotherGetProfile
}

// 1) message 넣는 방법으로 만들어보기
// 2) 상태코드에 따라서 enum의 이니셜라이저 만들어보기 (=실패 가능한 이니셜라이저)
// 3) 에러 message를 관리하는 객체 만들기

struct ErrorMessage {
    let status: Int
    let section: SectionAPI
    
    var description: String {
        
        switch status {
        case 400 :
            switch section {
            case .valid, .login:
                return "필수 값을 채워주세요"
            case .addPost, .getPost, .modifyPost, .getLikes, .follow, .unFollower, .putProfile:
                return "잘못된 요청입니다."
            case .commentPost:
                return "필수값이 누락되었습니다."
            default:
                return "필수 값을 채워주세요 - default"
            }
            
        case 401:
            switch section {
            case .refresh, .deleteAccount, .addPost, .getPost, .modifyPost, .removePost, .commentPost, .removeComment, .like, .getLikes, .follow, .unFollower, .getProfile, .putProfile, .anotherGetProfile:
                return "인증 할 수 없는 엑세스 토큰입니다."
            default:
                return "계정을 확인해주세요"
            }
        case 403:
            return "Forbidden"
        case 409:
            switch section {
            case .valid:
                return "이미 가입된 유저 입니다."
            case .refresh:
                return "토큰이 만료되지 않았습니다."
            case .follow:
                return "이미 팔로잉된 계정입니다."
            default:
                return "409 - default"
            }
        case 410:
            switch section {
            case .addPost:
                return "생성된 게시글이 없습니다."
            case .modifyPost:
                return "수정할 게시글을 찾을 수 없습니다."
            case .removePost:
                return "삭제할 게시글을 찾을 수 없습니다."
            case .commentPost:
                return "댓글을 추가할 게시글을 찾을 수 없습니다."
            case .removeComment:
                return "삭제할 댓글을 찾을 수 없습니다."
            case .like:
                return "게시글을 찾을 수 없습니다."
            case .follow, .unFollower:
                return "알 수 없는 계정입니다."
            default:
                return "410 - default"
            }
        case 418:
            return "리프레쉬 토큰이 만료되었습니다. 다시 로그인 해주세요."
        case 419:
            return "엑세스 토큰이 만료되었습니다."
        case 420:
            return "This service sesac_memolease only"
        case 429:
            return "과호출 입니다."
        case 444:
            return "돌아가 여기 자네가 올 곳이 아니야"
        case 445:
            switch section {
            case .modifyPost:
                return "게시글 수정 권한이 없습니다."
            case .removePost:
                return "게시글 삭제 권한이 없습니다."
            case .removeComment:
                return "댓글 삭제 권한이 없습니다."
            default:
                return "445 - default"
            }
        case 500:
            return "SeverError"
        default:
            return ""
        }
    }
    
}

enum NetworkAPIError: Error, CustomStringConvertible  {
    case isNotRequired(message: String)
    case isNotUser(message: String)
    case forbidden(message: String)
    case isExistUser(message: String)
    case isNotPost(message: String)
    case isNotRemoveRequired(message: String)
    case isRefreshExpiration(message: String)
    case isExpiration(message: String)
    case serviceOnly(message: String)
    case overNetwork(message: String)
    case isValid(message: String)
    case isNotRemove(message: String)
    case serverError(message: String)
    
    init?(statusCode: Int, message: String) {
        switch statusCode {
        case 400:
            self = .isNotRequired(message: message)
        case 401:
            self = .isNotUser(message: message)
        case 403:
            self = .forbidden(message: message)
        case 409:
            self = .isExistUser(message: message)
        case 410:
            self = .isNotPost(message: message)
        case 415:
            self = .isNotRemoveRequired(message: message)
        case 418:
            self = .isRefreshExpiration(message: message)
        case 419:
            self = .isExpiration(message: message)
        case 420:
            self = .serviceOnly(message: message)
        case 429:
            self = .overNetwork(message: message)
        case 444:
            self = .isValid(message: message)
        case 445:
            self = .isNotRemove(message: message)
        case 500:
            self = .serverError(message: message)
        default:
            return nil
        }
    }
    
    var description: String {
        switch self {
        case .isNotRequired(let message):
            return message
        case .isNotUser(let message):
            return message
        case .forbidden(let message):
            return message
        case .isExistUser(let message):
            return message
        case .isNotPost(let message):
            return message
        case .isNotRemoveRequired(let message):
            return message
        case .isRefreshExpiration(let message):
            return message
        case .isExpiration(let message):
            return message
        case .serviceOnly(let message):
            return message
        case .overNetwork(let message):
            return message
        case .isValid(let message):
            return message
        case .isNotRemove(let message):
            return message
        case .serverError(let message):
            return message
        }
    }
    
}
