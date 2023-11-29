//
//  RefreshTokenManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/29.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class RefreshTokenViewModel {
 
    static let shared = RefreshTokenViewModel()
    
    private init() { }
    
    let disposeBag = DisposeBag()
    func refreshToken(completionHandler: @escaping (() -> Void)) {
        
        APIManager.shared.requestRefresh(api: Router.refresh(access: UserDefaultsManager.shared.accessToken, refresh: UserDefaultsManager.shared.refreshToken))
            .catch { err in
                if let err = err as? RefreshError {
                    if err.rawValue == 418 {
                        print("RefreshTokenViewModel - 리프레쉬 토큰 만료 \(err.errorDescription)")
                        // 418 즉 리프레쉬 토큰이 왔을때 어떻게 로그아웃으로 보낼 수 있을까?
                        // 지금까지 쌓여있는 모든 VC를 pop하는 방법은? 근데.. VM이기 때문에 한번에 이동할 수가 없는데 어떻게 하지?
                        completionHandler()
                    }
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                print("RefreshTokenManager - 엑세스 토큰 갱신 \(response)")
                UserDefaultsManager.shared.saveAccessToken(accessToken: response.token)
            }
            .disposed(by: disposeBag)
            
    }
    
    
    
}
