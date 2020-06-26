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
    
    
    @IBOutlet weak var signOutButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var spacesCollectionView: UICollectionView!
    
    //FIXME: add user rating
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var editButtonOutlet: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    
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
        
        editButtonOutlet.tintColor = .white
        editButtonOutlet.backgroundColor = .yummyOrange
        
        editButtonOutlet.clipsToBounds = true
        editButtonOutlet.layer.cornerRadius = 7
        editButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        editButtonOutlet.isHidden = true
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .clear
       // navigationItem.leftBarButtonItem?.tintColor = .systemTeal
        navigationController?.navigationBar.tintColor = .systemTeal
        
        textView.font = .preferredFont(forTextStyle: .body)
        
//        profileView.userSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
//        profileView.userSegmentedControl.selectedSegmentIndex = 0
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadUser), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        textView.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
//        userNameLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
//        userLocation.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
//        occupationLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        
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
        if let currentUser = Auth.auth().currentUser {
            if currentUser.uid == self.userId {
                          editButtonOutlet.isHidden = false
                          //navigationItem.rightBarButtonItem != nil
                      navigationItem.rightBarButtonItem?.isEnabled = true
                          navigationItem.rightBarButtonItem?.tintColor = .systemTeal
            }
        }
        
        userNameLabel.text = "Hi, I am \(user.displayName)"
        userLocation.text = "I am from \(user.cityState)"
        occupationLabel.text = "I am working as \(user.work ?? "Mobile Developer")"
        textView.text = user.bio
//        segmentedControl.insertSegment(withTitle: "My Spaces", at: 0, animated: true)
//        segmentedControl.insertSegment(withTitle: "My Reservations", at: 1, animated: true)
        
        segmentedControl.selectedSegmentTintColor = .yummyOrange
        segmentedControl.backgroundColor = .oceanBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        DispatchQueue.main.async {
            
            self.userImage.kf.setImage(with: URL(string: user.profileImage ?? "no image url"))
        }
    }
    
//    public lazy var segmentedControl: UISegmentedControl = {
//           let sc = UISegmentedControl()
//           sc.insertSegment(withTitle: "My Listings", at: 0, animated: true)
//           sc.insertSegment(withTitle: "My reservations", at: 1, animated: true)
//           sc.insertSegment(withTitle: "My Stays", at: 2, animated: true)
//           sc.selectedSegmentTintColor = .yummyOrange
//           sc.backgroundColor = .oceanBlue
//           sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
//           sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//           return sc
    
    
    func loadImage(imageURL: String) {
        DispatchQueue.main.async {
            self.userImage.kf.setImage(with: URL(string: imageURL))
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
            return editButtonOutlet.isHidden = true
        }
        let userId = user.uid
        let editProfilelVC = ProfileViewController(userId)
        navigationController?.pushViewController(editProfilelVC, animated: true)
    }
}

