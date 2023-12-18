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
        let errorMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMessage = PublishSubject<String>()
        
        
        let commentArray = BehaviorSubject(value: input.comments ?? [CommentPostResponse(_id: "", content: "", time: "", creator: Creator(_id: "", nick: ""))])
        
        let addCommentTapped = input.addComment.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(input.addComment.rx.text.orEmpty)
            .flatMap { text in
                return APIManager.shared.requestAPIFunction(type: CommentPostResponse.self, api: Router.commentPost(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", comment: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), section: .commentPost)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print(" 🙏🏻 댓글 추가 하기 에러 - \(err.description)")
                        }
                        return Observable.never()
                    }
            }
        
        input.removeComment
            .flatMap { commnetID in
                return APIManager.shared.requestAPIFunction(type: CommentRemoveResponse.self, api: Router.removeComment(access: UserDefaultsManager.shared.accessToken, postID: input.postID ?? "", commentID: commnetID), section: .removeComment)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻 - 댓글 제거 에러 \(err.description)")
                            errorMessage.onNext("🙏🏻 - 댓글 제거 에러 \(err.description)")
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self) { owner, response in
                print("삭제된 response: \(response.commentID)")
            }
            .disposed(by: disposeBag)
        
        return Output(commentArray: commentArray, addCommentTapped: addCommentTapped, errorMessage: errorMessage)
    }
}
