//
//  MainTableViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/22.
//

import UIKit
import RxSwift

final class MainTableViewCell : UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    var disposeBag = DisposeBag()
    
    let routinTitle = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
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
        return view
    }()
    
    let likeCountLabel = {
       let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [routinTitle, nickname, releaseDate, routinDescription, likeBtn, likeCountLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        routinTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(10)
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
        
        likeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(likeBtn.snp.bottom).offset(10)
            make.leading.equalTo(routinTitle)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(10).priority(.low)
        }
    }
    
    func configureUI(data: ElementReadPostResponse) {
        
        routinTitle.text = data.title
        nickname.text = data.creator.nick
        releaseDate.text = data.time
        routinDescription.text = data.content
        likeCountLabel.text = data.product_id
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
