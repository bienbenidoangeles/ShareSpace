//
//  NavBarViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/2/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth

class NavBarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarItems()
    }
    
       private func addNavBarItems(){
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(pushToFirstProfileViewController))
            navigationItem.rightBarButtonItem = barButtonItem
        }
    
    @objc private func pushToFirstProfileViewController(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        let storyboard = UIStoryboard(name: "FirstProfileStoryboard", bundle: nil)
        let firstProfilelVC = storyboard.instantiateViewController(identifier: "FirstProfileViewController")
        { (coder) in
            return FirstProfileViewController(coder: coder, userId: user.uid)
        }
        navigationController?.pushViewController(firstProfilelVC, animated: true)
    }
}
