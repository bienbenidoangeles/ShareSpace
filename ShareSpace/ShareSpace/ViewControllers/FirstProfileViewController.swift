//
//  FirstProfileViewController.swift
//  ShareSpace
//
//  Created by Yuliia Engman on 6/8/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class FirstProfileViewController: UIViewController {
    
    @IBOutlet var userImegeView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    
    @IBOutlet weak var spacesCollectionView: UICollectionView!
    
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editButton(_ sender: UIButton) {
    }
    

}
