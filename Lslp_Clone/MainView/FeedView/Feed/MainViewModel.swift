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
        let postID: PublishSubject<String>
        let userID: PublishSubject<String>
    }
    
    struct Output {
        let zip: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<ElementReadPostResponse>.Element)>
        let like: Observable<LikeResponse>
        let removePost:
            Observable<RemovePostResponse>
        let errorMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMessage = PublishSubject<String>()
        
        
        let zip = Observable.zip(input.tableViewIndex, input.tableViewElement)
        
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
        
        let removePost = input.postID
            .flatMap { postID in
                return APIManager.shared.requestRemovePost(api: Router.removePost(access: UserDefaultsManager.shared.accessToken, userNickname: UserDefaultsManager.shared.loadNickname(), postID: postID))
                    .catch { err in
                        if let err = err as? RemovePostError {
                            print("🙏🏻- 게시글 에러 : \(err.errorDescription)")
                            errorMessage.onNext(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
            
       input.userID
            .flatMap { userID in
                APIManager.shared.requestDeleteFollowers(api: Router.deleteFollower(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
                    .catch { err in
                        if let err = err as? DeleteFollowerError {
                            print("🙏🏻- 언팔로우 에러 : \(err.errorDescription)")
                            errorMessage.onNext(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self) { owner, response in
                print("*** response : \(response)")
            }
            .disposed(by: disposeBag)
            
        
        return Output(zip: zip, like: like, removePost: removePost, errorMessage: errorMessage)
    }
}
