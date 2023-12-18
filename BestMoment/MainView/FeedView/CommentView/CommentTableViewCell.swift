//
//  CommentTableViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/27.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {
    
    let profileImage = PostImage("person.circle.fill", color: .lightGray)
    
    let nickname = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    let comment = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let exampleDate = UILabel()
    
    // menu 버튼 만들기
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [profileImage, nickname, comment].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.leading.top.equalToSuperview().inset(10)
        }
        
        nickname.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(6)
            make.top.equalTo(profileImage)
        }
        
        comment.snp.makeConstraints { make in
            make.leading.equalTo(nickname)
            make.top.equalTo(nickname.snp.bottom).offset(5)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(profileImage)
        }
    }
    
    func configureUI(data: CommentPostResponse) {
        
        nickname.text = data.creator.nick
        // 서버에 한글로 요청했을때 받아올때 한글 디코딩해서 갖고오기
        comment.text = data.content.removingPercentEncoding
        self.selectionStyle = .none
        exampleDate.text = data.time
        cofigurePostImage(data: data.creator.profile)
        
    }
    
    // Data 형식의 이미지 변환하여 UIImage에 뿌려주기
    func cofigurePostImage(data: String?) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        if let data {
            let url = URL(string: BaseAPI.baseUrl + data)
            self.profileImage.kf.setImage(with: url, options: [.requestModifier(imageDownloadRequest), .cacheOriginalImage])
        } else {
            self.profileImage.image = UIImage(systemName: "person.circle.fill")
        }
       
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImage.image = nil
        self.nickname.text = nil
        self.comment.text = nil
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
