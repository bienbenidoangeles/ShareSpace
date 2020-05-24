//
//  TabBarController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var mainVC: MainViewController = {
        let vc = MainViewController()
        vc.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "photo"), tag: 0)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = [mainVC]
        viewControllers = controllers.map{UINavigationController(rootViewController: $0)}

    }

}
