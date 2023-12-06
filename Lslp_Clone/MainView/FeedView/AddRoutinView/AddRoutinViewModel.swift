//
//  AddRoutinViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import RxSwift
import RxCocoa
import Foundation

class AddRoutinViewModel: BaseInOutPut {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let title: ControlProperty<String>
        let firstRoutrin: ControlProperty<String>
        let saveBtn: ControlEvent<Void>
        let imageData: PublishSubject<Data>
    }
    
    struct Output {
        
        let saveBtnTapped: Observable<AddPostResponse>
    }
    
    func transform(input: Input) -> Output {
                print("넘어온 imageData - \(input.imageData)")
        
        let addText = Observable.combineLatest(input.title, input.firstRoutrin, input.imageData)
        
        let saveBtnTapped = input.saveBtn
            .debug()
            .withLatestFrom(addText)
            .flatMap { title, first, imageData in

                print("제목 : \(title)")
                print("루틴 1 : \(first)")
                print("이미지 Data : \(imageData)")
           
               
                return APIManager.shared.requestAddPost(api: Router.addPost(accessToken: UserDefaultsManager.shared.accessToken, title: String(title), content: String(first), product_id: "yeom"), imageData: imageData)
                    .catch { err in
                        if let err = err as? AddPostError {
                            print("AddRoutinViewModel - transform \(err.errorDescrtion) , \(err.rawValue)")
                            if err.rawValue == 419 {
//
                            }
                        }
                        return Observable.never()
                    }
            }

        return Output(saveBtnTapped: saveBtnTapped)
    }
}
