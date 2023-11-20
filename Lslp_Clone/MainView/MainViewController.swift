//
//  MainViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/20.
//

import UIKit
import RxSwift

class MainViewController : BaseViewController {
    
    
    let readBtn = {
       let button = UIButton()
        button.setTitle("읽기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = .green
        print("MainViewController - configure")
        self.navigationItem.hidesBackButton = true
        addPost()
        // TODO: - Post(조회)하기를 통해 내가 작성한 게시글 불러오기 
    }
    
    override func setConstraints() {
        view.addSubview(readBtn)
        
        readBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        readBtn.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
    }
    
    @objc func startBtnTapped() {
        readPost()
    }
    
    func addPost() {
        
           APIManager.shared.requestAddPost(api: Router.addPost(accessToken: UserDefaultsManager.shared.accessToken, title: "이제 부터 시작22222", content: "자 이제 시작이야 내꿈을2222222222", product_id: "yeom"))
              .catch { err in
                  if let err = err as? AddPostError {
                      print(err.errorDescrtion)
                  }
                  return Observable.never()
              }
              .bind(with: self) { owner, response in
                  print("MainVC - AddPostResponse \(response)")
              }
              .disposed(by: disposeBag)
    }
    
    func readPost() {
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: "", limit: "", product_id: "yeom"))
            .catch { err in
                if let err = err as? ReadPostError {
                    print(err.errorDescrtion)
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                dump(response)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainViewController - viewWillAppear")
    }
    
    
}
