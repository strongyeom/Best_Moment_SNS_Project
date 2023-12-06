//
//  ProfileView.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/07.
//

import UIKit

class ProfileView : BaseView {
    
    let profileImage = PostImage("person.fill", color: .blue)
    let nickname = {
       let view = UILabel()
        view.text = "닉네임 입니다."
        view.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return view
    }()
    
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
    
    let profileShare = {
       let btn = UIButton()
        btn.setCornerButton(text: "프로필 공유", brandColor: .lightGray)
        return btn
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [profileEdit, profileShare])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [profileImage, nickname, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(70)
        }
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(5)
            make.leading.equalTo(profileImage)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.clipsToBounds = true
        }
    }
}
