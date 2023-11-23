//
//  MainViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//
import Foundation
import RxSwift
import RxCocoa

class MainViewModel: BaseInOutPut {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tableViewIndex:  ControlEvent<IndexPath>
        let tableViewElement:  ControlEvent<ElementReadPostResponse>
        let likeID: PublishSubject<String>
    }
    
    struct Output {
        let zip: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<ElementReadPostResponse>.Element)>
        let like: Observable<LikeResponse>
    }
    
    func transform(input: Input) -> Output {
        
       
        
        let zip = Observable.zip(input.tableViewIndex, input.tableViewElement)
        
        let like = input.likeID
            .withLatestFrom(input.likeID)
            .flatMap { postID in
                return APIManager.shared.requestLike(api: Router.like(access: UserDefaultsManager.shared.accessToken, postID: postID))
                    .catch { err in
                        if let err = err as? LikeError {
                            print(err.errorDescripion)
                        }
                        return Observable.never()
                    }
            }
            
        
        return Output(zip: zip, like: like)
    }
}
