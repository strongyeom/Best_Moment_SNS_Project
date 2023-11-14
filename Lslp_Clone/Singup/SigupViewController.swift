//
//  ViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa

class SigupViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        print("SigupViewController - configure")
        APIManager.shared.request(api: Router.signup(email: "aasxcza@sdsc1aa.com", password: "1234", nickname: "yeom"))
            .asDriver(onErrorJustReturn: JoinResponse(email: "", nick: ""))
            .drive(with: self) { owner, response in
                dump(response)
            }
            .disposed(by: disposeBag)
    }


}

