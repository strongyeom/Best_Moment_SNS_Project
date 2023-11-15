//
//  Ext+UITextField.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

extension UITextField {
    func setCornerTextField(placeHolder: String) {
        self.placeholder = placeHolder
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
        self.textAlignment = .center
    }
}
