//
//  MainViewModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//
import Foundation
import RxSwift
import RxCocoa

class MainViewModel: BaseInOutPut {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let tableViewIndex:  ControlEvent<IndexPath>
        let tableViewElement:  ControlEvent<ElementReadPostResponse>
    }
    
    struct Output {
        let zip: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<ElementReadPostResponse>.Element)>
    }
    
    func transform(input: Input) -> Output {
        
        
        let zip = Observable.zip(input.tableViewIndex, input.tableViewElement)
        
        return Output(zip: zip)
    }
}
