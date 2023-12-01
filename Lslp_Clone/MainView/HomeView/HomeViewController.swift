//
//  HomeViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/02.
//

import UIKit

class HomeViewController: BaseViewController {
    
    enum Section: String {
        case kind
        case popular
    }
    
    
    
    override func configure() {
        super.configure()
        view.backgroundColor = .yellow
        title = "무엇이든 물어보살"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
