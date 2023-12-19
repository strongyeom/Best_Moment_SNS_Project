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
    
    lazy var profileImage = PostImage("person.fill", color: .lightGray)
    let nickname = BaseLabel(text: "", fontSize: 23, weight: .medium)
    private var postCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    private let post = {
        let view = UILabel()
        view.aggregateStatus(text: "게시물")
        return view
    }()
    private var followersCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    private let followers = {
        let view = UILabel()
        view.aggregateStatus(text: "팔로워")
        return view
    }()
    private var followingCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    private let following = {
        let view = UILabel()
        view.aggregateStatus(text: "팔로잉")
        return view
    }()
    private let profileEdit = {
        let btn = UIButton()
        btn.profileButton(text: "프로필 편집", brandColor: .systemGreen)
        return btn
    }()

    
    
    // MARK: - StackView
    
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
    private let disposeBag = DisposeBag()
    private var myNickname: String?
    let firstVC = MyPostViewController()
    let secondVC = MyFavoritePostViewController()
    let tabManVC = TabManViewController()
    
    
    private var containerView: UIView!
    
    
    override func configure() {
        super.configure()
        navigationItem.title = "마이페이지"
        print("ProfileViewController - configure")
        [profileImage, nickname, profileEdit, horizonTalStackView].forEach {
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
    
    fileprivate func bind() {
        
        APIManager.shared.requestAPIFunction(type: GetProfileResponse.self, api: Router.getProfile(accessToken: UserDefaultsManager.shared.accessToken), section: .getProfile)
            .catch { err in
                if let err = err as? NetworkAPIError {
                    print("🙏🏻 프로필 조회 에러 - \(err.description)")
                }
                return Observable.never()
            }
            .bind(with: self, onNext: { owner, response in
                print("ProfileVC - \(response)")
                owner.nickname.text = response.nick
                owner.postCount.text = "\(response.posts.count)"
                owner.followersCount.text = "\(response.followers.count)"
                owner.followingCount.text = "\(response.following.count)"
                owner.myNickname = response.nick
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
        
    }
    
    
    fileprivate func profileImageConfigure(imageUrl: String?) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        DispatchQueue.main.async {
            
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.clipsToBounds = true
            self.profileImage.layer.borderColor = UIColor.black.cgColor
            self.profileImage.layer.borderWidth = 1
            
            
            if let imageUrl {
                let url = URL(string: BaseAPI.baseUrl + imageUrl)
                self.profileImage.kf.setImage(with: url, options: [.requestModifier(imageDownloadRequest), .cacheOriginalImage])
            } else {
                self.profileImage.image = UIImage(systemName: "person.circle.fill")
            }
        }
        
      
        
        
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
            make.leading.equalTo(profileImage).offset(5)
        }
        
        profileEdit.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(nickname.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
//        buttonStackView.snp.makeConstraints { make in
//            make.top.equalTo(nickname.snp.bottom).offset(10)
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
//            make.height.equalTo(40)
//        }
//
        //
        containerView.snp.makeConstraints { make in
            make.top.equalTo(profileEdit.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
        
        
    }
}


