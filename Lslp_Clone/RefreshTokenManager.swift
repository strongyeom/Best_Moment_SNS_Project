//
//  RefreshTokenManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/29.
//

import Foundation
import RxSwift
import RxCocoa

class RefreshTokenViewModel {
    
    var newAccessToken = BehaviorSubject(value: UserDefaultsManager.shared.accessToken)
    
    private let disposeBag = DisposeBag()
    
    func refreshToken() {
        
        APIManager.shared.requestRefresh(api: Router.refresh(access: UserDefaultsManager.shared.accessToken, refresh: UserDefaultsManager.shared.refreshToken))
            .catch { err in
                if let err = err as? RefreshError {
                    print(err.errorDescription)
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                print("RefreshTokenManager - 엑세스 토큰 갱신 \(response)")
                UserDefaultsManager.shared.saveAccessToken(accessToken: response.token)
                owner.newAccessToken.onNext(UserDefaultsManager.shared.loadNickname())
            }
            .disposed(by: disposeBag)
            
    }
}
