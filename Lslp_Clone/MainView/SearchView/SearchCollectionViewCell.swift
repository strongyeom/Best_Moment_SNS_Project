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
    
    var disposeBag = DisposeBag()
    
    override func configure() {
        contentView.addSubview(thumbnail)
        thumbnail.addSubview(thumbnailDescription)
    }
    
    override func setConstraints() {
        thumbnail.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbnailDescription.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureUI(data: ElementReadPostResponse) {
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
    
}
