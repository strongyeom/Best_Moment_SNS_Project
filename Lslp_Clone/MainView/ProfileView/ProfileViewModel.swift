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
        let saveBtn: ControlEvent<Void>
        let imageTap: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let putImageClicked: Observable<GetProfileResponse>
    }
    
    func transform(input: Input) -> Output {
     
        let imageTap = input.saveBtn
//            .withLatestFrom(input.imageData)
            .flatMap { imageData in
                return APIManager.shared.requestPutProfile(api: Router.putProfile(accessToken: UserDefaultsManager.shared.accessToken, nick: "135"), imageData: nil)
                    .catch { err in
                        if let err = err as? PutProfileError {
                            
                        }
                        return Observable.never()
                    }
            }
        
        
        
        return Output(putImageClicked: imageTap)
    }
}
