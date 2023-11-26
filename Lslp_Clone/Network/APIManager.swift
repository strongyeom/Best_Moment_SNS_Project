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
                            //observer.onCompleted() <- 스트림이 쌓이지 않게 하기 위해 completed를 사용 안써도 굳이 상관은 없지만 조금이라도 메모리 사용을 줄 일 수 있음
                            // => observer 두개 쓰기 귀찮음 => return 값의 Observable -> Single, .create앞에 Observable -> Single
                            // => Single에는 Next 이벤트 없고 내부적으로 구현해놓음 => 적용 ⭐️ observer(.success(data)), observer(.failure(error))
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
    
    
    // ->>> 게시글 관련해서만 테스트로 onCompleted 작성함
    
    /// 게시글 작성하기
    func requestAddPost(api: Router) -> Observable<AddPostResponse> {
        return Observable<AddPostResponse>.create { observer in
            AF.upload(multipartFormData: { multiPartForm in
            
                for (key, value) in api.query! {
                    multiPartForm.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
                }
            }, with: api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: AddPostResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("컨텐츠 상태 코드 ", status)
                    
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                            observer.onCompleted()
                        case .failure(let error):
                            print(error.localizedDescription)
                            if let commonError = CommonError(rawValue: status) {
                                print("CommonError - \(commonError)")
                                observer.onError(commonError)
                            }
                            
                            if let contentError = AddPostError(rawValue: status) {
                                
                                print("contentError - \(contentError)")
                                observer.onError(contentError)
                            }
                        }
                 
                }
            return Disposables.create()
        }
    }
    
    /// 게시글 조회하기
    func requestReadPost(api: Router) -> Observable<ReadPostResponse> {
        return Observable.create { observer in
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: ReadPostResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
//                        observer.onCompleted()
                    case .failure(let error):
                        print(error.localizedDescription)
                        if let commonError = CommonError(rawValue: status) {
                            print("CommonError - \(commonError)")
                            observer.onError(commonError)
                        }
                        
                        if let readPostError = ReadPostError(rawValue: status) {
                            print("readPostError - \(readPostError)")
                            observer.onError(readPostError)
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    /// 게시글 삭제하기
    func requestRemovePost(api: Router) -> Observable<RemovePostResponse> {
        return Observable.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: RemovePostResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(_):
                        if let commonError = CommonError(rawValue: status) {
                            observer.onError(commonError)
                        }
                        
                        if let removePostError = RemovePostError(rawValue: status) {
                            observer.onError(removePostError)
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
    
    /// 좋아요 및 좋아요 취소
    func requestLike(api: Router) -> Observable<LikeResponse> {
        return Observable.create { observer in
            AF.request(api)
                .validate(statusCode: 200...300)
                .responseDecodable(of: LikeResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(_):
                        if let commonError = CommonError(rawValue: status) {
                            observer.onError(commonError)
                        }
                        
                        if let likeError = LikeError(rawValue: status) {
                            observer.onError(likeError)
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    /// 댓글 작성하기
//    func requestCommentPost(api: Router) -> Observable<CommentPostResponse> {
//        return Observable.create { observer in
//            AF.request(api)
//                .validate(statusCode: 200...300)
//                .responseDecodable(of: CommentPostResponse.self) { response in
//                    guard let status = response.response?.statusCode else { return }
//                    print("status - \(status)")
//                    switch response.result {
//                    case .success(let data):
//                        observer.onNext(data)
//                    case .failure(_):
//                        if let commonError = CommonError(rawValue: status) {
//                            observer.onError(commonError)
//                        }
//
//                        if let commentError = CommentPostError(rawValue: status) {
//                            observer.onError(commentError)
//                        }
//                    }
//                }
//            return Disposables.create()
//        }
//    }
//
}
