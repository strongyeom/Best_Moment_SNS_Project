//
//  Ext+UIButton.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/15.
//

import UIKit

extension UIButton {
    func setCornerButton(text: String, brandColor: UIColor) {
        self.setTitle(text, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.borderColor = brandColor.cgColor
        self.layer.borderWidth = 1
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = brandColor
    }
    
    func profileButton(text: String, brandColor: UIColor) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(brandColor, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.layer.borderColor = brandColor.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .clear
    }

}
