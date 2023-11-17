//
//  APIManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation
import RxSwift
import Alamofire




class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    /// 회원가입
    func requestSignup(api: Router) -> Observable<JoinResponse> {
        return Observable<JoinResponse>.create { observer in
        
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: JoinResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("회원가입 상태 코드 ", status)
                   // print("----", response.result)
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(_):
                            switch status {
                            case 420:
                                observer.onError(CommonError.serviceOnly)
                            case 429:
                                observer.onError(CommonError.overNetwork)
                            case 444:
                                observer.onError(CommonError.inValid)
                            case 400:
                                observer.onError(SignupError.isNotRequired)
                            case 409:
                                observer.onError(SignupError.isExistUser)
                            case 500:
                                observer.onError(CommonError.serverError)
                            default:
                                break
                            }
                        }
                 
                }
            return Disposables.create()
        }
    }

    ///로그인
    func reqeustLogin(api: Router) -> Observable<TokenResponse> {
        return Observable<TokenResponse>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: TokenResponse.self) {
                    response in
                    
                    
                    guard let status = response.response?.statusCode else { return}
                    print("Login 상태 코드 ", status)
                    
                  
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                          
                        case .failure(let error):
                            print(error.localizedDescription)
                            switch status {
                            case 420:
                                observer.onError(CommonError.serviceOnly)
                            case 429:
                                observer.onError(CommonError.overNetwork)
                            case 444:
                                observer.onError(CommonError.inValid)
                            case 400:
                                observer.onError(LoginError.isNotRequired)
                            case 401:
                                observer.onError(LoginError.inNotUser)
                            case 500:
                                observer.onError(CommonError.serverError)
                            default:
                                break
                            }
                        }
                   
                }
            return Disposables.create()
        }
    }
    
    /// 이메일 검증
    func requestIsValidateEmail(api: Router) -> Observable<ValidateEmailResponse> {
        return Observable<ValidateEmailResponse>.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: ValidateEmailResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("이메일 검증 상태 코드 ", status)
                    
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                           
                        case .failure(let error):
                            print(error.localizedDescription)
                            switch status {
                            case 420:
                                observer.onError(CommonError.serviceOnly)
                            case 429:
                                observer.onError(CommonError.overNetwork)
                            case 444:
                                observer.onError(CommonError.inValid)
                            case 400:
                                observer.onError(ValidateEmailError.isNotRequeird)
                            case 409:
                                observer.onError(ValidateEmailError.isExistUser)
                            case 500:
                                observer.onError(CommonError.serverError)
                            default:
                                break
                            }
                        }
                
                    
                }

            return Disposables.create()
        }
        .debug()
    }
    
    /// 컨텐츠
    func requestContent(api: Router) -> Observable<ContentResponse> {
        return Observable<ContentResponse>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: ContentResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("컨텐츠 상태 코드 ", status)
                    
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                            switch status {
                            case 420:
                                observer.onError(CommonError.serviceOnly)
                            case 429:
                                observer.onError(CommonError.overNetwork)
                            case 444:
                                observer.onError(CommonError.inValid)
                            case 401:
                                observer.onError(ContentError.isNotAuth)
                            case 403:
                                observer.onError(ContentError.forbidden)
                            case 419:
                                observer.onError(ContentError.isExpiration)
                            default:
                                observer.onError(CommonError.serverError)
                            }
                        }
                 
                }
            return Disposables.create()
        }
    }
    
    /// 리프레쉬 토큰
    func requestRefresh(api: Router) -> Observable<RefreshResponse> {
        return Observable<RefreshResponse>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: RefreshResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("리프레쉬 상태 코드 ", status)
                    
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                           
                        case .failure(let error):
                            print(error.localizedDescription)
                            switch status {
                            case 420:
                                observer.onError(CommonError.serviceOnly)
                            case 429:
                                observer.onError(CommonError.overNetwork)
                            case 444:
                                observer.onError(CommonError.inValid)
                            case 401:
                                observer.onError(RefreshError.isNotAuth)
                            case 403:
                                observer.onError(RefreshError.forbidden)
                            case 409:
                                observer.onError(RefreshError.isNotExpiration)
                            case 418:
                                observer.onError(RefreshError.isRefreshExpiration)
                            case 500:
                                observer.onError(CommonError.serverError)
                            default:
                                break
                            }
                        }
                 
                }
            return Disposables.create()
        }
       
    }
    
    
    /// 회원 탈퇴
    func requestLogOut(api: Router) -> Observable<LogOutResponse> {
        
        return Observable<LogOutResponse>.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: LogOutResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("회원탈퇴 상태 코드 ", status)
                    
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                         
                        case .failure(let error):
                            print(error.localizedDescription)
                            switch status {
                            case 420:
                                observer.onError(CommonError.serviceOnly)
                            case 429:
                                observer.onError(CommonError.overNetwork)
                            case 444:
                                observer.onError(CommonError.inValid)
                            case 401:
                                observer.onError(LogOutError.isNotAuth)
                            case 403:
                                observer.onError(LogOutError.forbidden)
                            case 419:
                                observer.onError(LogOutError.isExpiration)
                            case 500:
                                observer.onError(CommonError.serverError)
                            default:
                                break
                            }
                        }
                   
                }
            return Disposables.create()
        }
    }
}
