//
//  ProfileViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/02.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileViewController : BaseViewController {
    
    lazy var profileImage = PostImage("person.fill", color: .blue)
    let nickname = BaseLabel(text: "닉네임 입니다.", fontSize: 13, weight: .medium)
    
    var postCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    
    let post = {
        let view = UILabel()
        view.aggregateStatus(text: "게시물")
        return view
    }()
    
    var followersCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    
    let followers = {
        let view = UILabel()
        view.aggregateStatus(text: "팔로워")
        return view
    }()
    
    var followingCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    
    let following = {
        let view = UILabel()
        view.aggregateStatus(text: "팔로잉")
        return view
    }()
    
    let profileEdit = {
        let btn = UIButton()
        btn.setCornerButton(text: "프로필 편집", brandColor: .lightGray)
        return btn
    }()
    
    let logOut = {
        let btn = UIButton()
        btn.setCornerButton(text: "로그아웃", brandColor: .lightGray)
        return btn
    }()
    
    
    // MARK: - StackView
    lazy var buttonStackView = {
        let stack = UIStackView(arrangedSubviews: [profileEdit, logOut])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    lazy var postStackView = {
        let stack = UIStackView(arrangedSubviews: [postCount, post])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    lazy var followersStackView = {
        let stack = UIStackView(arrangedSubviews: [followersCount, followers])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    lazy var followingStackView = {
        let stack = UIStackView(arrangedSubviews: [followingCount, following])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    lazy var horizonTalStackView = {
        let stack = UIStackView(arrangedSubviews: [postStackView, followersStackView, followingStackView])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    // MARK: - Subject And Properties
    var selectedImageData = PublishSubject<Data>()
    var tabman = TabManViewController()
    let disposeBag = DisposeBag()
    var imageData: String?
    var myNickname: String?
    let firstVC = MyPostViewController()
    let secondVC = MyFavoritePostViewController()
    let tabManVC = TabManViewController()
    
    
    var containerView: UIView!
    
    
    override func configure() {
        super.configure()
        navigationItem.title = "마이페이지"
        print("ProfileViewController - configure")
        [profileImage, nickname, buttonStackView, horizonTalStackView].forEach {
            view.addSubview($0)
        }
        
        containerView = UIView()
        view.addSubview(containerView)
        containerView.addSubview(tabManVC.view)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ProfileViewController - viewWillAppear")
        bind()
    }

    func bind() {
        
        APIManager.shared.requestAPIFunction(type: GetProfileResponse.self, api: Router.getProfile(accessToken: UserDefaultsManager.shared.accessToken), section: .getProfile)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("🙏🏻 프로필 조회 에러 - \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self, onNext: { owner, response in
                owner.nickname.text = response.nick
                owner.postCount.text = "\(response.posts.count)"
                owner.followersCount.text = "\(response.followers.count)"
                owner.followingCount.text = "\(response.following.count)"
                owner.myNickname = response.nick
                print("** response.profile : \(response.profile)")
                owner.profileImageConfigure(imageUrl: response.profile)
                
                
            })
            .disposed(by: disposeBag)

        
        profileEdit.rx.tap
            .bind(with: self) { owner, _ in
                let profileEditView = ProfileEditView()
                let nav = UINavigationController(rootViewController: profileEditView)
                profileEditView.nickname = owner.myNickname
                nav.modalPresentationStyle = .fullScreen
                owner.present(nav, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        logOut.rx.tap
            .bind(with: self) { owner, _ in
                owner.logOutAlert {
                    // 로그인 화면으로 이동
                    UserDefaultsManager.shared.backToRoot(isRoot: false)
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                     windowScene?.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func profileImageConfigure(imageUrl: String) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let url = URL(string: BaseAPI.baseUrl + imageUrl)
        self.profileImage.kf.setImage(with: url, options: [.requestModifier(imageDownloadRequest), .cacheOriginalImage])
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(70)
        }
        
        horizonTalStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            
        }
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(5)
            make.leading.equalTo(profileImage)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
//
        containerView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)

        }
        
        
    }
}


