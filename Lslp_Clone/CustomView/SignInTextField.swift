//
//  SignInTextField.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

class SignInTextField : UITextField {
    
    init(placeHolder: String, brandColor: UIColor) {
        super.init(frame: .zero)
        self.setCornerTextField(placeHolder: placeHolder, brandColor: brandColor)
    }
    
    init(placeHolder: String, isSecure: Bool, brandColor: UIColor) {
        super.init(frame: .zero)
        self.setCornerTextField(placeHolder: placeHolder, brandColor: brandColor)
        self.isSecureTextEntry = isSecure
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
