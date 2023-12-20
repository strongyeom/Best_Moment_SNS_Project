//
//  AuthManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/30.
//

import Foundation
import Alamofire
import UIKit

class AuthManager: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // UserDefaults에 저장된 토큰
        let accessToken = UserDefaultsManager.shared.accessToken
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 419
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        
        AF.request(
            Router.refresh(
                access: UserDefaultsManager.shared.accessToken,
                refresh: UserDefaultsManager.shared.refreshToken
            )
        )
//        .validate(statusCode: 200..<500)
        .responseDecodable(of: RefreshResponse.self) { result in
            print("**isRoot 상태 : \(UserDefaultsManager.shared.backToCall())")
            print("** response.Status : \(response.statusCode)")
            guard let status = result.response?.statusCode else { return }
            print("** status: \(status)")
            switch result.result {
            case .success(let data):
                UserDefaultsManager.shared.saveAccessToken(accessToken: data.token)
//                UserDefaultsManager.shared.backToRoot(isRoot: true)
                completion(.retry)
            case .failure(let error):
                UserDefaultsManager.shared.backToRoot(isRoot: false)
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                 windowScene?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
                if let refreshError = RefreshError(rawValue: status) {
                    completion(.doNotRetryWithError(refreshError))
                     }
                }
                
            }
        }
    }
