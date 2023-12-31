//
//  FollowingCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/12.
//
import UIKit
import RxSwift
import Kingfisher

final class FollowingCell : UITableViewCell {
   
    var disposeBag = DisposeBag()
    var unfollowCompletion: (() -> Void)?
    let routinTitle = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.numberOfLines = 2
        view.textAlignment = .left
        return view
    }()
    
    lazy var pullDownButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.tintColor = .black
        let unFollow = UIAction(title: "팔로우 취소", attributes: .destructive) { _ in
            self.unfollowCompletion?()
            print("팔로우 취소")
        }
        
        let buttonMenu = UIMenu(title: "", children: [unFollow])
        button.menu = buttonMenu
        
        return button
    }()
   
    let profileImage = PostImage("person.circle.fill", color: .lightGray)

    let nickname = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textColor = .black
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
        view.numberOfLines = 0
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
        view.textColor = .systemGray
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    let postImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
        [routinTitle, nickname, releaseDate, routinDescription, likeBtn, likeCountLabel, postCommentBtn, commentCountLabel, postImage, profileImage, pullDownButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {

        routinTitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
        routinTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
       
        
        // setContentHuggingPriority : 뷰가 고유 크기보다 커지는 것을 방지하는 우선 순위를 설정
        pullDownButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        // setContentCompressionResistancePriority : 뷰가 고유 크기보다 작제 만들어지지 않도록 하는 우선 순위를 설정
        pullDownButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        pullDownButton.snp.makeConstraints { make in
            make.leading.equalTo(nickname.snp.trailing).offset(10)
            make.centerY.equalTo(nickname)
            make.trailing.equalToSuperview().inset(10)
        }
        
        
        
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(routinTitle.snp.bottom).offset(5)
            make.leading.equalTo(routinTitle)
            make.size.equalTo(50)
        }
        
        nickname.setContentHuggingPriority(.defaultLow, for: .horizontal)

        nickname.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
//            make.trailing.equalToSuperview().inset(10)
        }
  
        postImage.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.postImage.snp.width).multipliedBy(0.7)
        }
        
        routinDescription.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        routinDescription.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(likeBtn.snp.top).offset(10).priority(.low)
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
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeBtn.snp.bottom).offset(10)
            make.leading.equalTo(routinTitle)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10).priority(.low)
        }
        
        commentCountLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        commentCountLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        commentCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeCountLabel.snp.bottom).offset(5)
            make.leading.equalTo(likeCountLabel)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureUI(data: ElementReadPostResponse) {
        
        nickname.text = data.creator.nick
        releaseDate.text = data.time
        
        let image = data.likes.contains(UserDefaultsManager.shared.loadUserID()) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeBtn.setImage(image, for: .normal)
        
        routinDescription.text = data.content
        
        if data.likes.count > 0 {
            likeCountLabel.text = "좋아요 \(data.likes.count)개"
        }
        
        if data.comments.count > 0 {
            commentCountLabel.text = "댓글 \(data.comments.count)개 모두 보기"
        }
        
        cofigurePostImage(data: data)
        
        
    }
   
    // Data 형식의 이미지 변환하여 UIImage에 뿌려주기
    func cofigurePostImage(data: ElementReadPostResponse) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(APIKey.secretKey, forHTTPHeaderField: "SesacKey")
            requestBody.setValue(UserDefaultsManager.shared.accessToken, forHTTPHeaderField: "Authorization")
            return requestBody
        }
        
        let postUrl = URL(string: BaseAPI.baseUrl + (data.image.first ?? ""))
        self.postImage.kf.setImage(with: postUrl, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])

        if let profileImageUrl = data.creator.profile {
            // 여기에 프로필 데이터 넣으면 됨
            let profileUrl = URL(string: BaseAPI.baseUrl + profileImageUrl)
            self.profileImage.kf.setImage(with: profileUrl, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
        } else {
            self.profileImage.image = UIImage(systemName: "person.circle.fill")
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderColor = UIColor.black.cgColor
        self.profileImage.layer.borderWidth = 1
        self.profileImage.clipsToBounds = true
    }
    
}
