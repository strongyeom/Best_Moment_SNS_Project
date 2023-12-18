//
//  BaseViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import UIKit

class BaseViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        
    }
}
