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
   
    var disposeBag = DisposeBag()
    var deleteCompletion: (() -> Void)?
    var editCompletion: (() -> Void)?
    var profileCompletion: (() -> Void)?
    
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
       
        let edit = UIAction(title: "편집", handler: { _ in
            self.editCompletion?()
            print("편집")
        })
        let cancel = UIAction(title: "삭제", attributes: .destructive, handler: { _ in
            self.deleteCompletion?()
            print("취소")
        })
        let buttonMenu = UIMenu(title: "", children: [edit, cancel])
        button.menu = buttonMenu
        return button
    }()

    let followerBtn = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.attributedTitle = AttributedString("팔로우", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .medium)]))
        config.baseForegroundColor = .systemBlue
        button.configuration = config
        return button
    }()

    let profileImage = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        return image
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
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()
    
    lazy var tapGesture = {
        let tapGesutre = UITapGestureRecognizer(target: self, action: #selector(profileImagaTapped))
        return tapGesutre
    }()
    
    
    let bubbleView = BubbleView(viewColor: .systemGray5,
                                tipStartX: 70.5,
                                tipWidth: 11.0,
                                tipHeight: 6.0)
   
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
        [routinTitle, nickname, releaseDate, routinDescription, likeBtn, likeCountLabel, postCommentBtn, commentCountLabel, postImage, profileImage, pullDownButton, followerBtn].forEach {
            contentView.addSubview($0)
        }

        profileImage.addGestureRecognizer(tapGesture)
        contentView.addSubview(bubbleView)
    }
    
    @objc func profileImagaTapped() {
        profileCompletion?()
        
        
        // Image 클릭시 bubbleView 보여주기
        self.bubbleView.isHidden.toggle()
        
//        if  self.bubbleView.isHidden == true {
//            self.bubbleView.isHidden = false
//        } else {
//            self.bubbleView.isHidden = true
//        }
        
        print("프로필 이미지 눌림")
    }
    
    private func setConstraints() {
        
        routinTitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
        routinTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
        }
        
        followerBtn.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        followerBtn.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        followerBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nickname)
            make.leading.equalTo(nickname.snp.trailing).offset(10)
        }
        
        // setContentHuggingPriority : 뷰가 고유 크기보다 커지는 것을 방지하는 우선 순위를 설정
        pullDownButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        // setContentCompressionResistancePriority : 뷰가 고유 크기보다 작게 만들어지지 않도록 하는 우선 순위를 설정
        pullDownButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        pullDownButton.snp.makeConstraints { make in
            make.leading.equalTo(followerBtn.snp.trailing).offset(10)
            make.centerY.equalTo(nickname)
            make.trailing.equalToSuperview().inset(10)
        }
        

        profileImage.snp.makeConstraints { make in
            make.top.equalTo(routinTitle.snp.bottom).offset(5)
            make.leading.equalTo(routinTitle)
            make.size.equalTo(50)
        }
        
        nickname.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            
        }
  
        postImage.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(self.postImage.snp.width)
        }
        
        routinDescription.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        routinDescription.snp.makeConstraints { make in
            make.top.equalTo(postImage.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(likeBtn.snp.top).offset(10).priority(.low)
        }
        
        likeBtn.snp.makeConstraints { make in
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
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureUI(data: ElementReadPostResponse, followings: [String]) {
        
        routinTitle.text = "제목 : \(data.title)"
        nickname.text = data.creator.nick
        releaseDate.text = data.time

        if followings.contains(data.creator._id) {
            self.followerBtn.configurationUpdateHandler = { button in
                button.configuration = self.followOption(text: "팔로잉")
            }
        } else {
            self.followerBtn.configurationUpdateHandler = { button in
                button.configuration = self.followOption(text: "팔로우")
            }
        }
        

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
    
    func bubbleChatData(data: GetAnotherProfileResponse) {
        bubbleView.configureUI(data: data)
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

        // 여기에 프로필 데이터 넣으면 됨
        let profileUrl = URL(string: BaseAPI.baseUrl + (data.creator.profile ?? ""))
        self.profileImage.kf.setImage(with: profileUrl, options: [ .requestModifier(imageDownloadRequest), .cacheOriginalImage])
        
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
        likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
            self.profileImage.layer.borderColor = UIColor.black.cgColor
            self.profileImage.layer.borderWidth = 1
            self.profileImage.clipsToBounds = true
        }
    }
    
    func followOption(text: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.tinted()
        config.attributedTitle = AttributedString(text, attributes: AttributeContainer([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .medium)]))
        config.baseForegroundColor = .systemBlue
        return config
    }
    
}
