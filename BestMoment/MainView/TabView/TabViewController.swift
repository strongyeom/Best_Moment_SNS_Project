//
//  TabViewController.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/12/02.
//

import UIKit
import RxSwift

class TabViewController : UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        let home = MainViewController()
        home.tabBarItem.title = "홈"
        home.tabBarItem.image = UIImage(systemName: "house")
        let homeVC = UINavigationController(rootViewController: home)
        
        let follow = FollowingViewController()
        follow.tabBarItem.title = "팔로잉"
        follow.tabBarItem.image = UIImage(systemName: "person.2.fill")
        let followVC = UINavigationController(rootViewController: follow)
      
        let profile = ProfileViewController()
        profile.tabBarItem.title = "마이페이지"
        profile.tabBarItem.image = UIImage(systemName: "person.circle")
        profile.tabBarItem.image?.withTintColor(.red)
        let profileVC = UINavigationController(rootViewController: profile)
        
        let apperance = UITabBarAppearance()
        apperance.backgroundColor = UIColor(named: "brandColor")
        self.tabBar.tintColor = UIColor.white
        self.tabBar.isTranslucent = false // 불투명도
        self.tabBar.standardAppearance = apperance
        self.tabBar.scrollEdgeAppearance = apperance
        
        
        setViewControllers([homeVC, followVC, profileVC], animated: false)
    }
    
}
