//
//  ViewController.swift
//  My Reform
//
//  Created by 박현준 on 2023/01/06.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: MessageViewController())
        let vc4 = UINavigationController(rootViewController: ProfileViewController())
        
        
        
        vc1.tabBarItem.image = UIImage(named: "home")?.resize(newWidth: 20)
        vc2.tabBarItem.image = UIImage(named: "search")?.resize(newWidth: 25)
        vc3.tabBarItem.image = UIImage(named: "chat")?.resize(newWidth: 21)
        vc4.tabBarItem.image = UIImage(named: "profile")?.resize(newWidth: 25)
        
        vc1.tabBarItem.selectedImage = UIImage(named: "home_fill")?.resize(newWidth: 25)
        vc2.tabBarItem.selectedImage = UIImage(named: "search_fill")?.resize(newWidth: 26)
        vc3.tabBarItem.selectedImage = UIImage(named: "chat_fill")?.resize(newWidth: 21)
        vc4.tabBarItem.selectedImage = UIImage(named: "profile_fill")?.resize(newWidth: 25)
        
        vc1.title = "홈"
        vc2.title = "검색"
        vc3.title = "채팅"
        vc4.title = "MY"
        
        tabBar.tintColor = UIColor.mainColor
        tabBar.unselectedItemTintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        
    }
}

