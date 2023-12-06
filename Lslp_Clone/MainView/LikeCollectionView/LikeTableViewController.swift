////
////  MainViewController.swift
////  Lslp_Clone
////
////  Created by 염성필 on 2023/11/20.
////
//
//import UIKit
//import RxSwift
//
//class LikeTableViewController : BaseViewController {
//
//    var tableView = {
//        let tableView = UITableView()
//        tableView.rowHeight = UIScreen.main.bounds.height * 0.65
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
//        tableView.separatorStyle = .none
//        return tableView
//    }()
//
//    lazy var addPostBtn = {
//        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostBtnTapped))
//        return button
//    }()
//
//    var routinArray: [ElementReadPostResponse] = []
//    lazy var routins = BehaviorSubject(value: routinArray)
//    var likeID = PublishSubject<String>()
//    let postID = PublishSubject<String>()
//
//    let disposeBag = DisposeBag()
//    // 다음 Cursor
//    private var nextCursor = ""
//    let likeViewModel = LikeViewModel()
//
//    override func configure() {
//        super.configure()
//        self.view.backgroundColor = .green
//        print("LikeCollectionViewController - configure")
//        setNavigationBar()
//        bind()
//        self.title = "좋아요"
//        UserDefaultsManager.shared.backToRoot(isRoot: true)
//
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//
//    func setNavigationBar() {
//        self.navigationItem.hidesBackButton = true
//        navigationItem.rightBarButtonItem = addPostBtn
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "위로", style: .plain, target: self, action: #selector(uptoBtn))
//    }
//
//    override func setConstraints() {
//        view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    @objc func uptoBtn() {
//        let index = IndexPath(row: 0, section: 0)
//        self.tableView.scrollToRow(at: index, at: .top, animated: true)
//    }
//
//    @objc func addPostBtnTapped() {
////        let addRoutinVC = AddRoutinViewController()
////        let nav = UINavigationController(rootViewController: addRoutinVC)
////        nav.modalPresentationStyle = .fullScreen
////        present(nav, animated: true)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("LikeCollectionViewController - viewWillAppear")
//        requestGetLikes(next: "")
//        routinArray = []
//    }
//
//    func bind() {
//
//        let input = LikeViewModel.Input(tableViewIndex: collectionview.rx.itemSelected, : tableView.rx.modelSelected(ElementReadPostResponse.self), likeID: likeID, postID: postID)
//
//        let output = likeViewModel.transform(input: input)
//
//        routins
//            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, element, cell in
//                cell.configureUI(data: element)
//
//                cell.likeBtn.rx.tap
//                    .bind(with: self) { owner, _ in
//                        print("Like Btn -- Clicked Row : \(row)")
//                        owner.likeID.onNext(element._id)
//                    }
//                    .disposed(by: cell.disposeBag)
//
//                cell.cancelBtn.rx.tap
//                    .bind(with: self) { owner, _ in
//                        print("삭제 버튼 눌림 -- Clicked Row: \(row)")
//                        owner.postID.onNext(element._id)
//                    }
//                    .disposed(by: cell.disposeBag)
//
//                cell.postCommentBtn.rx.tap
//                    .bind(with: self) { owner, _ in
//                        let commentView = CommentViewController()
//                        commentView.postID = element._id
//                        commentView.comments = element.comments
//                        commentView.refreshGetPost = {
//                            owner.routinArray = []
//                            owner.requestGetLikes(next: "")
//
//                        }
//                        let nav = UINavigationController(rootViewController: commentView)
//                        owner.present(nav, animated: true)
//                    }
//                    .disposed(by: cell.disposeBag)
//
//            }
//            .disposed(by: disposeBag)
//
//        output.like
//            .bind(with: self) { owner, response in
//                owner.routinArray = []
//                owner.requestGetLikes(next: "")
//            }
//            .disposed(by: disposeBag)
//
//
//        output.removePost
//            .bind(with: self) { owner, response in
//                print("삭제한 postID : \(response._id)")
//                owner.routinArray = []
//                owner.requestGetLikes(next: "")
//            }
//            .disposed(by: disposeBag)
//
//        output.zip
//            .bind(with: self) { owner, response in
//                print("index - \(response.0)")
//                print("element - \(response.1)")
//
//            }
//            .disposed(by: disposeBag)
//
//        // setDelegate : delegate와 같이 쓸 수 있음
//        tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
//
//    }
//}
//
//extension LikeTableViewController : UITableViewDelegate {
//    // 스크롤 하는 중일때 실시간으로 반영하는 방법은 없을까?
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let contentSize = scrollView.contentSize.height
//        let scrollViewHeight = scrollView.frame.height
//        // targetContentOffset.pointee.y: 사용자가 스크롤하면 실시간으로 값을 나타낼 수 있음 속도가 떨어지는 지점을 예측한다.
//        let targetPointOfy = targetContentOffset.pointee.y
//
//        let doneScrollOffSet = contentSize - scrollViewHeight
//        if targetPointOfy + 70 >= doneScrollOffSet {
//            print("네트워크 통신 시작")
//            print("LikeVC - nextCursor - \(nextCursor)")
//            if nextCursor != "0" {
//                print("MainVC - 바닥 찍었음 append 네트워크 통신 시작")
//                requestGetLikes(next: nextCursor)
//            }
//        }
//    }
//}
//
//extension LikeTableViewController {
//    func requestGetLikes(next: String) {
//        APIManager.shared.requestReadPost(api: Router.getLikes(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: ""))
//            .catch { err in
//                if let err = err as? ReadPostError {
//                    print("MainViewController - readPost \(err.errorDescrtion) , \(err.rawValue)")
//                }
//                return Observable.never()
//            }
//            .bind(with: self) { owner, response in
//                owner.nextCursor = response.next_cursor
//                print("LikeVC - response.next_cursor \(response.next_cursor)")
//                print("LikeVC - nextCursor: \(owner.nextCursor)")
//                owner.routinArray.append(contentsOf: response.data)
//
////                print("LikeVC - routinArray :\(owner.routinArray)")
//                owner.routins.onNext(owner.routinArray)
//
//            }
//            .disposed(by: disposeBag)
//    }
//}
//
