//
//  MainTableViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import UIKit
import RxSwift
import Kingfisher

final class MainTableViewCell : UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    var disposeBag = DisposeBag()
    
    let routinTitle = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.numberOfLines = 2
        view.textAlignment = .left
        return view
    }()
    
    let cancelBtn = {
       let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    
    let nickname = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        view.textColor = .lightGray
        view.textAlignment = .left
        return view
    }()
    
    let releaseDate = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        view.textColor = .lightGray
        view.textAlignment = .left
        return view
    }()
    
    let routinDescription = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 13)
        view.numberOfLines = 2
        view.textAlignment = .left
        return view
    }()
    
    let likeBtn = {
       let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .red
        return view
    }()
    
    let postCommentBtn = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "message"), for: .normal)
        return button
    }()
    
    let likeCountLabel = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    let commentCountLabel = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    let postImage = {
       let view = UIImageView()
        view.backgroundColor = .yellow
        return view
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [routinTitle, cancelBtn, nickname, releaseDate, routinDescription, likeBtn, likeCountLabel, postCommentBtn, commentCountLabel, postImage].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        routinTitle.setContentHuggingPriority(.defaultLow, for: .horizontal)
        routinTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
       
        cancelBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        cancelBtn.snp.makeConstraints { make in
            make.leading.equalTo(routinTitle.snp.trailing).offset(10)
            make.centerY.equalTo(routinTitle)
            make.trailing.equalToSuperview().inset(10)
        }
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(routinTitle.snp.bottom).offset(5)
            make.leading.equalTo(routinTitle)
        }
        
        releaseDate.snp.makeConstraints { make in
            make.top.equalTo(routinTitle.snp.bottom).offset(5)
            make.leading.equalTo(nickname.snp.trailing).offset(10)
            
        }
        
        routinDescription.snp.makeConstraints { make in
            make.top.equalTo(releaseDate.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(routinTitle)
        }
        
        likeBtn.snp.makeConstraints { make in
            //make.size.equalTo(40)
            make.top.equalTo(routinDescription.snp.bottom).offset(10)
            make.leading.equalTo(routinTitle)
        }
        
        postCommentBtn.snp.makeConstraints { make in
            make.centerY.size.equalTo(likeBtn)
            make.leading.equalTo(likeBtn.snp.trailing).offset(10)
        }
        
        postImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
//            make.leading.equalTo(postCommentBtn.snp.trailing).offset(10)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeBtn.snp.bottom).offset(10)
            make.leading.equalTo(routinTitle)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10).priority(.low)
        }
        
        commentCountLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(likeCountLabel)
            make.leading.equalTo(likeCountLabel.snp.trailing).offset(20)
        }
    }
    
    func configureUI(data: ElementReadPostResponse) {
        
        routinTitle.text = data.title
        nickname.text = data.creator.nick
        releaseDate.text = data.time
        routinDescription.text = data.content
        
        let image = data.likes.contains(UserDefaultsManager.shared.loadUserID()) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        likeBtn.setImage(image, for: .normal)
        likeCountLabel.text = "좋아요 : \(data.likes.count)"
        commentCountLabel.text = "댓글 갯수 : \(data.comments.count)"
        
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let url = URL(string: BaseAPI.baseUrl + "\(data.image.first ?? "")")
        self.postImage.kf.setImage(with: url, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage]) { response in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        routinTitle.text = nil
        nickname.text = nil
        releaseDate.text = nil
        routinDescription.text = nil
        likeCountLabel.text = nil
        commentCountLabel.text = nil
        postImage.image = nil
    }
    
}
