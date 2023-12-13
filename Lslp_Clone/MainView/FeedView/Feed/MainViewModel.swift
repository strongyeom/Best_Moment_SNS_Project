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
        let profileUserID: PublishSubject<String>
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
        let profileTapped: Observable<GetAnotherProfileResponse>
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
                print("UserDefaultsManager.shared.loadNickname() - \(UserDefaultsManager.shared.loadNickname())")
                return APIManager.shared.requestRemovePost(api: Router.removePost(access: UserDefaultsManager.shared.accessToken, postID: postID))
                    .catch { err in
                        if let err = err as? RemovePostError {
                            print("🙏🏻- 게시글 에러 : \(err.errorDescription)")
                            errorMessage.onNext(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
        
      
        
        
        
        let unFollower = input.userID
            .flatMap { userID in
                APIManager.shared.requestFollowStatus(api: Router.unFollower(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
                    .catch { err in
                        if let err = err as? DeleteFollowerError {
                            print("🙏🏻- 언팔로우 에러 : \(err.errorDescription)")
                            errorMessage.onNext(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
        
        let userIDAndFollowingStatus = Observable.combineLatest(input.userID, input.toggleFollowing)
        
        let followingStatus = input.userID
            .withLatestFrom(userIDAndFollowingStatus)
            .flatMap { userID, response in
                APIManager.shared.requestFollowStatus(api: response ? Router.follow(accessToken: UserDefaultsManager.shared.accessToken, userID: userID) : Router.unFollower(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
                    .catch { err in
                        if let err = err as? DeleteFollowerError {
                            print("🙏🏻- 언팔로우 에러 : \(err.errorDescription)")
                            errorMessage.onNext(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
        
        let profileImageTapped = input.profileUserID
            .flatMap { userID in
                APIManager.shared.requestAnotherGerProfile(api: Router.anotherGetProfile(accessToken: UserDefaultsManager.shared.accessToken, userID: userID))
                    .catch { err in
                        if let err = err as? GetProfileError {
                            
                        }
                        return Observable.never()
                    }
            }
        
        return Output(zip: zip, like: like, removePost: removePost, errorMessage: errorMessage, unFollower: unFollower, followingStatus: followingStatus, profileTapped: profileImageTapped)
    }
}
