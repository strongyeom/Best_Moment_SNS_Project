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
            .withLatestFrom(addText)
            .flatMap { title, first, imageData in
                print("제목 : \(title)")
                print("루틴 1 : \(first)")
//                print("imageData : \(imageData)")
                return APIManager.shared.requestAddPost(api: Router.addPost(accessToken: UserDefaultsManager.shared.accessToken, title: String(title), content: String(first), product_id: "yeom"), imageData: imageData)
                    .retry(1)
                    .catch { err in
                        if let err = err as? AddPostError {
                            print("AddRoutinViewModel - transform \(err.errorDescrtion) , \(err.rawValue)")
                            if err.rawValue == 419 {
//                                self.exampleRefresh()
                                RefreshTokenViewModel.shared.refreshToken {
                                    print("리프레쉬 토큰 만료")
                                }
                            }
                            
                        }
                       
                        return Observable.never()
                    }
            }

        return Output(saveBtnTapped: saveBtnTapped)
    }
    
    
    func exampleRefresh() {
        APIManager.shared.requestRefresh(api: Router.refresh(access: UserDefaultsManager.shared.accessToken, refresh: UserDefaultsManager.shared.refreshToken))
            .catch { err in
                if let err = err as? RefreshError {
                    if err.rawValue == 418 {
                
                    }
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                print("엑세스 토큰 갱신 --- \(response.token)")
                UserDefaultsManager.shared.saveAccessToken(accessToken: response.token)
            }
            .disposed(by: disposeBag)
    }
}
