//
//  LoginViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/17.
//

import RxSwift
import RxCocoa

final class LoginViewModel: BaseInOutPut {
    
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
        
        let loginInfo = Observable.combineLatest(input.emailText, input.passwordText)
        
        
        let loginBtnTapped = input.loginBtn
            .withLatestFrom(loginInfo)
            .flatMap { email, password in
                print("email, password", email, password)
                
                return APIManager.shared.requestAPIFunction(type: TokenResponse.self, api: Router.login(email: email, password: password), section: .login)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻 로그인 에러 - \(err.description)")
                            errorMessage.onNext("🙏🏻 로그인 에러 - \(err.description)")
                        }
                        return Observable.never()
                    }
            }
           
           
        
        
        let signupTapped = input.signupBtn
        
        return Output(loginBtnTapped: loginBtnTapped, errorMessage: errorMessage, signupTapped: signupTapped)
    }
}
