//
//  MainViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/20.
//

import UIKit
import RxSwift

final class MainViewController : BaseViewController {
    
    let tableView = {
        let tableView = UITableView()
        tableView.rowHeight = 180
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()

    lazy var addPostBtn = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostBtnTapped))
        return button
    }()
    
    var routinArray: [ElementReadPostResponse] = []
    lazy var routins = BehaviorSubject(value: routinArray)
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addPostBtn
        bind()
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
        readPost()
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
            print("element - \(response.1.title)")
        }
        .disposed(by: disposeBag)
            
        
//        tableView.rx.itemSelected
//            .bind(with: self) { onwer, index in
//                print(index)
//            }
//            .disposed(by: disposeBag)
//
//        tableView.rx.modelSelected(ElementReadPostResponse.self)
//            .bind(with: self) { owner, response in
//                print("response.title \(response.title)")
//            }
//            .disposed(by: disposeBag)
//
    }
    
}

extension MainViewController {
    func readPost() {
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: "", limit: "", product_id: "yeom"))
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
                owner.routinArray = response.data
                owner.routins.onNext(owner.routinArray)
            }
            .disposed(by: disposeBag)
    }
}

/*
 func readPost() {
     APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: "", limit: "", product_id: "yeom"))
         .catch { err in
             if let err = err as? ReadPostError {
                 print(err.errorDescrtion)
                 print(err.rawValue)
                 if err.rawValue == 419 {
                     self.refreshToken()
                 }
             }
             return Observable.never()
         }
         .bind(with: self) { owner, response in
//                dump(response)
         }
         .disposed(by: disposeBag)
 }
 
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
