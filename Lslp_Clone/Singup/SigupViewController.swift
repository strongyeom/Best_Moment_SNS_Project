//
//  ViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SigupViewController: BaseViewController {
    
    let button11 = {
        let view = UIButton()
        view.setTitle("로그인", for: .normal)
        view.setTitleColor(.green, for: .normal)
        return view
    }()
    
    let button12 = {
        let view = UIButton()
        view.setTitle("회원가입", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        print("SigupViewController - configure")
        view.addSubview(button12)
        view.addSubview(button11)
        
        button11.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        
        button12.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        button11.rx.tap
            .bind(with: self) { owner, _ in
                print("로그인")
                
                APIManager.shared.reqeustLogin(api: Router.login(email: "aasx11223@sdsc1aa.com", password: "1234"))
                //  .catch(<#T##handler: (Error) throws -> Observable<Token>##(Error) throws -> Observable<Token>#>)
                    .catch { // catch : Error가 발생하면 스트림이 끊어지지 않게 새로운 Observable을 방출함
                        if let err = $0 as? LoginError {
                            print(err)
                        }
                        return Observable.just(Token(token: "", refreshToken: ""))
                    }// 여기까지는 Observable<Token>
                // 해당 Observable만 내려오기 때문에 drive를 사용해도 가능
                    .asDriver(onErrorJustReturn: Token(token: "", refreshToken: ""))
                    .drive(with: self, onNext: { owner, response in
                        dump(response)
                    })
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        
        button12.rx.tap
            .bind(with: self, onNext: { owner, _ in
                print("회원가입")
                
                APIManager.shared.request(api: Router.signup(email: "aasx123@sdsc1aa.com", password: "1234", nickname: "yeom"))
                    // 네트워크가 끊길수도 있기때문에
                    .catch({ error -> Observable<JoinResponse> in
                        if let err = error as? SignupError {
                            print(err.errorDescription)
                        }
                        return Observable.just(JoinResponse(email: "", nick: ""))
                    })
                    .asDriver(onErrorJustReturn: JoinResponse(email: "", nick: ""))
                    .drive(with: self) { owner, response in
                        dump(response)
                    }
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        
    }
    
}
