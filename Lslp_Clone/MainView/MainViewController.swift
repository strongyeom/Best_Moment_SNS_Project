//
//  MainViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/20.
//

import UIKit
import RxSwift

class MainViewController : BaseViewController {

    lazy var addPostBtn = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostBtnTapped))
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = addPostBtn
    }

    @objc func addPostBtnTapped() {
       // addPost()
        present(AddRoutinViewController(), animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
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
