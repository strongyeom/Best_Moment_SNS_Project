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

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func request(api: Router) -> Observable<JoinResponse> {
        return Observable<JoinResponse>.create { observer in
            
            AF.request(api)
                .validate(statusCode: 200..<500)
                .responseDecodable(of: JoinResponse.self) { response in
                    print("APIManager - StatusCode : \(response.response!.statusCode)")
                    
                    guard let status = response.response?.statusCode else { return }
                    
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
    
    func reqeustLogin(api: Router) -> Observable<Token> {
        return Observable<Token>.create { observer in
            AF.request(api)
                .validate(statusCode: 200...500)
                .responseDecodable(of: Token.self) {
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
}
