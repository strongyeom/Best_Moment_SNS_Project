//
//  InOutPro.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import Foundation

protocol BaseInOutPut {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
