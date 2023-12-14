//
//  CommentViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/25.
//

import UIKit
import RxSwift

class CommentViewController : BaseViewController {
    
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
    
    var refreshGetPost: (() -> Void)?

    var comments: [CommentPostResponse]?

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
        
        // 초기값 MainVC에서 넘어온 데이터 담아주기
        self.commentsTemporaryArrays = comments
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
    }

    
    func bind() {
        
        let input = CommentViewModel.Input(postID: postID, comments: comments, tableViewDeleted: tableView.rx.itemDeleted, addComment: commentTextField)
        
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
  
        
        output.tableViewDeleted
            .bind(with: self) { owner, response in
                print(response)
                
                let removeArray = owner.commentsTemporaryArrays.filter { !$0._id.contains(response.commentID)}
                output.commentArray.onNext(removeArray)
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
