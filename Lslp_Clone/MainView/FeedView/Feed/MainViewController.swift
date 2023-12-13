//
//  FollowingViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/11.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController : BaseViewController {
    
    var tableView = {
        let tableView = UITableView()
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
    let userID = PublishSubject<String>()
    let profileUserID = PublishSubject<String>()
    let toggleFollowing = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    // 다음 Cursor
    var nextCursor = ""
    var myID: String = ""
    var likeRow: Int = 0
    var followings: [String] = []
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
        getPost(next: "", limit: "10")
        routinArray = []
    }
    
    func setNavigationBar() {
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addPostBtn
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "위로", style: .plain, target: self, action: #selector(uptoBtn))
    }
    
    override func setConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func addPostBtnTapped() {
        let addRoutinVC = AddRoutinViewController()
        let nav = UINavigationController(rootViewController: addRoutinVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func uptoBtn() {
        let index = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: .top, animated: true)
    }
    
    
    func bind() {
        
        let input = MainViewModel.Input(tableViewIndex: tableView.rx.itemSelected, tableViewElement: tableView.rx.modelSelected(ElementReadPostResponse.self), likeID: likeID, postID: postID, userID: userID, profileUserID: profileUserID, toggleFollowing: toggleFollowing)
        
        let output = viewModel.transform(input: input)
        
        routins
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, element, cell in
                
                self.likeRow = row
                print("likeRow : \(self.likeRow)")
                cell.configureUI(data: element, followings: self.followings)
                cell.likeBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        print("Like Btn -- Clicked Row : \(row)")
                        owner.likeID.onNext(element._id)
                    }
                    .disposed(by: cell.disposeBag)
                
                // 편집
                cell.editCompletion = {
                    guard element.creator._id == self.myID else {
                        self.messageAlert(text: "돌아가 자네가 올 곳이 아니야", completionHandler: nil)
                        return
                    }
                    let editVC = EditViewController()
                    editVC.data = element
                    editVC.postID = element._id
                    self.navigationController?.pushViewController(editVC, animated: true)
                }
                // 삭제
                cell.deleteCompletion = {
                    print("\(row) - \(element.title)")
                    self.postID.onNext(element._id)
                }
                
                // 프로필 클릭
                cell.profileCompletion = {
                    self.profileUserID.onNext(element.creator._id)
                   
                }
                
                cell.followerBtn.rx.tap
                    .bind(with: self) { owner, _ in
                        print("팔로우 버튼 눌림")
                        
                        
                        guard element.creator._id == owner.myID else {
                            owner.messageAlert(text: "돌아가 자네가 올 곳이 아니야(같은 ID는 팔로우 할 수 없음)", completionHandler: nil)
                            return
                        }
                        
                        if cell.followerBtn.titleLabel?.text == "팔로우" {
                            cell.followerBtn.configurationUpdateHandler = { button in
                                button.configuration = cell.followOption(text: "팔로잉")
                                owner.toggleFollowing.onNext(true)
                                owner.userID.onNext(element.creator._id)
                            }
                        } else {
                            
                            cell.followerBtn.configurationUpdateHandler = { button in
                                button.configuration = cell.followOption(text: "팔로우")
                                owner.toggleFollowing.onNext(false)
                                owner.userID.onNext(element.creator._id)
                            }
                        }
                        
                        
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
                            owner.getPost(next: "", limit: owner.likeRow >= 5 ? "\(owner.likeRow + 1)" : "")
                            
                        }
                        let nav = UINavigationController(rootViewController: commentView)
                        owner.present(nav, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        // LikeResponse로 나온 true, false 결과값
        output.like
            .bind(with: self) { owner, response in
                owner.routinArray = []
                owner.getPost(next: "", limit: owner.likeRow >= 5 ? "\(owner.likeRow + 1)" : "")
                print("** MainVC - 서버 Likes 배열에 추가 : \(response.like_status)")
            }
            .disposed(by: disposeBag)
        
        // 삭제 후 네트워크 통신
        output.removePost
            .bind(with: self) { owner, response in
                print("삭제한 postID : \(response._id)")
                owner.routinArray = []
                owner.getPost(next: "", limit: owner.likeRow >= 5 ? "\(owner.likeRow + 1)" : "")
            }
            .disposed(by: disposeBag)
        
        // 팔로우 상태
        output.followingStatus
            .bind(with: self) { owner, response in
                print("팔로잉 상태 ", response.following_status)
                owner.getPost(next: "", limit: owner.likeRow >= 5 ? "\(owner.likeRow + 1)" : "")
            }
            .disposed(by: disposeBag)
        
        /// 에러 문구 Alert
        output.errorMessage
            .bind(with: self) { owner, err in
                owner.messageAlert(text: err, completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        
        output.profileTapped
            .bind(with: self) { owner, response in
                print("다른 사람 프로필 조회 - \(response)")
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
                getPost(next: nextCursor, limit: "")
                
            }
        }
    }
}

extension MainViewController {
    func getPost(next: String, limit: String) {
        
        APIManager.shared.requestGetProfile(api: Router.getProfile(accessToken: UserDefaultsManager.shared.accessToken))
            .catch { err in
                if let err = err as? GetProfileError {
                    
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.myID = response._id
                print("팔로잉 된 ID : \(response.following.map { $0._id })")
                owner.followings = response.following.map { $0._id }
            }
            .disposed(by: disposeBag)
        
        
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: limit, product_id: "yeom"))
            .catch { err in
                if let err = err as? ReadPostError {
                    print("MainViewController - readPost \(err.errorDescrtion) , \(err.rawValue)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                print("MainVC GET- next_cursor: \(response.next_cursor)")
                
                owner.nextCursor = response.next_cursor
                owner.routinArray.append(contentsOf: response.data)
                owner.routins.onNext(owner.routinArray)
            }
            .disposed(by: disposeBag)
        
    }
}
