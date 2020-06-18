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

//enum ViewState {
//    case myPosts
//    case myReservations
//}

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
    
    
    @IBOutlet weak var cvView: UIView!
    
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
    
    private var viewState: ViewState = .myPosts {
        didSet {
            spacesCollectionView.reloadData()
        }
    }
    
    private var myPosts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.spacesCollectionView.reloadData()
            }
        }
    }
    
    private var myReservations = [Reservation]() {
        didSet {
            DispatchQueue.main.async {
                self.spacesCollectionView.reloadData()
            }
        }
    }
    
    private var refreshControl: UIRefreshControl!
    
    private let storageService = StorageService.shared
   // let databaseService = DatabaseService()
    
<<<<<<< Updated upstream
    
    private var refreshControl: UIRefreshControl!
=======
>>>>>>> Stashed changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< Updated upstream
<<<<<<< Updated upstream
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
    
=======
=======
>>>>>>> Stashed changes
        loadUser()
        configureCollectionView()
        configureProfileImage()
        loadUserImage()
        loadData()
<<<<<<< Updated upstream
    }
    
    private func configureCollectionView() {
        spacesCollectionView.delegate = self
        spacesCollectionView.dataSource = self
    }
    private func configureProfileImage() {
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        userImage.clipsToBounds = true
    }
    
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        spacesCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    @objc private func loadData() {
        fetchPosts()
        fetchReservations()
    }
    
    @objc private func fetchPosts() {
        guard let user = Auth.auth().currentUser else {
            refreshControl.endRefreshing()
            return
        }
        DatabaseService.shared.loadPosts(userId: user.uid) { [weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "error loading posts", message: error.localizedDescription)
                }
            case .success(let myPosts):
                guard let myPosts = myPosts else {
                    return
                }
                self?.myPosts = myPosts
            }
            DispatchQueue.main.async {
               // self?.refreshControl.endRefreshing()
            }
        }
    }
    private func fetchReservations() {
        guard let user = Auth.auth().currentUser else {
            refreshControl.endRefreshing()
            return
        }
        DatabaseService.shared.loadReservations(renterId: user.uid) {[weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "error loading reservations", message: error.localizedDescription)
                }
            case .success(let myReservations):
                guard let myreservations = myReservations else {
                    return
                }
                self?.myReservations = myreservations
            }
        }
=======
>>>>>>> Stashed changes
    }
   
    
    private func configureCollectionView() {
        spacesCollectionView.delegate = self
        spacesCollectionView.dataSource = self
    }
    private func configureProfileImage() {
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        userImage.clipsToBounds = true
    }
    
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        spacesCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    @objc private func loadData() {
        fetchPosts()
        fetchReservations()
    }
    
    @objc private func fetchPosts() {
        guard let user = Auth.auth().currentUser else {
            refreshControl.endRefreshing()
            return
        }
        DatabaseService.shared.loadPosts(userId: user.uid) { [weak self](result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "error loading posts", message: error.localizedDescription)
                }
            case .success(let myPosts):
                guard let myPosts = myPosts else {
                    return
                }
                self?.myPosts = myPosts
            }
            DispatchQueue.main.async {
               // self?.refreshControl.endRefreshing()
            }
        }
    }
    private func fetchReservations() {
        guard let user = Auth.auth().currentUser else {
            refreshControl.endRefreshing()
            return
        }
        DatabaseService.shared.loadReservations(renterId: user.uid) {[weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "error loading reservations", message: error.localizedDescription)
                }
            case .success(let myReservations):
                guard let myreservations = myReservations else {
                    return
                }
                self?.myReservations = myreservations
            }
        }
    }
   
    
    
>>>>>>> Stashed changes
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
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewState = .myPosts
        case 1:
            viewState = .myReservations
        default:
            break
        }
    }
    
<<<<<<< Updated upstream
=======
}

extension FirstProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return 5
        if viewState == .myPosts {
          return myPosts.count
      } else {
           return myReservations.count
      }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mypostCell", for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mypostCell", for: indexPath) as? PostReservationCell else {
            fatalError("Could not downcase tp PostReservationCell")
        }
        if viewState == .myPosts {
        let myPost = myPosts[indexPath.row]
        cell.configureCell(for: myPost)
        } else {
            let reservation = myReservations[indexPath.row]
            cell.configureCell(for: reservation)
        }
       // cell.backgroundColor = .yellow
        return cell
    }
    
    
}

extension FirstProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = cvView.safeAreaLayoutGuide.layoutFrame.size
        let itemWidth = maxSize.width
        let itemHeight = maxSize.height * 0.80
        return CGSize(width: itemWidth, height: itemHeight)
    }
>>>>>>> Stashed changes
}

extension FirstProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return 5
        if viewState == .myPosts {
          return myPosts.count
      } else {
           return myReservations.count
      }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mypostCell", for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mypostCell", for: indexPath) as? PostReservationCell else {
            fatalError("Could not downcase tp PostReservationCell")
        }
        if viewState == .myPosts {
        let myPost = myPosts[indexPath.row]
        cell.configureCell(for: myPost)
        } else {
            let reservation = myReservations[indexPath.row]
            cell.configureCell(for: reservation)
        }
       // cell.backgroundColor = .yellow
        return cell
    }
    
    
}

extension FirstProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = cvView.safeAreaLayoutGuide.layoutFrame.size
        let itemWidth = maxSize.width
        let itemHeight = maxSize.height * 0.80
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

