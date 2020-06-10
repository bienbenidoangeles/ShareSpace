//
//  FirstProfileViewController.swift
//  ShareSpace
//
//  Created by Yuliia Engman on 6/8/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class FirstProfileViewController: UIViewController {
    
    
    
      private var user: UserModel?
    
    private let userId: String
    init?(coder: NSCoder, userId: String) {
      self.userId = userId
      super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        loadUser()
        
        //updateUI()
    }
    
    
    func updateUI() {
        guard let user = user else {
            return
        }
        if let user = Auth.auth().currentUser {
            if user.uid == self.userId {
                userEmail.text = user.email ?? "no email"
            }
        }
      //  userEmail.text = user.userEmail
    }
    
    func loadUser() {
        DatabaseService.shared.loadUser(userId: userId) {
            (result) in
            switch result {
            case .failure(let error):
                print("error load user: \(error.localizedDescription)")
            case .success(let user):
                self.user = user
                self.updateUI()
            }
        }
    }
    
    @IBAction func editButton(_ sender: UIButton) {
    }
    

}
