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
        tableView.rowHeight = 170
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
    
    let disposeBag = DisposeBag()
    // 기존 Cursor
    var remainCursor = ""
    // 다음 Cursor
    var nextCursor = ""
    
    let viewModel = MainViewModel()
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        setNavigationBar()
        bind()
        
    }
    
    func setNavigationBar() {
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addPostBtn
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "위로", style: .plain, target: self, action: #selector(uptoBtn))
        title = "우루사 게시글"
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
        // addPost()
        let addRoutinVC = AddRoutinViewController()
        addRoutinVC.modalPresentationStyle = .fullScreen
        present(addRoutinVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readPost(next: "")
        routinArray = []
    }
    
    func bind() {
        
        let input = MainViewModel.Input(tableViewIndex: tableView.rx.itemSelected, tableViewElememt: tableView.rx.modelSelected(ElementReadPostResponse.self))
        
        let output = viewModel.transform(input: input)
        
        routins
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, element, cell in
                cell.configureUI(data: element)
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
        if targetPointOfy + 40 >= doneScrollOffSet {
            print("네트워크 통신 시작")
            print("nextCursor - \(nextCursor)")
            if nextCursor != remainCursor {
                remainCursor = nextCursor
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
                    print(err.errorDescrtion)
                    print(err.rawValue)
                    if err.rawValue == 419 {
                        //                        self.refreshToken()
                    }
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                owner.routinArray.append(contentsOf: response.data)
                owner.routins.onNext(owner.routinArray)
            }
            .disposed(by: disposeBag)
    }
}

/*
 
 func refreshToken() {
 
 APIManager.shared.requestRefresh(api: Router.refresh(access: UserDefaultsManager.shared.accessToken, refresh: UserDefaultsManager.shared.refreshToken))
 .catch { err in
 if let err = err as? RefreshError {
 if err.rawValue == 418 {
 self.navigationController?.popToRootViewController(animated: true)
 } else {
 print(err.errorDescription)
 self.setEmailValidAlet(text: err.errorDescription, completionHandler: nil)
 }
 }
 return Observable.never()
 }
 .bind(with: self) { owner, response in
 print("---", response.token)
 UserDefaultsManager.shared.refreshToAccessToken(token: response)
 }
 .disposed(by: disposeBag)
 }
 
 */
