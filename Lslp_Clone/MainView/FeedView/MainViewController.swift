//
//  MainViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/20.
//

import UIKit
import RxSwift

class MainViewController : BaseViewController {
    
    var tableView = {
        let tableView = UITableView()
        tableView.rowHeight = UIScreen.main.bounds.height * 0.65
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var addPostBtn = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostBtnTapped))
        return button
    }()
    
    var routinArray: [ElementReadPostResponse] = []
    lazy var routins = BehaviorSubject(value: routinArray)
    var likeID = PublishSubject<String>()
    let postID = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    // 다음 Cursor
    var nextCursor = ""
    let viewModel = MainViewModel()
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        setNavigationBar()
        bind()
        self.title = "홈"
        UserDefaultsManager.shared.backToRoot(isRoot: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setNavigationBar() {
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addPostBtn
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "위로", style: .plain, target: self, action: #selector(uptoBtn))
//        navigationController?.title = "미생"
    }
    
    override func setConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func uptoBtn() {
        let index = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: .top, animated: true)
    }
    
    @objc func addPostBtnTapped() {
        let addRoutinVC = AddRoutinViewController()
        let nav = UINavigationController(rootViewController: addRoutinVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
        readPost(next: "")
        routinArray = []
        
        
    }
    
    func bind() {
        
        let input = MainViewModel.Input(tableViewIndex: tableView.rx.itemSelected, tableViewElement: tableView.rx.modelSelected(ElementReadPostResponse.self), likeID: likeID, postID: postID)
        
        let output = viewModel.transform(input: input)
        
        routins
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, element, cell in
                cell.configureUI(data: element)
                
                cell.likeBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        print("Like Btn -- Clicked Row : \(row)")
                        owner.likeID.onNext(element._id)
                        
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.editBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        // 바뀐 데이터를 서버에 put 하기
                        let editView = PostEditViewController()
                        editView.editPost = element
                        
                        let nav = UINavigationController(rootViewController: editView)
                        owner.present(nav, animated: true)
                        
//                        cell.routinDescription.text = "편집 버튼 눌림"
                        print("편집 버튼 눌림 - Clicked Row: \(row)")
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.cancelBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        print("삭제 버튼 눌림 -- Clicked Row: \(row)")
                        owner.postID.onNext(element._id)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.postCommentBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        let commentView = CommentViewController()
                        commentView.postID = element._id
                        commentView.comments = element.comments
                        commentView.refreshGetPost = {
                            //                            print("넘어온 데이터")
                            owner.routinArray = []
                            owner.readPost(next: "")
                            
                        }
                        let nav = UINavigationController(rootViewController: commentView)
                        owner.present(nav, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        output.like
            .bind(with: self) { owner, response in
                
                print("MainVC - like: \(response.like_status)")
            }
            .disposed(by: disposeBag)
        
        
        output.removePost
            .bind(with: self) { owner, response in
                print("삭제한 postID : \(response._id)")
                owner.routinArray = []
                owner.readPost(next: "")
            }
            .disposed(by: disposeBag)
        
        /// 에러 문구 Alert
        output.errorMessage
            .bind(with: self) { owner, err in
                owner.setEmailValidAlet(text: err, completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        
        output.zip
            .bind(with: self) { owner, response in
                print("index - \(response.0)")
                print("element - \(response.1)")
                
            }
            .disposed(by: disposeBag)
        
        // setDelegate : delegate와 같이 쓸 수 있음
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
 
    }
}

extension MainViewController : UITableViewDelegate {
    // 스크롤 하는 중일때 실시간으로 반영하는 방법은 없을까?
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let contentSize = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        // targetContentOffset.pointee.y: 사용자가 스크롤하면 실시간으로 값을 나타낼 수 있음 속도가 떨어지는 지점을 예측한다.
        let targetPointOfy = targetContentOffset.pointee.y
        
        let doneScrollOffSet = contentSize - scrollViewHeight
        if targetPointOfy + 70 >= doneScrollOffSet {
            
            if nextCursor != "0" {
                print("MainVC - 바닥 찍었음 append 네트워크 통신 시작")
                readPost(next: nextCursor)
            }
        }
    }
}

extension MainViewController {
    func readPost(next: String) {
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: "", product_id: "yeom"))
            .catch { err in
                if let err = err as? ReadPostError {
                    print("MainViewController - readPost \(err.errorDescrtion) , \(err.rawValue)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                print("MainVC GET- next_cursor: \(response.next_cursor)")
                owner.routinArray.append(contentsOf: response.data)
                owner.routins.onNext(owner.routinArray)
                
            }
            .disposed(by: disposeBag)
    }
}
// MainVC GET- next_cursor: 656a8124d3b44c277c35468b
// MainVC GET- remain_cursor: 656a8ebc0f5cb42779b6013e
