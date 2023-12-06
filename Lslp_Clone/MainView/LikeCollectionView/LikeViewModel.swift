//
//  ExampleViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/06.
//

import Foundation
import RxSwift
import RxCocoa

class LikeViewModel: BaseInOutPut {
    
    struct Input {
        let likeID: PublishSubject<String>
    }
    
    struct Output {
        let like: Observable<LikeResponse>
    }
    
    func transform(input: Input) -> Output {
        
        let like = input.likeID
            .flatMap { postID in
                return APIManager.shared.requestLike(api: Router.like(access: UserDefaultsManager.shared.accessToken, postID: postID))
                    .catch { err in
                        if let err = err as? LikeError {
                            
                            if err.rawValue == 419 {
                                
                            }
                        }
                        return Observable.never()
                    }
            }
        
        return Output(like: like)
    }
}
