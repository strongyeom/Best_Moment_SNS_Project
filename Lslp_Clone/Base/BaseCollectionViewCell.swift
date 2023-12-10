//
//  BaseCollectionViewCell.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/10.
//

import UIKit

class BaseCollectionViewCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
    
    func setConstraints() {
        
    }
}
