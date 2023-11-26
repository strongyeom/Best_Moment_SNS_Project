//
//  CommentViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/25.
//

import UIKit
import RxSwift

class CommentViewController : BaseViewController {
    
    var postID: String?
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        print("CommentViewController - configure")
        view.backgroundColor = .yellow
        title = "댓글"
        sheetPresent()
        bind()
    }
    
    
    
    func bind() {
        guard let postID else { return }
        print("postID - \(postID)")
        APIManager.shared.requestCommentPost(api: Router.commentPost(access: UserDefaultsManager.shared.accessToken, postID: postID, comment: "newStart-------------------"))
            .catch { err in
                if let err = err as? CommentPostError {
                    print(err.errorDescription)
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                dump(response)
            }
            .disposed(by: disposeBag)
    }

    
}
extension CommentViewController {
    fileprivate func sheetPresent() {
        if let sheetPresentationController {
          
            sheetPresentationController.detents = [.large()]
            // grabber 설정
            sheetPresentationController.prefersGrabberVisible = true
            // 코너 주기
            sheetPresentationController.preferredCornerRadius = 30
        }
        // grabber에서 네비게이션 타이틀 위치 간격 띄우기
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(CGFloat(10), for: UIBarMetrics.default)
    }
}
