//
//  SearchViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: BaseInOutPut {
    
    struct Input {
        let userID: PublishSubject<String>
    }
    
    struct Output {
        let follow: Observable<FollowerStatusResponse>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
      
        let follow = input.userID
            .flatMap { userID in
                APIManager.shared.requestFollowStatus(api: Router.follow(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
                    .catch { err in
                        if let err = err as? FollowerError {
                            
                        }
                        return Observable.never()
                    }
            }
        
//        APIManager.shared.requestGetProfile(api: Router.getProfile(accessToken: UserDefaultsManager.shared.accessToken))
//            .catch { err in
//                if let err = err as? GetProfileError {
//
//                }
//                return Observable.never()
//            }
//            .bind(with: self) { owner, response in
//                print("response - \(response.following)")
//                let myFollowingID = response.following.map {
//                    $0._id
//                }
//                followingUsers = myFollowingID
//                print("** followingUsers : \(followingUsers)")
//            }
//            .disposed(by: disposeBag)
        
        return Output(follow: follow)
    }
}
