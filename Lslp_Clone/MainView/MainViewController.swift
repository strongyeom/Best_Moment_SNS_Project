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
      
         APIManager.shared.requestAddPost(api: Router.addPost(accessToken: UserDefaultsManager.shared.accessToken, title: "이제 부터 시작", content: "자 이제 시작이야 내꿈을", product_id: "yeom"))
            .catch { err in
                if let err = err as? ContentError {
                    print(err.errorDescrtion)
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                print("MainVC - response \(response)")
            }
            .disposed(by: disposeBag)
           
        
        // TODO: - Post(조회)하기를 통해 내가 작성한 게시글 불러오기 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
    }
    
    
}
