//
//  CommentViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/25.
//

import UIKit
import RxSwift

final class CommentViewController : BaseViewController {
    
    var tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    let commentTextField = BaseTextField(placeHolder: "댓글 달기 ...", brandColor: .systemGray, alignment: .left)
    
    var postID: String?
    private var myID: String = ""
    var refreshGetPost: (() -> Void)?

    var comments: [CommentPostResponse]?
    var commentsID = PublishSubject<String>()
    let viewModel = CommentViewModel()
    
    // CommentVC에서 활용되는 실질적인 배열
    var commentsTemporaryArrays: [CommentPostResponse] = []
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        print("CommentViewController - configure")
        title = "댓글"
        sheetPresent()
        bind()
        guard let comments = self.comments else { return }
        addKeyboardNotifications()
        // 초기값 MainVC에서 넘어온 데이터 담아주기
        self.commentsTemporaryArrays = comments
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfile()
    }
    
    override func setConstraints() {
        
        view.addSubview(tableView)
        view.addSubview(commentTextField)
        
       
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        commentTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("CommentViewController - viewWillDisappear")
        refreshGetPost?()
        removeKeyboardNotificiations()
    }

    
    func bind() {
        
        let input = CommentViewModel.Input(postID: postID, comments: comments, removeComment: commentsID, addComment: commentTextField)
        
        let output = viewModel.transform(input: input)
        
        output.commentArray
            .bind(to: tableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) {
                row, element, cell in
                cell.configureUI(data: element)
            }
            .disposed(by: disposeBag)
        
        output.addCommentTapped
            .bind(with: self) { owner, response in
                owner.commentsTemporaryArrays.insert(response, at: 0)
                output.commentArray.onNext(owner.commentsTemporaryArrays)
                input.addComment.rx.text.orEmpty.onNext("")
                
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .bind(with: self) { owner, errMessage in
                owner.messageAlert(text: errMessage, completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .bind(with: self) { owner, index in
                print("index - \(index.row)")
                
                // 배열에서 내 아이디와 같은 것은 삭제 하지 못하도록 설정
                if owner.commentsTemporaryArrays[index.row].creator._id == owner.myID {
                    let removeComment = owner.commentsTemporaryArrays[index.row]._id
                    
                    owner.commentsID.onNext(removeComment)
                    
                    owner.commentsTemporaryArrays.remove(at: index.row)
                    output.commentArray.onNext(owner.commentsTemporaryArrays)
                } else {
                    self.messageAlert(text: "🙏🏻 - 해당 댓글을 제거 할 수 없습니다.", completionHandler: nil)
                }
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
    
    func getProfile() {
        APIManager.shared.requestAPIFunction(type: GetProfileResponse.self, api: Router.getProfile(accessToken: UserDefaultsManager.shared.accessToken), section: .getProfile)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("🙏🏻 프로필 조회 에러 - \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.myID = response._id
            }
            .disposed(by: disposeBag)
    }
}
