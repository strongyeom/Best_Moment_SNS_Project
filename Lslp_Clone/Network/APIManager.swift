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
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                                if let signupError = SignupError(rawValue: status) {
                                print("SignupError - \(signupError)")
                                observer.onError(signupError)
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
                          
                        case .failure(_):
                           // print(error.localizedDescription)
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                       
                            if let loginError = LoginError(rawValue: status) {
                                print("LoginError - \(loginError)")
                                observer.onError(loginError)
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
                           
                        case .failure(_):
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                            
                            if let validateEmailError = ValidateEmailError(rawValue: status) {
                                
                                print("validateEmailError - \(validateEmailError)")
                                observer.onError(validateEmailError)
                            }
                        }
                
                    
                }

            return Disposables.create()
        }
        .debug()
    }
    
    /// 게시글 작성하기
    func requestAddPost(api: Router) -> Observable<ContentResponse> {
        return Observable<ContentResponse>.create { observer in
            AF.upload(multipartFormData: { multiPartForm in
            
                multiPartForm.append(Data("title".utf8), withName: "title", mimeType: "text/plain")
            }, with: api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: ContentResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("컨텐츠 상태 코드 ", status)
                    
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                        case .failure(let error):
                            print(error.localizedDescription)
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                            
                            if let contentError = ContentError(rawValue: status) {
                                
                                print("contentError - \(contentError)")
                                observer.onError(contentError)
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
                           
                        case .failure(_):
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                            
                            if let refreshError = RefreshError(rawValue: status) {
                                print("refreshError - \(refreshError)")
                                observer.onError(refreshError)
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
                         
                        case .failure(_):
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                            
                            if let logOutError = LogOutError(rawValue: status) {
                                print("logOutError - \(logOutError)")
                                observer.onError(logOutError)
                            }
                        }
                   
                }
            return Disposables.create()
        }
    }
}
