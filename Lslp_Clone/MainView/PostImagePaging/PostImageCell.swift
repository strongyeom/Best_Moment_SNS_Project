//
//  PostImageCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/01.
//

import UIKit

class PostImageCell : UICollectionViewCell {
    
    static let identifier = "PostImageCell"
    
    let postImage = {
       let image = UIImageView()
        image.backgroundColor = .yellow
        return image
    }()
    
    let pageControl = UIPageControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(postImage)
        postImage.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
              
    }
    
    @objc func pageChanged() {
        print("PostImageCell - pageChanged")
    }
    
    private func setContstraints() {
        
        postImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    func configureUI(data: UIImage?) {
       
    }
}
