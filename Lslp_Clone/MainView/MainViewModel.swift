//
//  MainViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import RxSwift
import RxCocoa

class MainViewModel: BaseInOutPut {
    
    var isBottmEnd = BehaviorSubject(value: false)
    var routinArray: [ElementReadPostResponse] = []
    lazy var routins = BehaviorSubject(value: routinArray)
    
    let disposeBag = DisposeBag()
    
    var remainCursor = ""
    var nextCursor = ""
    
    struct Input {
        let isBottomEnd: BehaviorSubject<Bool>
        let routins: BehaviorSubject<[ElementReadPostResponse]>
    }
    
    struct Output {
        
        let routins: BehaviorSubject<[ElementReadPostResponse]>
        let isBottomEnd: BehaviorSubject<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        
        
        routins.flatMap { _ in
            return APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: self.nextCursor, limit: "", product_id: "yeom"))
                .catch { err in
                    if let err = err as? ReadPostError {
                        print(err.errorDescrtion)
                        print(err.rawValue)
                        if err.rawValue == 419 {
                            //                        self.refreshToken()
                        }
                    }
                    return Observable.never()
                }
        }
            .bind(with: self) { owner, response in
                owner.nextCursor = response.next_cursor
                owner.routinArray.append(contentsOf: response.data)
                input.routins.onNext(owner.routinArray)
            }
            .disposed(by: disposeBag)
        
        input.isBottomEnd
            .bind(with: self) { owner, result in
                if result {
                    if owner.nextCursor != owner.remainCursor {
                        owner.remainCursor = owner.nextCursor
                       // owner.readPost(next: owner.nextCursor)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(routins: routins, isBottomEnd: input.isBottomEnd)
    }
    
    
    
    init(next: String = "") {
        APIManager.shared.requestReadPost(api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: "", product_id: "yeom"))
            .catch { err in
                if let err = err as? ReadPostError {
                    print(err.errorDescrtion)
                    print(err.rawValue)
                    if err.rawValue == 419 {
//                        self.refreshToken()
                    }
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                   dump(response)
                owner.routinArray = response.data
                owner.routins.onNext(owner.routinArray)
            }
            .disposed(by: disposeBag)
    }
}
