//
//  MainViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/20.
//

import UIKit
import RxSwift

class MainViewController : BaseViewController {
    
    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 180
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
    var remainCursor = ""
    var nextCursor = ""
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addPostBtn
        title = "우루사 게시글"
        bind()
        tableView.delegate = self
    }
    
    override func setConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc func addPostBtnTapped() {
       // addPost()
        let addRoutinVC = AddRoutinViewController()
        addRoutinVC.modalPresentationStyle = .fullScreen
        present(addRoutinVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
        // 처음 시작할때 Post 불러오기
        readPost(next: "")
    }
 
    func bind() {
        
        
        routins
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { row, element, cell in
                cell.configureUI(data: element)
            }
            .disposed(by: disposeBag)
        
        let aa = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ElementReadPostResponse.self))
        
        aa.bind(with: self) { owner, response in
            print("index - \(response.0)")
            print("element - \(response.1)")
        }
        .disposed(by: disposeBag)
    }
}

extension MainViewController : UITableViewDelegate {
    // 스크롤 하는 중일때 실시간으로 반영하는 방법은 없을까?
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            
            let contentSize = scrollView.contentSize.height
            let scrollViewHeight = scrollView.frame.height
            
            //contentOffSet 도 스크롤한 길이를 나타내지만 실시간으로 반영해주진 않는다.
            let offset = scrollView.contentOffset.y
            
            // targetContentOffset.pointee.y: 사용자가 스크롤하면 실시간으로 값을 나타낼 수 있음 속도가 떨어지는 지점을 예측한다.
            let targetPointOfy = targetContentOffset.pointee.y
            
            let doneScrollOffSet = contentSize - scrollViewHeight
            print("contentSize",contentSize)
            print("offset",offset)
            print("scrollViewHeight",scrollViewHeight)
            print("doneScrollOffSet",doneScrollOffSet)
            print("targetContentOffset.y",targetPointOfy)
        
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
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: nextCursor, limit: "", product_id: "yeom"))
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
                   dump(response)
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
