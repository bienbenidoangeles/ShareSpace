//
//  TabBarController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var mainVC: RootViewController = {
        let vc = RootViewController()
        vc.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "photo"), tag: 0)
        return vc
    }()
        
//    private var profileVC: ProfileViewController = {
//        let vc = ProfileViewController()
//        vc.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
//        return vc
//    }()
    
<<<<<<< HEAD
     private var chatVC: ChatVC = {
            let vc = ChatVC()
            vc.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 1)
=======
     private var chatVC: ChatViewController = {
            let vc = ChatViewController()
            vc.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 2)
>>>>>>> a99c9b85a0260c88177801c7676d02e72f04d75f
            return vc
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //let controllers = [mainVC, profileVC]
        let controllers = [mainVC, chatVC]
        viewControllers = controllers.map{UINavigationController(rootViewController: $0)}

    }

}
