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
            .flatMap { emailText in
                return APIManager.shared.requestAPIFunction(type: ValidateEmailResponse.self, api: Router.valid(email: emailText), section: .valid)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻 이메일 인증 에러 - \(err.description)")
                            errorMessage.onNext("🙏🏻 이메일 인증 에러 - \(err.description)")
                        }
                        return Observable.never()
                    }
            }
            .debug()
        
        let pairOfThreeInfo = Observable.combineLatest(input.emailText, input.passwordText, input.nickText)
            
        
        let signBtnTapped = input.signupBtnTapped
            .withLatestFrom(pairOfThreeInfo)
            .flatMap { email, password, nick in
                
                return APIManager.shared.requestAPIFunction(type: JoinResponse.self, api: Router.signup(email: email, password: password, nickname: nick), section: .signup)
                    .catch { err in
                        if let err = err as? NetworkAPIError {
                            print("🙏🏻 회원 가입 에러 - \(err.description)")
                        }
                        return Observable.never()
                    }
            }
            .debug()
        
        return Output(isEmailValid: isEmailValid, dulicateTapped: duplicateTapped, signupBtnTapped: signBtnTapped, errorMessage: errorMessage)
    }
}
