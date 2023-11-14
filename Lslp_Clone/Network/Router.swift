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
    case valid(emial: String)
    
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
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .signup, .login, .valid:
           return [
            "Content-Type": "application/json",
            "SesacKey" : APIKey.secretKey
           ]
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .signup, .login, .valid:
            return .post
        }
    }
    
    var query: [String: String] {
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
        case .valid(emial: let email):
            return [
                "email" : email
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
//        request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(query, into: request)
        // => ❗️타임 아웃 에러 발생
        request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(query, into: request)
        // => ❗️The data couldn’t be read because it is missing.
        print("Router request URL- \(request)")
        return request
    }
    
}
