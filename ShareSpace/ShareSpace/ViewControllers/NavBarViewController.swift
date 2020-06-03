//
//  NavBarViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/2/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class NavBarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavBarItems()
    }
    
    private func addNavBarItems(){
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(pushToProfileViewController))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func pushToProfileViewController(){
        
    }

}
