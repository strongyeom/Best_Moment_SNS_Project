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
        let followingString: BehaviorSubject<String>
    }
    
    struct Output {
        let follow: Observable<FollowerStatusResponse>
        
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        print("**** \(try! input.followingString.value())")
        
        let follow = input.userID
            .flatMap { userID in
                APIManager.shared.requestFollowStatus(api:Router.follow(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
                    .catch { err in
                        if let err = err as? FollowerError {
                            
                        }
                        return Observable.never()
                    }
            }
        
      
//        let follow = input.userID
//            .flatMap { userID in
//                APIManager.shared.requestFollowStatus(api: Router.follow(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
//                    .catch { err in
//                        if let err = err as? FollowerError {
//
//                        }
//                        return Observable.never()
//                    }
//            }
        
//        let unFollow = input.userID
//             .flatMap { userID in
//                 APIManager.shared.requestFollowStatus(api: Router.unFollower(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
//                     .catch { err in
//                         if let err = err as? DeleteFollowerError {
//
//                         }
//                         return Observable.never()
//                     }
//             }
    
        
        return Output(follow: follow)
    }
}
