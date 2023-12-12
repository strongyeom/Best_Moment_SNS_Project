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
        
        let like = LikeCollectionViewController()
        like.tabBarItem.title = "좋아요"
        like.tabBarItem.image = UIImage(systemName: "heart")
        let likeVC = UINavigationController(rootViewController: like)
      
        let profile = ProfileViewController()
        profile.tabBarItem.title = "마이페이지"
        profile.tabBarItem.image = UIImage(systemName: "person.circle")
        let profileVC = UINavigationController(rootViewController: profile)
        
        let apperance = UITabBarAppearance()
        apperance.backgroundColor = .white
        self.tabBar.tintColor = UIColor.systemBlue
        self.tabBar.isTranslucent = false // 불투명도
        self.tabBar.standardAppearance = apperance
        self.tabBar.scrollEdgeAppearance = apperance
        
        setViewControllers([homeVC, followVC, likeVC, profileVC], animated: false)
    }
    
}
