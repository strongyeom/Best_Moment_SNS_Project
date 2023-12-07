//
//  ProfileViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/07.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel: BaseInOutPut {
    
    struct Input {
        let imageData: PublishSubject<Data>
        let imageTap: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let imageTap: Observable<GetProfileResponse>
    }
    
    func transform(input: Input) -> Output {
        
        let imageTap = input.imageTap
            .withLatestFrom(input.imageData)
            .flatMap { imageData in
                return APIManager.shared.requestPutProfile(api: Router.putProfile(accessToken: UserDefaultsManager.shared.accessToken), imageData: imageData)
                    .catch { err in
                        if let err = err as? PutProfileError {
                            
                        }
                        return Observable.never()
                    }
            }
        
        
        
        return Output(imageTap: imageTap)
    }
}
