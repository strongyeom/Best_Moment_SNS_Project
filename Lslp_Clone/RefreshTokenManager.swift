//
//  RefreshTokenManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/29.
//

import Foundation
import RxSwift
import RxCocoa

class RefreshTokenManager {
    
    static let shared = RefreshTokenManager()
    private init() { }
    
    let disposeBag = DisposeBag()
    
    func refreshToken(completionHandler: @escaping (RefreshResponse) -> Void) {
        
        APIManager.shared.requestRefresh(api: Router.refresh(access: UserDefaultsManager.shared.accessToken, refresh: UserDefaultsManager.shared.refreshToken))
            .catch { err in
                if let err = err as? RefreshError {
                    print(err.errorDescription)
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                print(response)
                completionHandler(response)
            }
            .disposed(by: disposeBag)
            
    }
}
