//
//  LikeCollectionViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/06.
//

import UIKit

class LikeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LikeCollectionViewCell"
    
    let postImage = PostImage()
    
    let nickname = {
       let view = UILabel()
        view.text = "닉네임입니다."
        return view
    }()
    
    let profileImage = {
       let view = UIImageView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let likeBtn = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
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
    
    func configure() {
        
        [nickname, profileImage, likeBtn].forEach {
            postImage.addSubview($0)
        }
        
        contentView.addSubview(postImage)
    }
    
    func setConstraints() {
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
    
    // View의 레이아웃을 즉시 업데이트
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        profileImage.clipsToBounds = true
    }
   
    
}
