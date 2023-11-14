//
//  APIManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: Error {
    case inValidURL
    case unkwoned
    case networkError
}

class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func request(api: Router) -> Observable<JoinResponse> {
        return Observable<JoinResponse>.create { observer in
//            guard let url = URL(string: BaseAPI.baseUrl) else {
//                observer.onError(APIError.inValidURL)
//                print("URL 에러 ")
//                return Disposables.create()
//            }
            
            
            AF.request(api)
                .validate(statusCode: 200..<500)
                .responseDecodable(of: JoinResponse.self) { response in
                    print("APIManager - StatusCode : \(response.response!.statusCode)")
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        print(error.localizedDescription)
                        observer.onError(APIError.networkError)
                    }
                }
            
            
            return Disposables.create()
        }
    }
}
