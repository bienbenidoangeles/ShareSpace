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
import Kingfisher

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
    
    private var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        userImage.clipsToBounds = true
        
        loadUserImage()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadUser), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(loadUserImage), for: .valueChanged)
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
            refreshControl.endRefreshing()
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
               //userImage.kf.setImage(with: URL(string: user.profileImage ?? "no image url"))
              // userImage.kf.setImage(with: URL(string: user.profileImage ?? "no "))
        DispatchQueue.main.async {
            
            self.userImage.kf.setImage(with: URL(string: user.profileImage ?? "no image url"))
                   
                  // loadUserImage()
                   //loadImage(imageURL: user.profileImage ?? "no image url")
        }
       
    }
    
    
    func loadImage(imageURL: String) {
        DispatchQueue.main.async {
            self.userImage.kf.setImage(with: URL(string: imageURL))
        }
    }
    
    
    @objc func loadUserImage() {
        guard let displayName = userNameLabel.text,
            let selectedImage = selectedImage else {
                          print("missing field")
                          return
                  }
          guard let user = Auth.auth().currentUser else { return }
           //resize image before uploading to Firebase
           //let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileView.profileImageView.bounds)
           let resizedImage = UIImage.resizeImage(selectedImage)
           
           print("original image size: \(selectedImage.size)")
           print("resized image size: \(resizedImage)")
           
           //TODO: call storageService.upload
           //need to update to user userId ot itemId
           
           // Update this code:
           // create
           storageService.uploadPhoto(userId: user.uid, image: selectedImage) { [weak self] (result) in
               // code here to add the photoURL to the user's photoURL
               //     property then commit changes
               switch result {
               case .failure(let error):
                   DispatchQueue.main.async {
                       self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                   }
               case .success(let url):
                   let request = Auth.auth().currentUser?.createProfileChangeRequest()
                   request?.displayName = displayName
                   request?.photoURL = url // url.absoluteString for the updateDbUser func
                   request?.commitChanges(completion: { [unowned self] (error) in
                       if let error = error {
                           //TODO: show alert
                           //print("CommitCjanges error: \(error)")
                           DispatchQueue.main.async {
                               self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription)")
                            self?.refreshControl.endRefreshing()
                           }
                       } else {
                           //print("profile successfully updated")
                           //update user code
                           
                           DispatchQueue.main.async {
                               self?.showAlert(title: "Profile Updated", message: "Profile successfully updated")
                           }
                       }
                   })
               }
        }
    }
  
    
    @objc func loadUser() {
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
        let userId = user.uid
        let editProfilelVC = ProfileViewController(userId)
        navigationController?.pushViewController(editProfilelVC, animated: true)
        //navigationController?.popViewController(animated: true)
    }
}

