//
//  LikeCollectionViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/06.
//

import UIKit
import RxSwift
import Kingfisher

final class MyPostCell: BaseCollectionViewCell {
    
    enum Section {
        case post
        case favorite
    }
    
    private var disposeBag = DisposeBag()
    private let postImage = PostImage(nil, color: .yellow)
    private let likeBtn = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .red
        return view
    }()
    
    override func configure() {
        [postImage, likeBtn].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        postImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(10)
        }
    }
 
    func configureUI(data: ElementReadPostResponse, isHidden: Section) {
        
        
        switch isHidden {
        case .post:
            likeBtn.isHidden = true
        case .favorite:
            likeBtn.isHidden = false
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        cofigurePostImage(data: data.image.first ?? "")
    }
    
    // Data 형식의 이미지 변환하여 UIImage에 뿌려주기
    fileprivate func cofigurePostImage(data: String) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let url = URL(string: BaseAPI.baseUrl + data)
        self.postImage.kf.setImage(with: url, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = nil        
        disposeBag = DisposeBag()
        
    }
}
