//
//  PostImage.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/01.
//

import UIKit

class PostImage: UIImageView {
   
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.image = UIImage(named: "EmptyImage")
        self.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
