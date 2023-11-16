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
        let duplicateTapped: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailValid: BehaviorSubject<Bool>
        let dulicateTapped: Observable<ValidateEmailResponse>
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
        
        
        return Output(isEmailValid: isEmailValid, dulicateTapped: duplicateTapped, errorMessage: errorMessage)
    }
}
