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
        let toggleFollowing: BehaviorSubject<Bool>
        
    }
    
    struct Output {
        let zip: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<ElementReadPostResponse>.Element)>
        let like: Observable<LikeResponse>
        let removePost:
            Observable<RemovePostResponse>
        let errorMessage: PublishSubject<String>
        let unFollower: Observable<FollowerStatusResponse>
        let followingStatus : Observable<FollowerStatusResponse>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        
        let errorMessage = PublishSubject<String>()
        
        
        let zip = Observable.zip(input.tableViewIndex, input.tableViewElement)
        
        let like = input.likeID
            .flatMap { postID in
                return APIManager.shared.requestAPIFunction(type: LikeResponse.self, api: Router.like(access: UserDefaultsManager.shared.accessToken, postID: postID), section: .like)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻- 좋아요 에러 : \(err.description)")
                        }
                        return Observable.never()
                    }
            }
        
        let removePost = input.postID
            .flatMap { postID in
                return APIManager.shared.requestAPIFunction(type: RemovePostResponse.self, api: Router.removePost(access: UserDefaultsManager.shared.accessToken, postID: postID), section: .removePost)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻- 게시물 제거 에러 : \(err.description)")
                        }
                        return Observable.never()
                    }
            }
        
        
        
        // FollowingVC
        let unFollower = input.userID
            .flatMap { userID in
                return APIManager.shared.requestAPIFunction(type: FollowerStatusResponse.self, api: Router.unFollower(accessToken: UserDefaultsManager.shared.accessToken, userID: userID), section: .unFollower)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻- 언팔로우 에러 FollowingVC : \(err.description)")
                        }
                        return Observable.never()
                    }
            }
        
        
        
        
        
        let userIDAndFollowingStatus = Observable.combineLatest(input.userID, input.toggleFollowing)
        
        let followingStatus = input.userID
            .withLatestFrom(userIDAndFollowingStatus)
            .flatMap { userID, response in
                return APIManager.shared.requestAPIFunction(type: FollowerStatusResponse.self, api: response ? Router.follow(accessToken: UserDefaultsManager.shared.accessToken, userID: userID) : Router.unFollower(accessToken: UserDefaultsManager.shared.accessToken, userID: userID), section: .follow)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻- 팔로우 에러 : \(err.description)")
                        }
                        return Observable.never()
                    }
            }
        
        
        return Output(zip: zip, like: like, removePost: removePost, errorMessage: errorMessage, unFollower: unFollower, followingStatus: followingStatus)
    }
}
