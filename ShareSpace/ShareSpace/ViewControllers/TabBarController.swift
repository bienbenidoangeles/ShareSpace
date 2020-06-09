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
        
    private var postVC: PostViewController = {
        let vc = PostViewController()
        vc.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "person"), tag: 1)
        return vc
    }()
    
//     private var chatVC: ChatViewController = {
//            let vc = ChatViewController()
//            vc.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 2)
//            return vc
//        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = [mainVC, postVC]
        //let controllers = [mainVC, chatVC]
        viewControllers = controllers.map{UINavigationController(rootViewController: $0)}

    }

}
