//
//  Router.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    private static let key = APIKey.secretKey
    
    case signup(email: String, password: String, nickname: String)
    case login(email: String, password: String)
    case valid(email: String)
    case addPost(accessToken: String, content: String, product_id: String)
    case readPost(accessToken: String, next: String, limit: String, product_id: String)
    case modifyPost(asccessToken: String, postID: String, content: String, product_id: String)
    case refresh(access: String, refresh: String)
    case deleteAccount(access: String)
    case like(access: String, postID: String)
    case removePost(access: String, postID: String)
    case commentPost(access: String, postID: String, comment: String)
    case removeComment(access: String, postID: String, commentID: String)
    case getLikes(accessToken: String, next: String, limit: String)
    case getProfile(accessToken: String)
    case putProfile(accessToken: String, nick: String)
    case follow(accessToken: String, userID: String)
    case unFollower(accessToken: String, userID: String)
    case anotherGetProfile(accessToken: String, userID: String)
    
    
    var baseURL: URL {
        return URL(string: BaseAPI.baseUrl)!
    }
    
    
    
    var path: String {
        switch self {
        case .signup:
            return "join"
        case .login:
            return "login"
        case .valid:
            return "validation/email"
        case .addPost, .readPost:
            return "post"
        case .modifyPost(asccessToken: _, postID: let postID, content: _, product_id: _):
            return "post/\(postID)"
        case .refresh:
            return "refresh"
        case .deleteAccount:
            return "withdraw"
        case .like(access: _, postID: let id):
            return "post/like/\(id)"
        case .removePost(access: _, postID: let id):
            return "post/\(id)"
        case .commentPost(access: _, postID: let id, comment: _):
            return "post/\(id)/comment"
        case .removeComment(access: _, postID: let id, commentID: let commentID):
            return "post/\(id)/comment/\(commentID)"
        case .getLikes:
            return "post/like/me"
        case .getProfile, .putProfile:
            return "profile/me"
        case
                .follow(accessToken: _, userID: let userID),
                .unFollower(accessToken: _, userID: let userID):
            return "follow/\(userID)"
        case .anotherGetProfile(accessToken: _, userID: let userID):
            return "profile/\(userID)"
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .signup, .login, .valid:
           return [
            "Content-Type": "application/json",
            "SesacKey" : APIKey.secretKey
           ]
        case .addPost(accessToken: let token, content: _, product_id: _),
                .putProfile(accessToken: let token, nick: _),
                .modifyPost(asccessToken: let token, postID: _, content: _, product_id: _):
            return [
                "Authorization" : token,
                "Content-Type": "multipart/form-data",
                "SesacKey" : APIKey.secretKey
            ]
        case .refresh(access: let toekn, refresh: let refresh):
            return [
                "Authorization" : toekn,
                "SesacKey" : APIKey.secretKey,
                "Refresh": refresh
            ]
        case .deleteAccount(access: let token),
                .readPost(accessToken: let token, next: _, limit: _, product_id: _ ),
                .like(access: let token, postID: _),
                .removePost(access: let token, postID: _),
                .removeComment(access: let token, postID: _, commentID: _),
                .getLikes(accessToken: let token, next: _, limit: _),
                .getProfile(accessToken: let token),
                .unFollower(accessToken: let token, userID: _),
                .follow(accessToken: let token, userID: _),
                .anotherGetProfile(accessToken: let token, userID: _):
            return [
                "Authorization" : token,
                "SesacKey" : APIKey.secretKey
            ]
        case .commentPost(access: let token, postID: _, comment: _):
            return [
                "Authorization" : token,
                "Content-Type": "application/json",
                "SesacKey" : APIKey.secretKey
            ]
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .signup,
                .login,
                .valid,
                .deleteAccount,
                .addPost,
                .like,
                .commentPost,
                .follow:
            return .post
        case .refresh, .readPost, .getLikes, .getProfile, .anotherGetProfile:
            return .get
        case .removePost, .removeComment, .unFollower:
            return .delete
        case .putProfile, .modifyPost:
            return .put
        }
    }
    
    var query: [String: String]? {
        switch self {
        case .signup(email: let email, password: let password, nickname: let nickname):
            return [
                "email": email,
                "password": password,
                "nick": nickname
            ]
        case .login(email: let email, password: let password):
            return [
                "email": email,
                "password": password
            ]
        case .valid(email: let email):
            return [
                "email" : email
            ]
        case .addPost(accessToken: _, content: let content, product_id: let product_id),
                .modifyPost(asccessToken: _, postID: _, content: let content, product_id: let product_id):
            return [
                "content" : content,
                "product_id" : product_id
            ]
            
        case .readPost(accessToken: _, next: let next, limit: let limit, product_id: let product_id):
            return [
                "next" : next,
                "limit" : limit,
                "product_id" : product_id
            ]
        case .getLikes(accessToken: _, next: let next, limit: let limit):
            return [
                "next": next,
                "limit": limit
            ]
        case .refresh,
                .deleteAccount,
                .like,
                .removePost,
                .removeComment,
                .getProfile,
                .follow,
                .unFollower,
                .anotherGetProfile:
            return nil
        case .commentPost(access: _, postID: _, comment: let content):
            return [
                "content" : content
            ]
            
        case .putProfile(accessToken: _, nick: let nickname):
            return [
                "nick" : nickname
            ]
        }
    }
    
    

    // asURLRequest() 만 외부에서 사용할 것이기 때문에 그 외의 프로퍼티는 private으로 설정해준다.
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        // 헤더 및 메서드 추가
        request.headers = header
        request.method = method
        
        // encoding ~ 했던것 처럼 추가 코드 필요, 오픈 API 사용시 destination: .methodDependent 많이 씀
      
        // => ❗️타임 아웃 에러 발생

        switch self {
        case .addPost, .refresh, .like, .removePost, .readPost, .removeComment, .getLikes, .getProfile, .putProfile, .follow, .unFollower, .modifyPost, .anotherGetProfile:
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        default:
            request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(query, into: request)
        }
//        print("request - \(request)")
        // => ❗️The data couldn’t be read because it is missing.
//        print("Router request URL- \(request)")
        return request
    }
    
}
