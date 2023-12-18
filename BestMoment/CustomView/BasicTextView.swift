//
//  BasicTestView.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/06.
//

import UIKit

class BasicTextView: UITextView {
   
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: nil)
        self.textViewLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
