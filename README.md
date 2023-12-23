# Best Moment 
#### 최고의 순간을 포착하고 공유하는 SNS 앱
![bestMoment 피그마 작업](https://github.com/strongyeom/Best_Moment_SNS_Project/assets/101084872/a2717728-519f-4317-bc57-cfe8fc2542be)

# 개발 기간 및 인원
- 2023.11.09 ~ 2023.12.17
- 지속적 업데이트 중
- 최소 버전: iOS 16.0
- 1인 개발

# 사용 기술
- **UIKit, CodeBaseUI, MVVM, RxSwift, PhotosUI, SnapKit**
- **Alamofire, Kingfisher, Tabman**
------



 
# 기능 구현 
- `JWT 토큰` 활용 로그인 및 인증 구현
  - Access Token 만료시 Refresh토큰을 활요한 Access Token 갱신
- `Rxswift`을 이용한 이미지 기반 CRUD
  - `MVVM`과 `input output`패턴을 활용한 단방향 데이터 흐름을 통한 상태관리
  - 게시글 포스팅 및 편집, 댓글, 좋아요 기능 구현 
- 데이터 누락 및 중복 방지를 위한 `Cursor - based Paginantion`
- Swift 성능 최적화를 위한 `WMO`, `Access Control` 적용 
- 서버 데이터 값에 대한 가변성 대응으로  `Key DecodingStrategy: init(from decoder: Decoder)` 적용

------





# Trouble Shooting
### A. NetWork Error 발생시 Observable Stream 유지 방법

Network에서 Error 발생시 Stream 끊어지는 문제가 발생하여 Error Handling이 필요했습니다.
문제 해결을 위해 Operator인 catch와 never()를 활용하여 Error 발생시 Stream 끊이지 않게 해결했습니다.

```swift
APIManager.shared.requestAPIFunction(type: ReadPostResponse.self, api: Router.readPost(accessToken: UserDefaultsManager.shared.accessToken, next: next, limit: limit, product_id: "yeom"), section: .getPost)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("CustomError : \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self) { owner, response in
                
                owner.nextCursor = response.next_cursor
                print("nextCursor - \(self.nextCursor)")
                owner.routinArray.append(contentsOf: response.data)
                owner.routins.onNext(owner.routinArray)
            }
            .disposed(by: disposeBag)
```

### B. 토큰 유효성에 따른 화면 분기 처리
Access Token과 refresh Token을 활용한 로그인 로직 구현시 Access Token 만료시 Refresh Token을 통한 Access Token을 갱신을 했지만,
Refresh Token이 만료되었을때 재로그인을 통한 갱신 필요했습니다. 해결 방법으로는 ALamofire의 intercepter를 활용하여 갱신 로직을 구현했습니다.

```swift
class AuthManager: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // UserDefaults에 저장된 토큰
        let accessToken = UserDefaultsManager.shared.accessToken
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 419
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        
        AF.request(
            Router.refresh(
                access: UserDefaultsManager.shared.accessToken,
                refresh: UserDefaultsManager.shared.refreshToken
            )
        )
        .responseDecodable(of: RefreshResponse.self) { result in
            guard let status = result.response?.statusCode else { return }
            switch result.result {
            case .success(let data):
                UserDefaultsManager.shared.saveAccessToken(accessToken: data.token)
                completion(.retry)
            case .failure(let error):
                UserDefaultsManager.shared.backToRoot(isRoot: false)
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                 windowScene?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
                if let refreshError = RefreshError(rawValue: status) {
                    completion(.doNotRetryWithError(refreshError))
                     }
                }
                
            }
        }
    }
```


### 회고
- RxSwift와 MVVM을 적용하여 만든 첫 프로젝트였기에 반응형 프로그래밍에 대한 이해와 플로우를 배울 수 있었습니다. 기능과 역할에 따라 코드 분리를 하니 MVC 패턴보다 가독성과 유지보수 측면이 향상되는 것을 느꼈고,
또한 RxSwift 라이브러리를 사용함에 있어 상황에 맞는 Operator를 사용할 줄 아는 것도 중요하지만 Observable과 Observer, Stream, dispose에 따른 상태관리 측면이 반응형 프로그래밍을 이해하는데 더 중요하다고 느꼈습니다.

