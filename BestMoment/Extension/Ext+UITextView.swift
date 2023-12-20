//
//  Ext+UITextView.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/05.
//

import UIKit

extension UITextView {
    func textViewLayout() {
        
        self.text = "#해시태그 \n\n당신의 일상에서 가장 기억에 남는 순간을 기록해주세요."
        self.textColor = .lightGray
        self.font = UIFont.systemFont(ofSize: 15)
        self.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
}
