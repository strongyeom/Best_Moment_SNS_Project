//
//  TabViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/02.
//

import UIKit

class TabViewController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let home = HomeViewController()
        home.tabBarItem.title = "홈"
        home.tabBarItem.image = UIImage(systemName: "house")
        let homeVC = UINavigationController(rootViewController: home)
        
        let add = PostAddViewController()
        add.tabBarItem.image = UIImage(systemName: "plus")
        let addVC = UINavigationController(rootViewController: add)
        
        
        
        let profile = ProfileViewController()
        profile.tabBarItem.title = "나의 시장"
        profile.tabBarItem.image = UIImage(systemName: "person.circle")
        let profileVC = UINavigationController(rootViewController: profile)
        
        let apperance = UITabBarAppearance()
        apperance.backgroundColor = .white
        self.tabBar.tintColor = UIColor.systemBlue
        self.tabBar.isTranslucent = false // 불투명도
        self.tabBar.standardAppearance = apperance
        self.tabBar.scrollEdgeAppearance = apperance
        
        setViewControllers([homeVC, addVC, profileVC], animated: false)
    }
}
