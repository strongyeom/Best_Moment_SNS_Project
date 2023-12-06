//
//  Ext+UILabel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/07.
//

import UIKit

extension UILabel {
    func aggregateStatusCount() {
        self.text = "0"
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    func aggregateStatus(text: String) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: 13, weight: .light)
    }
}
