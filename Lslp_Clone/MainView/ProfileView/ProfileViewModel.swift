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
        let nickText: ControlProperty<String>
    }
    
    struct Output {
        let saveProfile: Observable<PutProfileResponse>
    }
    
    func transform(input: Input) -> Output {
     
        let imageAndNickname = Observable.combineLatest(input.imageData, input.nickText)
        
        let imageTap = input.saveBtn
            .withLatestFrom(imageAndNickname)
            .flatMap { imageData, text in
                
                print("** 넘어온 데이터 : \(imageData)")
                return APIManager.shared.requestPutProfile(api: Router.putProfile(accessToken: UserDefaultsManager.shared.accessToken, nick: text), imageData: imageData)
                    .catch { err in
                        if let err = err as? PutProfileError {
                            
                        }
                        return Observable.never()
                    }
            }
        
        
        
        return Output(saveProfile: imageTap)
    }
}
