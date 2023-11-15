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

class SignupViewController: BaseViewController {
    
    let nicknameTextField = SignInTextField(placeHolder: "닉네임을 설정해주세요.", brandColor: .blue)
    let emailTextField = SignInTextField(placeHolder: "이메일을 입력해주세요.", brandColor: .blue)
    let passwordTextField = SignInTextField(placeHolder: "비밀번호를 입력해주세요", isSecure: true, brandColor: .blue)
    let duplicateBtn = {
       let button = UIButton()
        button.setCornerButton(text: "중복확인", brandColor: .lightGray)
        return button
    }()
    
    let signupBtn = {
       let button = UIButton()
        button.setCornerButton(text: "회원 가입 완료", brandColor: .blue)
        return button
    }()
    
    let viewModel = SignupViewModel()
    
    // 이메일 검증 문구
   // let emailValidMessage = PublishSubject<String>()
    let emailValid = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        super.configure()
        print("SigupViewController - configure")
        bind()
    }
    
    func bind() {
        
        emailValid
            .bind(with: self, onNext: { owner, result in
                owner.signupBtn.isEnabled = result
                let color = result ? UIColor.blue : UIColor.lightGray
                owner.signupBtn.backgroundColor = color
            })
            .disposed(by: disposeBag)
 
        /// 이메일 중복 체크
        duplicateBtn.rx.tap
            .flatMap {
                APIManager.shared.requestIsValidateEmail(api: Router.valid(emial: self.emailTextField.text ?? ""))
                    .catch { err -> Observable<ValidateEmailResponse> in
                        if let err = err as? ValidateEmailError {
                            self.setEmailValidAlet(text: err.errorDescription, completionHandler: nil)
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self, onNext: { owner, response in
                owner.setEmailValidAlet(text: response.message, completionHandler: nil)
                owner.emailValid.onNext(true)
            })
            .disposed(by: disposeBag)
        
        
        // nick: yeom, email: yeom@12, pass: 12
        // yeom123 12yeom@12 12  숫자 들어김
        // bebeen bebeen@12 12
        // m123 m123 12
        // n123 n123 12
        /// 회원 가입
        signupBtn.rx.tap
            .flatMap {
                APIManager.shared.requestSignup(api: Router.signup(email: self.nicknameTextField.text ?? "", password: self.passwordTextField.text ?? "", nickname: self.nicknameTextField.text ?? ""))
                    .catch { err in
                        if let err = err as? SignupError {
                            self.setEmailValidAlet(text: err.errorDescription, completionHandler: nil)
                            self.emailValid.onNext(false)
                        }
                        return Observable.never()
                    }
            }
            .bind(with: self, onNext: { owner, response in
                print(response)
                
                // TODO: - 로그인 해서 토큰 UD에 저장하기
                // TODO: - 회원 가입 후 메인 뷰로 이동 메서드 만들기
            })
            .disposed(by: disposeBag)
        
 
    }
    
   
    
    override func setConstraints() {
        [nicknameTextField, emailTextField, passwordTextField, duplicateBtn, signupBtn].forEach {
            view.addSubview($0)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        duplicateBtn.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextField)
            make.width.equalTo(100)
            make.leading.equalTo(emailTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signupBtn.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        
    }
    
}

extension SignupViewController {
//    func bind() {
//        /// 회원가입
//        signupBtn.rx.tap
//            .bind(with: self, onNext: { owner, _ in
//                print("회원가입")
//
//                APIManager.shared.request(api: Router.signup(email: "aas1234@sdsc1aa.com", password: "1234", nickname: "yeom"))
//                    // 네트워크가 끊길수도 있기때문에
//                    .catch({ error -> Observable<JoinResponse> in
//                        if let err = error as? SignupError {
//                            print(err.errorDescription)
//                        }
//                        return Observable.never()
//                    })
//                    .asDriver(onErrorJustReturn: JoinResponse(email: "", nick: ""))
//                    .drive(with: self) { owner, response in
//                        dump(response)
//                    }
//                    .disposed(by: self.disposeBag)
//            })
//            .disposed(by: disposeBag)
//
//        /// 로그인
//        loginBtn.rx.tap
//            .bind(with: self) { owner, _ in
//                print("로그인")
//
//                APIManager.shared.reqeustLogin(api: Router.login(email: "aas1234@sdsc1aa.com", password: "1234"))
//                // catch (handler: (Error) throws -> Observable<Token>)
//                    .catch { // catch : Error가 발생하면 스트림이 끊어지지 않게 새로운 Observable을 방출함
//                        if let err = $0 as? LoginError {
//                            print(err.errorDescription)
//                        }
//                        return Observable.never()
//                    }// 여기까지는 Observable<Token>
//                // 해당 Observable만 내려오기 때문에 drive를 사용해도 가능
//                    .asDriver(onErrorJustReturn: TokenResponse(token: "", refreshToken: ""))
//                    .drive(with: self, onNext: { owner, response in
//                       // dump(response)
//                        owner.accessToken.onNext(response.token)
//                        print("accessToken - \(try! owner.accessToken.value())")
//                        // owner.accessToken = response.token
//                        owner.refreshToken.onNext(response.refreshToken)
//                        print("refreshToken - \(try! owner.refreshToken.value())")
//                    })
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
//
//        /// 이메일 검증
//        // 회원가입 할때 Email TextField에서 검증해야함
//        validEmailBtn.rx.tap
//            .bind(with: self) { owner, _ in
//                APIManager.shared.requestIsValidateEmail(api: Router.valid(emial: "aas1234@sdsc1aa.com"))
//                    .catch { err -> Observable<ValidateEmailResponse> in
//                        if let err = err as? ValidateEmailError {
//                            print(err.errorDescription)
//                        }
//                        return Observable.never()
//                    }
//                    .asDriver(onErrorJustReturn: ValidateEmailResponse(message: ""))
//                    .drive(with: self) { owner, response in
//                        dump(response)
//                    }
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
//
//
//        /// 컨텐츠
//        contentBtn.rx.tap
//            .withLatestFrom(accessToken)
//            .bind(with: self) { owner, token in
//                APIManager.shared.requestContent(api: Router.content(accessToken: token))
//                    .catch { err -> Observable<ContentResponse> in
//                        if let err = err as? ContentError {
//                            print(err.errorDescrtion)
//                        }
//                        return Observable.never()
//                    }
//                    .asDriver(onErrorJustReturn: ContentResponse(message: ""))
//                    .drive(with: self) { owner, response in
//                        dump(response)
//                    }
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
//
//
//        let tokens = Observable.zip(accessToken, refreshToken)
//
//        /// 리프레쉬 버튼
//        refreshBtn.rx.tap
//            .withLatestFrom(tokens)
//            .bind(with: self) { owner, tokens in
//                APIManager.shared.requestRefresh(api: Router.refresh(access: tokens.0, refresh: tokens.1))
//                    .catch { err -> Observable<RefreshResponse> in
//                        if let err = err as? RefreshError {
//                            dump(err.errorDescription)
//                        }
////                        return Observable.just(RefreshResponse(accessToken: ""))
//                        return Observable.never()
//                    }
//                    .asDriver(onErrorJustReturn: RefreshResponse(accessToken: ""))
//                    .drive(with: self) { owner, response in
//                        print(response)
//                        // 토큰이 만료되지 않았을 때 빈값을 던져줌
//                        owner.accessToken.onNext(response.accessToken)
//                        print("리프레쉬 Response - 어떤 값? : ", try! owner.accessToken.value())
//                    }
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
//
//        logoutBtn.rx.tap
//            .withLatestFrom(accessToken)
//            .bind(with: self) { owner, token in
//                APIManager.shared.requestLogOut(api: Router.logOut(access: token))
//                    .catch { err -> Observable<LogOutResponse> in
//                        if let err = err as? LogOutError {
//                            print(err.errorDescrtion)
//                        }
//                        return Observable.never()
//                    }
//                    .asDriver(onErrorJustReturn: LogOutResponse(_id: "", email: "", nick: ""))
//                    .drive(with: self) { owner, response in
//                        print(response)
//                    }
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: disposeBag)
//
//
//        let observable2 = Observable<Void>.never()
//
//        observable2
//            .subscribe(onNext: { _ in
//                print("어떤게??")
//            }, onDisposed: {
//                print("onDisposed")
//            })
//            .disposed(by: disposeBag)
//
//    }
}
