//
//  CommentTableViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/27.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    let nickname = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .green
        return label
    }()
    
    let comment = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .yellow
        return label
    }()
    
    let exampleDate = UILabel()
    
    // menu 버튼 만들기
    
    static let identifier = "CommentTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [nickname, comment, exampleDate].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        nickname.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        comment.snp.makeConstraints { make in
            make.top.equalTo(nickname.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(nickname)
//            make.bottom.equalToSuperview().inset(10)
        }
        
        exampleDate.snp.makeConstraints { make in
            make.top.equalTo(comment.snp.bottom).offset(5)
            make.leading.equalTo(comment)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configureUI(data: CommentPostResponse) {
        nickname.text = data.creator.nick
        comment.text = data.content
        self.selectionStyle = .none
        exampleDate.text = data.time
    }
}
