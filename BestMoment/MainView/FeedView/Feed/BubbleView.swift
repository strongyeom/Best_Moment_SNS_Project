//
//  BubbleView.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/13.
//

import UIKit

class BubbleView : UIView {
    
    var postCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    
    let post = {
        let view = UILabel()
        view.aggregateStatus(text: "게시물")
        return view
    }()
    
    var followersCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    
    let followers = {
        let view = UILabel()
        view.aggregateStatus(text: "팔로워")
        return view
    }()
    
    var followingCount = {
        let view = UILabel()
        view.aggregateStatusCount()
        return view
    }()
    
    let following = {
        let view = UILabel()
        view.aggregateStatus(text: "팔로잉")
        return view
    }()
    
    
    lazy var postStackView = {
        let stack = UIStackView(arrangedSubviews: [postCount, post])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    lazy var followersStackView = {
        let stack = UIStackView(arrangedSubviews: [followersCount, followers])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    lazy var followingStackView = {
        let stack = UIStackView(arrangedSubviews: [followingCount, following])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    lazy var horizonTalStackView = {
        let stack = UIStackView(arrangedSubviews: [postStackView, followersStackView, followingStackView])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    init(
        viewColor: UIColor,
        tipStartX: CGFloat,
        tipWidth: CGFloat,
        tipHeight: CGFloat
    ) {
        super.init(frame: .zero)
        self.configure()
        
        self.backgroundColor = viewColor
        
        let path = CGMutablePath()
        
        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth
        
        path.move(to: CGPoint(x: tipStartX, y: 0))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: -tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = viewColor.cgColor
        
        self.layer.insertSublayer(shape, at: 0)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        self.isHidden = true
        self.addSubview(horizonTalStackView)
        horizonTalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
    
    func configureUI(data: GetAnotherProfileResponse) {
        self.postCount.text = "\(data.posts.count)"
        self.followersCount.text = "\(data.followers.count)"
        self.followingCount.text = "\(data.following.count)"
    }
}
