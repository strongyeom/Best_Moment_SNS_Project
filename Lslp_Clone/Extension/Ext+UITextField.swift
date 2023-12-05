//
//  Ext+UITextField.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

extension UITextField {
    func setCornerTextField(placeHolder: String, brandColor: UIColor, alignment: NSTextAlignment) {
        self.placeholder = placeHolder
        self.layer.cornerRadius = 16
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.borderColor = brandColor.cgColor
        self.layer.borderWidth = 1
        self.textAlignment = alignment
        self.autocapitalizationType = .none
        self.addLeftPadding()
    }
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
