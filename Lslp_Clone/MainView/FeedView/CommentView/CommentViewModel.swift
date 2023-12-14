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
        let removeComment: PublishSubject<String>
        let addComment: BaseTextField
    }
    
    struct Output {
        
        let commentArray: BehaviorSubject<[CommentPostResponse]>
        let addCommentTapped: Observable<CommentPostResponse>
    }
    
    func transform(input: Input) -> Output {
        
        
        let commentArray = BehaviorSubject(value: input.comments ?? [CommentPostResponse(_id: "", content: "", time: "", creator: Creator(_id: "", nick: ""))])
        
        
        let addCommentTapped = input.addComment.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(input.addComment.rx.text.orEmpty)
            .flatMap { text in
                APIManager.shared.requestCommentPost(api: Router.commentPost(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", comment: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)) // 한글 인코딩 작업
                    .catch { err in
                        if let err = err as? CommentPostError {
                            print(err.errorDescription)
                        }
                        return Observable.never()
                    }
                
            }
        
        input.removeComment
            .flatMap { commentID in
                return APIManager.shared.requestCommentRemove(api: Router.commentRemove(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", commentID: commentID))
                    .catch { err in
                        if let err = err as? CommentRemoveError {
                            print(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self) { owner, response in
                print("삭제된 response: \(response.commentID)")
            }
            .disposed(by: disposeBag)
        
        return Output(commentArray: commentArray, addCommentTapped: addCommentTapped)
    }
}
