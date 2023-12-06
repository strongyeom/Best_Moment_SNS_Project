//
//  LikeViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/02.
//

import Foundation
import RxSwift
import RxCocoa

class LikeViewModel: BaseInOutPut {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let rowArray: [ElementReadPostResponse]
        
        let selectedIndex:  ControlEvent<IndexPath>
        let selectedElement:  ControlEvent<ElementReadPostResponse>
        let likeID: PublishSubject<String>
        let postID: PublishSubject<String>
    }
    
    struct Output {
        let likesArray: BehaviorSubject<[ElementReadPostResponse]>
        let zip: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<ElementReadPostResponse>.Element)>
        let like: Observable<LikeResponse>
        let errorMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        let likesArray = BehaviorSubject(value: input.rowArray)
        
        let errorMessage = PublishSubject<String>()
        
        let zip = Observable.zip(input.selectedIndex, input.selectedElement)
        
        let like = input.likeID
            .flatMap { postID in
                return APIManager.shared.requestLike(api: Router.like(access: UserDefaultsManager.shared.accessToken, postID: postID))
                    .catch { err in
                        if let err = err as? LikeError {
                            print("🙏🏻- 좋아요 에러 : \(err.errorDescripion)")
                            errorMessage.onNext(err.errorDescripion)
                           
                            if err.rawValue == 419 {
                                
                            }
                        }
                        return Observable.never()
                    }
            }
        
        return Output(likesArray: likesArray, zip: zip, like: like, errorMessage: errorMessage)
    }
}
