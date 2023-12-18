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
        navigationBarSettingColor()
    }
    
    func configure() {
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        
    }
}

extension BaseViewController {
    
    func navigationBarSettingColor() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "brandColor")
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}
