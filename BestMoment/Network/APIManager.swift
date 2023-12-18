//
//  APIManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation
import RxSwift
import Alamofire




class APIManager {
    static let shared = APIManager()
    
    private init() { }
   
    // ->>> 게시글 관련해서만 테스트로 onCompleted 작성함
    
    /// 게시글 작성하기
    func requestAddPost(api: Router, imageData: Data?) -> Observable<AddPostResponse> {
        return Observable<AddPostResponse>.create { observer in
            AF.upload(multipartFormData: { multiPartForm in
                
                for (key, value) in api.query! {
                    multiPartForm.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
                }
                
                if let imageData {
                    multiPartForm.append(imageData, withName: "file", fileName: "\(api.path).jpg", mimeType: "image/jpg")
                    print("imageData 크기 - \(imageData)")
                }
                
                
            }, with: api, interceptor: AuthManager())
            .validate(statusCode: 200...300)
            .responseDecodable(of: AddPostResponse.self) { response in
                guard let status = response.response?.statusCode else { return }
                print("컨텐츠 상태 코드 ", status)
                
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    if let commonError = CommonError(rawValue: status) {
                        print("CommonError - \(commonError)")
                        observer.onError(commonError)
                    }
                    
                    if let contentError = AddPostError(rawValue: status) {
                        
                        print("contentError - \(contentError)")
                        observer.onError(contentError)
                    }
                }
                
            }
            return Disposables.create()
        }
    }
    
    ///게시글 수정하기
    func requestModifyPost(api: Router, imageData: Data?) -> Observable<ElementReadPostResponse> {
            return Observable<ElementReadPostResponse>.create { observer in
                AF.upload(multipartFormData: { multiPartForm in
                    
                    for (key, value) in api.query! {
                        multiPartForm.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
                    }
                    
                    if let imageData {
                        multiPartForm.append(imageData, withName: "file", fileName: "\(api.path).jpg", mimeType: "image/jpg")
                        print("imageData 크기 - \(imageData)")
                    }
                    
                    
                }, with: api, interceptor: AuthManager())
                .validate(statusCode: 200...300)
                .responseDecodable(of: ElementReadPostResponse.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("컨텐츠 상태 코드 ", status)
                    
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        print(error.localizedDescription)
                        if let commonError = CommonError(rawValue: status) {
                            print("CommonError - \(commonError)")
                            observer.onError(commonError)
                        }
                        
                        if let modifyError = ModifyError(rawValue: status) {
                            print("modifyError - \(modifyError)")
                            observer.onError(modifyError)
                        }
                }
            }
                return Disposables.create()
        }
    }
    
    /// 제네릭으로 구현중
    func requestAPIFunction<T: Decodable>(type: T.Type, api: Router, section: SectionAPI) -> Observable<T> {
        return Observable<T>.create { observer in
            AF.request(api, interceptor: AuthManager())
                .validate(statusCode: 200...300)
                .responseDecodable(of: T.self) { response in
                    guard let status = response.response?.statusCode else { return }
                    print("상태 코드 ", status)
//                    print("에러 상세 : \(response.description)")
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
//
                        if let err = NetworkAPIError.init(statusCode: status, message: ErrorMessage(status: status, section: section).description) {
                            observer.onError(err)
                        }
                        
                        
                    }
                }
            return Disposables.create()
        }
    }
 
    /// 프로필 수정하기
    func requestPutProfile(api: Router, imageData: Data?) -> Observable<PutProfileResponse> {
        return Observable.create { observer in
        
            AF.upload(multipartFormData: { multiPartForm in
                for (key, value) in api.query! {
                    multiPartForm.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
                }
                
                if let imageData {
                    multiPartForm.append(imageData, withName: "profile", fileName: "\(api.path).jpg", mimeType: "image/jpg")
                }
                
            }, with: api, interceptor: AuthManager())
            .validate(statusCode: 200...300)
            .responseDecodable(of: PutProfileResponse.self) { response in
                guard let status = response.response?.statusCode else { return }
                print("컨텐츠 상태 코드 ", status)
                print("** error.Description : \(response.debugDescription)")
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    if let commonError = CommonError(rawValue: status) {
                        print("CommonError - \(commonError)")
                        observer.onError(commonError)
                    }
                    
                    if let putProfileError = PutProfileError(rawValue: status) {
                        
                        print("contentError - \(putProfileError)")
                        observer.onError(putProfileError)
                    }
                }
                
            }
            return Disposables.create()
        }
    }
}
