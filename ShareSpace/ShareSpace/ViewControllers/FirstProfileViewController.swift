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
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var userRating: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var spacesCollectionView: UICollectionView!
    @IBOutlet weak var reviewsCollectionView: UICollectionView!
    @IBOutlet weak var userEmail: UILabel!
    
    
    
    private var selectedImage: UIImage? {
        didSet {
            userImage.image = selectedImage
        }
    }
    
    private let storageService = StorageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(viewcontroller: LoginViewController())
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Unable to signout", message: "Error: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUI() {
        guard let user = user else {
            return
        }
        if let user = Auth.auth().currentUser {
            if user.uid == self.userId {
                //works
                userEmail.text = user.email ?? "no email"
            }
        }
        userNameLabel.text = user.displayName
        userPhoneNumber.text = user.phoneNumber
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
        guard let user = Auth.auth().currentUser else {
            return
        }
        let editProfilelVC = ProfileViewController()
        navigationController?.pushViewController(editProfilelVC, animated: true)
    }
}
