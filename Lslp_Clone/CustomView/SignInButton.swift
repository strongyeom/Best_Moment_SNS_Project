//
//  SignInButton.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

class SignInButton : UIButton {
    init(text: String, brandColor: UIColor) {
        super.init(frame: .zero)
        self.setCornerButton(text: text, brandColor: brandColor)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
