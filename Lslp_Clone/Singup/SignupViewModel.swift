//
//  SignupViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import RxSwift
import RxCocoa

class SignupViewModel: BaseInOutPut {
    
    struct Input {
        let emailText: ControlProperty<String>
        let nickText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        
        let duplicateTapped: ControlEvent<Void>
        let signupBtnTapped:
            ControlEvent<Void>
    }
    
    struct Output {
        let isEmailValid: BehaviorSubject<Bool>
        let dulicateTapped: Observable<ValidateEmailResponse>
        let signupBtnTapped: Observable<JoinResponse>
        let errorMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let isEmailValid = BehaviorSubject(value: false)
        let errorMessage = PublishSubject<String>()
        
        let duplicateTapped = input.duplicateTapped
            .withLatestFrom(input.emailText)
            .map { String($0)}
            .flatMap { emailText in
                APIManager.shared.requestIsValidateEmail(api: Router.valid(email: emailText))
                    .catch { err -> Observable<ValidateEmailResponse> in
                        if let err = err as? ValidateEmailError {
                            print(err.errorDescription)
                            errorMessage.onNext(err.errorDescription)
                        }
                        return Observable.never()
                    }
            }
            .debug()
        
        let pairOfThreeInfo = Observable.zip(input.emailText, input.passwordText, input.nickText)
            
        
        let signBtnTapped = input.signupBtnTapped
            .withLatestFrom(pairOfThreeInfo)
            .flatMap { email, password, nick in
                APIManager.shared.requestSignup(api: Router.signup(email: String(email), password: String(password), nickname: String(nick)))
                    .catch { err in
                        if let err = err as? SignupError {
                            errorMessage.onNext(err.errorDescription)
                            isEmailValid.onNext(false)
                        }
                        return Observable.never()
                    }
            }
            .debug()
        
        return Output(isEmailValid: isEmailValid, dulicateTapped: duplicateTapped, signupBtnTapped: signBtnTapped, errorMessage: errorMessage)
    }
}
