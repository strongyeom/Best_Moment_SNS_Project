//
//  Ext+UITextView.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/05.
//

import UIKit

extension UITextView {
    func textViewLayout() {
        
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 12
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 15)
        self.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}
