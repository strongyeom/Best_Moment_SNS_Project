//
//  APIManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation
import RxSwift

enum APIError: Error {
    case inValidURL
    case unkwoned
    
}

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func request() -> Observable<JoinResponse> {
        return Observable<JoinResponse>.create { observer in
            guard let url = URL(string: BaseAPI.baseUrl) else {
                observer.onError(APIError.inValidURL)
                return Disposables.create()
            }
            
            
            
            
            
            return Disposables.create()
        }
    }
}
