//
//  EditView.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/13.
//

import UIKit
import Kingfisher

final class EditView : BaseView {
    
    private let postTitle = BaseLabel(text: "제목", fontSize: 22, weight: .semibold)
    private let postTitleTextField = SignInTextField(placeHolder: "제목을 수정해주세요.", brandColor: .lightGray, alignment: .left)
    private let profileImage = PostImage("person.circle.fill", color: .lightGray)
    private let nickname = BaseLabel(text: "닉네임", fontSize: 13, weight: .medium)
    let postImage = PostImage("person.circle.fill", color: .lightGray)
    private let guideText = BaseLabel(text: "사진을 클릭하여 이미지 변경", fontSize: 13, weight: .light)
    private let contentLabel = BaseLabel(text: "본문", fontSize: 22, weight: .semibold)
    private let contentTextView = BasicTextView()
    
    override func configure() {
        [postTitle, postTitleTextField, profileImage, nickname, postImage, guideText, contentLabel, contentTextView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        postTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        postTitle.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).inset(15)
        }
        
        postTitleTextField.snp.makeConstraints { make in
            make.leading.equalTo(postTitle.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.centerY.equalTo(postTitle)
            make.height.equalTo(40)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalTo(postTitle)
            make.top.equalTo(postTitle.snp.bottom).offset(15)
        }
        
        nickname.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.centerY.equalTo(profileImage)
        }
        
        postImage.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(self.postImage.snp.width)
        }
        
        guideText.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.bottom).offset(6)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(postTitle)
            make.top.equalTo(guideText.snp.bottom).offset(10)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func configureUI(data: ElementReadPostResponse?) {
        
        guard let data else { return }
        postTitleTextField.text = data.title
        nickname.text = data.creator.nick
        contentTextView.text = data.content
        
        cofigurePostImage(data: data)
    }
    
    // Data 형식의 이미지 변환하여 UIImage에 뿌려주기
    private func cofigurePostImage(data: ElementReadPostResponse) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let postUrl = URL(string: BaseAPI.baseUrl + (data.image.first ?? ""))
        self.postImage.kf.setImage(with: postUrl, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])

        // 여기에 프로필 데이터 넣으면 됨
        let profileUrl = URL(string: BaseAPI.baseUrl + (data.creator.profile ?? ""))
        self.profileImage.kf.setImage(with: profileUrl, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.clipsToBounds = true
            self.profileImage.layer.borderColor = UIColor.black.cgColor
            self.profileImage.layer.borderWidth = 1
        }
    }
}
