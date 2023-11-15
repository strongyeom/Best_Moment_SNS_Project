//
//  APIManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: Error {
    case inValidURL
    case unkwoned
    case networkError
    
    var errorAPIDescription: String {
        switch self {
        case .inValidURL:
            return "유효하지 않은 주소입니다."
        case .unkwoned:
            return "원인을 알 수 없는 오류입니다."
        case .networkError:
            return "네트워크 오류입니다."
        }
    }
}

enum SignupError: Error {
    case isNotRequired
    case isExistUser
    case severError

    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "필수 값을 채워주세요."
        case .isExistUser:
            return "이미 가입된 유저입니다."
        case .severError:
            return "서버 에러입니다."
        }
    }
}

enum LoginError: Error {
    case isNotRequired
    case inNotUser
    case severError

    var errorDescription: String {
        switch self {
        case .isNotRequired:
            return "1. 필수 값을 채워주세요. 2. 비밀번호가 일치하지 않습니다."
        case .inNotUser:
            return "가입되지 않은 유저입니다."
        case .severError:
            return "서버 에러입니다."
        }
    }
}

enum ValidateEmailError: Error {
    case isNotRequeird
    case isExistUser
    case serverError
    
    var errorDescription: String {
        switch self {
        case .isNotRequeird:
            return "필수값을 채워주세요"
        case .isExistUser:
            return "이미 사용중인 이메일 입니다."
        case .serverError:
            return "서버 오류 입니다."
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
    case serverError
    
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
        case .serverError:
            return "서버 오류 입니다."
        }
    }
}

enum LogOutError: Error {
    case isNotAuth
    case forbidden
    case isExpiration
    case severError
    
    var errorDescrtion: String {
        switch self {
        case .isNotAuth:
            return "인증 할 수 없는 엑세스 토큰입니다."
        case .forbidden:
            return "Forbidden"
        case .isExpiration:
            return "엑세스 토큰이 만료되었습니다."
        case .severError:
            return "서버 오류입니다."
        }
    }
}


class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    /// 회원가입
    func request(api: Router) -> Observable<JoinResponse> {
        return Observable<JoinResponse>.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200..<500)
                .responseDecodable(of: JoinResponse.self) { response in
                    print("APIManager - StatusCode : \(response.response!.statusCode)")
                    
                    guard let status = response.response?.statusCode else { return }
                    print("회원가입 상태 코드 ", status)
                    switch status {
                    case 200:
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                            observer.onError(APIError.networkError)
                        }
                    case 400:
                        observer.onError(SignupError.isNotRequired)
                    case 409:
                        observer.onError(SignupError.isExistUser)
                    case 500:
                        observer.onError(SignupError.severError)
                    default:
                        break
                    }
                }
            return Disposables.create()
        }
    }
    
    ///로그인
    func reqeustLogin(api: Router) -> Observable<TokenResponse> {
        return Observable<TokenResponse>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: TokenResponse.self) {
                    response in
                    
                    
                    guard let status = response.response?.statusCode else { return}
                    print("Login 상태 코드 ", status)
                    
                    switch status {
                    case 200:
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    case 400:
                        observer.onError(LoginError.isNotRequired)
                    case 401:
                        observer.onError(LoginError.inNotUser)
                    case 500:
                        observer.onError(LoginError.severError)
                    default:
                        break
                    }
                }
            return Disposables.create()
        }
    }
    
    /// 이메일 검증
    func requestIsValidateEmail(api: Router) -> Observable<ValidateEmailResponse> {
        return Observable<ValidateEmailResponse>.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: ValidateEmailResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("이메일 검증 상태 코드 ", status)
                    switch status {
                    case 200:
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    case 400:
                        observer.onError(ValidateEmailError.isNotRequeird)
                    case 409:
                        observer.onError(ValidateEmailError.isExistUser)
                    case 500:
                        observer.onError(ValidateEmailError.serverError)
                    default:
                        break
                    }
                    
                }
            return Disposables.create()
        }
    }
    
    /// 컨텐츠
    func requestContent(api: Router) -> Observable<ContentResponse> {
        return Observable<ContentResponse>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: ContentResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("컨텐츠 상태 코드 ", status)
                    switch status {
                    case 200:
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                            observer.onError(APIError.networkError)
                        }
                    case 401:
                        observer.onError(ContentError.isNotAuth)
                    case 403:
                        observer.onError(ContentError.forbidden)
                    case 419:
                        observer.onError(ContentError.isExpiration)
                    default:
                        break
                    }
                }
            return Disposables.create()
        }
    }
    
    /// 리프레쉬 토큰
    func requestRefresh(api: Router) -> Observable<RefreshResponse> {
        return Observable<RefreshResponse>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: RefreshResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("리프레쉬 상태 코드 ", status)
                    switch status {
                    case 200:
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                            observer.onError(APIError.networkError)
                        }
                    case 401:
                        observer.onError(RefreshError.isNotAuth)
                    case 403:
                        observer.onError(RefreshError.forbidden)
                    case 409:
                        observer.onError(RefreshError.isNotExpiration)
                    case 418:
                        observer.onError(RefreshError.isRefreshExpiration)
                    case 500:
                        observer.onError(RefreshError.serverError)
                    default:
                        break
                    }
                }
            return Disposables.create()
        }
       
    }
    
    
    /// 회원 탈퇴
    func requestLogOut(api: Router) -> Observable<LogOutResponse> {
        
        return Observable<LogOutResponse>.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: LogOutResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("회원탈퇴 상태 코드 ", status)
                    switch status {
                    case 200:
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    case 401:
                        observer.onError(LogOutError.isNotAuth)
                    case 403:
                        observer.onError(LogOutError.forbidden)
                    case 419:
                        observer.onError(LogOutError.isExpiration)
                    case 500:
                        observer.onError(LogOutError.severError)
                    default:
                        break
                    }
                }
            return Disposables.create()
        }
    }
}
