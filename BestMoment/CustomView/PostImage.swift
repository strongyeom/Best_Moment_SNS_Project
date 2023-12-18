//
//  PostImage.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/01.
//

import UIKit

class PostImage: UIImageView {
   
    init(_ basicImage: String?, color: UIColor?) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.image = basicImage == nil ? UIImage(named: "EmptyImage") : UIImage(systemName: basicImage!)
        self.tintColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
