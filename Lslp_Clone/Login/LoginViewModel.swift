//
//  LoginViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/17.
//

import RxSwift
import RxCocoa

class LoginViewModel: BaseInOutPut {
    
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText:
            ControlProperty<String>
        let loginBtn:
            ControlEvent<Void>
        let signupBtn:
            ControlEvent<Void>
    }
    
    struct Output {
        let loginBtnTapped: Observable<TokenResponse>
        let errorMessage:
            PublishSubject<String>
        let signupTapped:
            ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMessage = PublishSubject<String>()
        
        let loginInfo = Observable.zip(input.emailText, input.passwordText)
        
        
        let loginBtnTapped = input.loginBtn
            .withLatestFrom(loginInfo)
            .flatMap { email, password in
                APIManager.shared.reqeustLogin(api: Router.login(email: String(email), password: String(password)))
            }
            .catch { err in
                if let err = err as? LoginError {
                    errorMessage.onNext(err.errorDescription)
                }
                return Observable.never()
            }
            .debug()
        
        
        let signupTapped = input.signupBtn
        
        return Output(loginBtnTapped: loginBtnTapped, errorMessage: errorMessage, signupTapped: signupTapped)
    }
}
