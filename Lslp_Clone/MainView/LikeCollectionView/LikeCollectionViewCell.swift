//
//  LikeCollectionViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/06.
//

import UIKit
import RxSwift
import Kingfisher

class LikeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LikeCollectionViewCell"
    
    var disposeBag = DisposeBag()
    let postImage = PostImage()
    
    let nickname = {
       let view = UILabel()
        view.text = "닉네임입니다."
        return view
    }()
    
    lazy var profileImage = {
       let view = UIImageView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let likeBtn = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        [nickname, profileImage, likeBtn].forEach {
            postImage.addSubview($0)
        }
        
        contentView.addSubview(postImage)
    }
    
    private func setConstraints() {
        postImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.size.equalTo(60)
        }
        
        nickname.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        likeBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    
    func configureUI(data: ElementReadPostResponse) {
       
        self.nickname.text = data.creator.nick
        
        let image = data.likes.contains(UserDefaultsManager.shared.loadUserID()) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeBtn.setImage(image, for: .normal)
        
        cofigurePostImage(data: data.image.first ?? "")
    }
    
    // Data 형식의 이미지 변환하여 UIImage에 뿌려주기
    func cofigurePostImage(data: String) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let url = URL(string: BaseAPI.baseUrl + data)
        self.postImage.kf.setImage(with: url, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
            self.profileImage.clipsToBounds = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil
        profileImage.image = nil
        nickname.text = nil
        
        disposeBag = DisposeBag()
      
    }
}
