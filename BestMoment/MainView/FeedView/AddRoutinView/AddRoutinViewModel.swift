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
        
    struct Input {
        let firstRoutin: ControlProperty<String>
        let saveBtn: ControlEvent<Void>
        let imageData: PublishSubject<Data>
    }
    
    struct Output {
        
        let saveBtnTapped: Observable<AddPostResponse>
        let errorMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
                print("넘어온 imageData - \(input.imageData)")
        
        let errorMessage = PublishSubject<String>()
        
        let addText = Observable.combineLatest(input.firstRoutin, input.imageData)
        
        let saveBtnTapped = input.saveBtn
            .debug("저장하기 버튼 눌렸을때 : ")
            .withLatestFrom(addText)
            .flatMap { first, imageData in

                print("루틴 1 : \(first)")
                print("이미지 Data : \(imageData)")
           
               
                return APIManager.shared.requestAddPost(api: Router.addPost(accessToken: UserDefaultsManager.shared.accessToken, content: first, product_id: "yeom"), imageData: imageData)
                    .catch { err in
                        if let err = err as? AddPostError {
                            print("🙏🏻 - 게시글 작성하기 에러 : \(err.errorDescrtion)")
                            errorMessage.onNext("🙏🏻 - 게시글 작성하기 에러 : \(err.errorDescrtion)")
                        }
                        return Observable.never()
                    }
            }

        return Output(saveBtnTapped: saveBtnTapped, errorMessage: errorMessage)
    }
}
