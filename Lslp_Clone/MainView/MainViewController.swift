//
//  MainViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/20.
//

import UIKit
import RxSwift

class MainViewController : BaseViewController {
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        self.navigationItem.hidesBackButton = true
      
        
       let aa = APIManager.shared.requestAddPost(api: Router.addPost(accessToken:   "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NWIyMDk1ZDQ5MGYwNTliZjZhYzE2MSIsImlhdCI6MTcwMDQ3MDk1NSwiZXhwIjoxNzAwNDc4MTU1LCJpc3MiOiJzZXNhY18zIn0.dVyQjLatBBTnFPmQ_55NUTGqaI9vU5EsQnCO8aYg_nM"))
            .catch { err in
                if let err = err as? ContentError {
                    print(err.errorDescrtion)
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                dump(response)
            }
            .disposed(by: disposeBag)
           
        
        // TODO: - Post(조회)하기를 통해 내가 작성한 게시글 불러오기 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
    }
    
    
}
