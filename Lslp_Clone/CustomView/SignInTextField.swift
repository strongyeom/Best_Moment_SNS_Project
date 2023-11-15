//
//  SignInTextField.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

class SignInTextField : UITextField {
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        self.setCornerTextField(placeHolder: placeHolder)
    }
    
    init(placeHolder: String, isSecure: Bool) {
        super.init(frame: .zero)
        self.setCornerTextField(placeHolder: placeHolder)
        self.isSecureTextEntry = isSecure
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
