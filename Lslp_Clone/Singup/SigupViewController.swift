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
    
    let loginBtn = {
        let view = UIButton()
        view.setTitle("로그인", for: .normal)
        view.setTitleColor(.green, for: .normal)
        return view
    }()
    
    let signupBtn = {
        let view = UIButton()
        view.setTitle("회원가입", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    let validEmailBtn = {
        let view = UIButton()
        view.setTitle("이메일 검증", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    let contentBtn = {
        let view = UIButton()
        view.setTitle("컨텐츠 버튼", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    let refreshBtn = {
        let view = UIButton()
        view.setTitle("리프레쉬 버튼", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        return view
    }()
    
    let logoutBtn = {
        let view = UIButton()
        view.setTitle("로그아웃 버튼", for: .normal)
        view.setTitleColor(.red, for: .normal)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // 로그인하면 나오는 accessToken
    var accessToken: String = ""
    // 로그인하면 나오는 RefreshToken
    var refreshToken: String = ""
    
    let disposeBag = DisposeBag()
    
    override func configure() {
        super.configure()
        print("SigupViewController - configure")
        view.addSubview(signupBtn)
        view.addSubview(loginBtn)
        view.addSubview(validEmailBtn)
        view.addSubview(contentBtn)
        view.addSubview(refreshBtn)
        view.addSubview(logoutBtn)
        
        loginBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        
        signupBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        validEmailBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(40)
        }
        
        contentBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(80)
        }
        
        refreshBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(120)
        }
        
        logoutBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(160)
        }
        
        /// 회원가입
        signupBtn.rx.tap
            .bind(with: self, onNext: { owner, _ in
                print("회원가입")
                
                APIManager.shared.request(api: Router.signup(email: "aas1234@sdsc1aa.com", password: "1234", nickname: "yeom"))
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
        
        /// 로그인
        loginBtn.rx.tap
            .bind(with: self) { owner, _ in
                print("로그인")
                
                APIManager.shared.reqeustLogin(api: Router.login(email: "aas1234@sdsc1aa.com", password: "1234"))
                //  .catch(<#T##handler: (Error) throws -> Observable<Token>##(Error) throws -> Observable<Token>#>)
                    .catch { // catch : Error가 발생하면 스트림이 끊어지지 않게 새로운 Observable을 방출함
                        if let err = $0 as? LoginError {
                            print(err.errorDescription)
                        }
                        return Observable.just(TokenResponse(token: "", refreshToken: ""))
                    }// 여기까지는 Observable<Token>
                // 해당 Observable만 내려오기 때문에 drive를 사용해도 가능
                    .asDriver(onErrorJustReturn: TokenResponse(token: "", refreshToken: ""))
                    .drive(with: self, onNext: { owner, response in
                        dump(response)
                        owner.accessToken = response.token
                        owner.refreshToken = response.refreshToken
                    })
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        /// 이메일 검증
        // 회원가입 할때 Email TextField에서 검증해야함
        validEmailBtn.rx.tap
            .bind(with: self) { owner, _ in
                APIManager.shared.requestIsValidateEmail(api: Router.valid(emial: "aas1234@sdsc1aa.com"))
                    .catch { err -> Observable<ValidateEmailResponse> in
                        if let err = err as? ValidateEmailError {
                            print(err.errorDescription)
                        }
                        return Observable.just(ValidateEmailResponse(message: ""))
                    }
                    .asDriver(onErrorJustReturn: ValidateEmailResponse(message: ""))
                    .drive(with: self) { owner, response in
                        dump(response)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        /// 컨텐츠
        contentBtn.rx.tap
            .bind(with: self) { owner, _ in
                APIManager.shared.requestContent(api: Router.content(accessToken: self.accessToken))
                    .catch { err -> Observable<ContentResponse> in
                        if let err = err as? ContentError {
                            print(err.errorDescrtion)
                        }
                        return Observable.just(ContentResponse(message: ""))
                    }
                    .asDriver(onErrorJustReturn: ContentResponse(message: ""))
                    .drive(with: self) { owner, response in
                        dump(response)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        /// 리스레쉬 토큰
        refreshBtn.rx.tap
            .bind(with: self) { owner, _ in
                APIManager.shared.requestRefresh(api: Router.refresh(access: self.accessToken, refresh: self.refreshToken))
                    .catch { err -> Observable<RefreshResponse> in
                        if let err = err as? RefreshError {
                            dump(err.errorDescription)
                        }
                        return Observable.just(RefreshResponse(reAccessToken: ""))
                    }
                    .asDriver(onErrorJustReturn: RefreshResponse(reAccessToken: ""))
                    .drive(with: self) { owner, response in
                        print(response)
                        owner.accessToken = response.reAccessToken
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        logoutBtn.rx.tap
            .bind(with: self) { owner, _ in
                APIManager.shared.requestLogOut(api: Router.logOut(access: self.accessToken))
                    .catch { err -> Observable<LogOutResponse> in
                        if let err = err as? LogOutError {
                            print(err.errorDescrtion)
                        }
                        return Observable.just(LogOutResponse(_id: "", email: "", nick: ""))
                    }
                    .asDriver(onErrorJustReturn: LogOutResponse(_id: "", email: "", nick: ""))
                    .drive(with: self) { owner, response in
                        print(response)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
    }
    
}
