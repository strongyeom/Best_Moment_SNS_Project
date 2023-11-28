//
//  CommentViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/28.
//

import RxSwift
import RxCocoa
import Foundation

class CommentViewModel: BaseInOutPut {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let postID: String?
        var comments: [CommentPostResponse]?
        let commentTap: ControlEvent<Void>
        let tableViewDeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        
        let commentArray: BehaviorSubject<[CommentPostResponse]>
        let addCommentTapped: Observable<CommentPostResponse>
        let tableViewDeleted: Observable<CommentRemoveResponse>
    }
    
    func transform(input: Input) -> Output {
 
        
        let commentArray = BehaviorSubject(value: input.comments ?? [CommentPostResponse(_id: "", content: "", time: "", creator: Creator(_id: "", nick: ""))])
            
        
        let addCommentTapped = input.commentTap
            .flatMap {
                APIManager.shared.requestCommentPost(api: Router.commentPost(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", comment: "rrnw------newnew-------------".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)) // 한글 인코딩 작업 
                    .catch { err in
                        if let err = err as? CommentPostError {
                            print(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
        
        let tableViewDeleted = input.tableViewDeleted
            .flatMap { index in
                return APIManager.shared.requestCommentRemove(api: Router.commentRemove(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", commentID: try! commentArray.value()[index.row]._id))
                    .catch { err in
                        if let err = err as? CommentRemoveError {
                            print(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
        
        
//        let aa = input.tableViewDeleted
//            .flatMap { index in
//                return APIManager.shared.requestAPIFuction(type: CommentRemoveResponse.self, api: Router.commentRemove(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", commentID: input.comments?[index.row]._id ?? ""), someU: RefreshError.self)
//                    .catch { err in
//                        if let err = err as? CommentRemoveError {
//                            print(err.errorDescription)
//                        }
//                        return Observable.never()
//                    }
//            }
//
        
        return Output(commentArray: commentArray, addCommentTapped: addCommentTapped, tableViewDeleted: tableViewDeleted)
    }
}
