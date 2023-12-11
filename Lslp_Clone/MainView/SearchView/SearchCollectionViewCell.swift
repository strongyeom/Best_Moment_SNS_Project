//
//  SearchCollectionViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import UIKit
import Kingfisher
import RxSwift

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let thumbnail = {
       let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let thumbnailDescription = {
        let view = UILabel()
        // custom font를 적용
        view.text = "썸네일 글자"
        view.textAlignment = .center
        view.numberOfLines = 3
        return view
    }()
    
    lazy var followerBtn = {
        let button = UIButton()
        button.configuration = followOption(text: "팔로우")
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var exampleButton = {
       exampleOption(text: "팔로우")
    }()

   
    var disposeBag = DisposeBag()
    
    override func configure() {
        contentView.addSubview(thumbnail)
        [thumbnailDescription, followerBtn].forEach {
            thumbnail.addSubview($0)
        }
    }
    
    override func setConstraints() {
        thumbnail.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbnailDescription.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
        }
        
        followerBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
    
    func configureUI(data: ElementReadPostResponse, followingUsers: Set<String>) {
        
        if followingUsers.contains(data.creator._id) {
            self.followerBtn.configurationUpdateHandler = { button in
                button.configuration = self.followOption(text: "팔로잉")
            }
        } else {
            self.followerBtn.configurationUpdateHandler = { button in
                button.configuration = self.followOption(text: "팔로우")
            }
        }
  
        self.thumbnailDescription.text = data.title
        cofigurePostImage(data: data.image.first ?? "")
    }
    
    func cofigurePostImage(data: String) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let url = URL(string: BaseAPI.baseUrl + data)
        self.thumbnail.kf.setImage(with: url, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnail.image = nil
        self.thumbnailDescription.text = nil
        disposeBag = DisposeBag()
    }
    
    func followOption(text: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.bordered()
        config.attributedTitle = AttributedString(text, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .medium)]))
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .lightGray
        return config
    }
    
    func exampleOption(text: String) -> UIButton {
        let button = UIButton()
         button.setTitle("팔로우", for: .normal)
         button.backgroundColor = .lightGray
         button.layer.cornerRadius = 12
         button.layer.cornerCurve = .continuous
         button.clipsToBounds = true
         return button
    }
 
}
