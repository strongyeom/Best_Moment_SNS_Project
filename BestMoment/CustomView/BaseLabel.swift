//
//  BaseLabel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/12.
//

import UIKit

class BaseLabel: UILabel {
    
    init(text: String, fontSize: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
