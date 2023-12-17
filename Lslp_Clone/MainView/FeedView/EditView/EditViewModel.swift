//
//  EditViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/13.
//

import Foundation
import RxSwift
import RxCocoa

class EditViewModel : BaseInOutPut {
    struct Input {
        let titleText: ControlProperty<String>
        let contentText: ControlProperty<String>
        let imageData: PublishSubject<Data>
        let editBtn: ControlEvent<Void>
        let postID: String
    }
    
    struct Output {
        let editBtnClicked: Observable<ElementReadPostResponse>
        let errorMessage: PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let errorMessage = PublishSubject<String>()
        
        let rowData = Observable.combineLatest(input.titleText, input.contentText, input.imageData)
        
        let editBtnClicked = rowData
            .flatMap { title, content, imageData in
                APIManager.shared.requestModifyPost(api: Router.modifyPost(asccessToken: UserDefaultsManager.shared.accessToken, postID: input.postID, title: title, content: content, product_id: "yeom"), imageData: imageData)
                    .catch { err in
                        if let err = err as? ModifyError {
                            
                            print("🙏🏻 - 게시글 편집 에러 : \(err.errorDescription)")
                            
                            errorMessage.onNext("🙏🏻 - 게시글 편집 에러 : \(err.errorDescription)")
                        }
                        return Observable.never()
                    }
            }
        
        return Output(editBtnClicked: editBtnClicked, errorMessage: errorMessage)
    }
}
