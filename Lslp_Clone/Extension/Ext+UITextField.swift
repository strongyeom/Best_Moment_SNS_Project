//
//  Ext+UITextField.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

extension UITextField {
    func setCornerTextField(placeHolder: String, brandColor: UIColor) {
        self.placeholder = placeHolder
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.borderColor = brandColor.cgColor
        self.layer.borderWidth = 1
        self.textAlignment = .center
        self.autocapitalizationType = .none
    }
}
