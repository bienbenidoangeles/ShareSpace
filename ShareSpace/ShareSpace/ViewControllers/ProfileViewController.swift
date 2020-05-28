//
//  ProfileViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var profileView = ProfileView()
    
    override func loadView() {
        super.loadView()
        view = profileView
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       view.backgroundColor = .systemGroupedBackground
    }
    


}
