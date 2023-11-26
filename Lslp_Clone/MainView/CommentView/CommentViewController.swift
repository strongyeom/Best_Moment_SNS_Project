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
    lazy var addCommnetBtn = {
       let button = UIButton()
        button.setTitle("댓글 추가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(commentAddBtn), for: .touchUpInside)
        return button
    }()
    
    //댓글 추가하면
    
    var commnetArray: [CommentPostResponse] = []
    lazy var comments = BehaviorSubject(value: commnetArray)
    
    override func configure() {
        super.configure()
        print("CommentViewController - configure")
        title = "댓글"
        sheetPresent()
        bind()
        
        view.addSubview(addCommnetBtn)
        addCommnetBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func commentAddBtn() {
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
                //dump(response)
                owner.commnetArray.append(response)
                owner.comments.onNext(owner.commnetArray)
            }
            .disposed(by: disposeBag)
        
    }
    
    func bind() {

        
        // 댓글 추가시 댓글 Array에 모아서 데이터 뿌려주기
        comments
            .bind(with: self) { owner, comments in
                dump(comments)
            }
            .disposed(by: disposeBag)
        
        // TODO: - => 문제 발생! readPost에 있는 comments를 가져와야 되는데 종료시 초기화 됨... 수정 하기
        
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
