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
    
     private var chatVC: ChatListViewController = {
            let vc =  ChatListViewController()
            vc.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 2)
            return vc
        }()
    
    private var reservVC: ReservationDetailViewController = {
        let vc =  ReservationDetailViewController()
        vc.tabBarItem = UITabBarItem(title: "test", image: UIImage(systemName: "message"), tag: 1)
        return vc
    }()
    
    private var mypostReservVC: MyPostsReservationsViewController = {
        let vc =  MyPostsReservationsViewController()
        vc.tabBarItem = UITabBarItem(title: "MyCollections", image: UIImage(systemName: "message"), tag: 3)
        return vc
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        //let controllers = [mainVC, profileVC]
        let controllers = [mainVC, reservVC, chatVC, mypostReservVC]
        viewControllers = controllers.map{UINavigationController(rootViewController: $0)}

    }

}
