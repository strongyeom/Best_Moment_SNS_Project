//
//  PostEditViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/01.
//

import UIKit


class PostEditViewController : BaseViewController {
    
    var editPost: ElementReadPostResponse?
    
    override func configure() {
        super.configure()
        print("PostEditViewController - configure")
        dump(editPost)
       
    }
    
    override func setConstraints() {
        
    }
}
