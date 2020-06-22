//
//  ProfileViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseFirestore

class ProfileViewController: UIViewController, UIScrollViewDelegate {
    
    private var profileView = ProfileView()
    
    override func loadView() {
        super.loadView()
        view = profileView
    }
    
     private var user: UserModel?
    
    private let userId: String
    
      init(_ userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            profileView.profileImageView.image = selectedImage
        }
    }
    
    private var userState: Int?
    private var selectedUserState: UserType = .user {
        didSet {
            userState = selectedUserState.rawValue
        }
    }
    
    private let storageService = StorageService.shared
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
        profileView.userDisplayNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userFirstNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userLastNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userPhoneNumberTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.emailLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userBioTextview.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userOccupationTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.governmentIdTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userCreditcardTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userCreditcardCVVNumberTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
        profileView.userExpirationDateTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .oceanBlue, thickness: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.leftBarButtonItem?.tintColor = .oceanBlue
        navigationItem.title = "Edit Your Profile"
        
        //updateUI()
        
        profileView.scrollView.delegate = self
        
        profileView.userDisplayNameTextfield.delegate = self
        profileView.userFirstNameTextfield.delegate = self
        profileView.userLastNameTextfield.delegate = self
        //profileView.userTypeTextfield.delegate = self
        profileView.userPhoneNumberTextfield.delegate = self
        profileView.userBioTextview.delegate = self
        profileView.userOccupationTextfield.delegate = self
        profileView.governmentIdTextfield.delegate = self
        profileView.userCreditcardTextfield.delegate = self
        profileView.userCreditcardCVVNumberTextfield.delegate = self
        profileView.userExpirationDateTextfield.delegate = self
        
        profileView.editProfileImageButton.addTarget(self, action: #selector(userImageEditButtonPressed), for: .touchUpInside)
       // profileView.uploadIdButton.addTarget(self, action: #selector(uploadIdButtonPressed), for: .touchUpInside)
        profileView.saveChangesButton.addTarget(self, action: #selector(saveUserProfileButtonPressed), for: .touchUpInside)
       // addNavSignOutButton()
        

       // profileView.userSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        //profileView.userSegmentedControl.selectedSegmentIndex = 0
        
        loadUser()
    }
    
    func updateUI() {
        guard let user = user else {
            return
        }
        if let user = Auth.auth().currentUser {
            if user.uid == self.userId {
                //works
                profileView.emailLabel.text = user.email ?? "no email"

            }
        }
        
        //profileView.userSegmentedControl.selectedSegmentIndex = user.userType.rawValue

        profileView.userDisplayNameTextfield.text = user.displayName
        profileView.userFirstNameTextfield.text = user.firstName
        profileView.userLastNameTextfield.text = user.lastName
        profileView.userPhoneNumberTextfield.text = user.phoneNumber
        profileView.userBioTextview.text = user.bio
        profileView.userOccupationTextfield.text = user.bio
        profileView.governmentIdTextfield.text = user.governmentId
        profileView.userCreditcardTextfield.text = user.creditCard
        profileView.userCreditcardCVVNumberTextfield.text = user.cardCVV
        profileView.userExpirationDateTextfield.text = user.cardExpDate

        DispatchQueue.main.async {

           // self.profileView.profileImageView.kf.setImage(with: URL(string: user.profileImage ?? "no image url"))
            
            self.profileView.profileImageView.kf.setImage(with: URL(string: user.profileImage ?? "no image url"), placeholder: UIImage(systemName: "person.fill"), options: nil, progressBlock: nil) { [weak self](result) in
              switch result {
              case .failure(let error):
                print("error to add image")
              case .success(let imageResult):
                self?.selectedImage = imageResult.image
              }
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
    
//    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
//           switch (segmentedControl.selectedSegmentIndex) {
//           case 0:
//            selectedUserState = .user
//           case 1:
//            selectedUserState = .host
//           default:
//            print("default")
//           }
//       }
//
    @objc func userImageEditButtonPressed() {
        
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        { [weak self] alertAction in
            self?.imagePickerController.sourceType = .camera
            self?.present(self!.imagePickerController, animated: true)
        }
        let phototLibararyAction = UIAlertAction(title: "Photo Libarary", style: .default)
        { [weak self] alertAction in
            self?.imagePickerController.sourceType = .photoLibrary
            self?.present(self!.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(phototLibararyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc func saveUserProfileButtonPressed() {
        
        guard //let userType = userState,
            let displayName = profileView.userDisplayNameTextfield.text,
            !displayName.isEmpty,
            let userFirstName = profileView.userFirstNameTextfield.text,
            !userFirstName.isEmpty,
            let userLastName = profileView.userLastNameTextfield.text,
            !userLastName.isEmpty,
            let userPhoneNumber = profileView.userPhoneNumberTextfield.text,
            !userPhoneNumber.isEmpty,
            let userBio = profileView.userBioTextview.text,
            !userBio.isEmpty,
            let userGovenmentId = profileView.governmentIdTextfield.text,
            !userGovenmentId.isEmpty,
            let userOccupation = profileView.userOccupationTextfield.text,
            !userOccupation.isEmpty,
            let userCardNumber = profileView.userCreditcardTextfield.text,
            !userCardNumber.isEmpty,
            let userCardCVVNumber = profileView.userCreditcardCVVNumberTextfield.text,
            !userCardCVVNumber.isEmpty,
            let userCardExpDate = profileView.userExpirationDateTextfield.text, !userCardExpDate.isEmpty,
            
            //FIXME: why I need to change photo in terms to update some textfield?
            let selectedImage = selectedImage else {
                print("missing field")
                DispatchQueue.main.async {
                    self.showAlert(title: "Missing fields", message: "All fields are required")
                }
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
                self?.updateDatabaseUser(firstName: userFirstName, lastName: userLastName, displayName: displayName, phoneNumber: userPhoneNumber, bio: userBio, work: userOccupation, governmentId:userGovenmentId, creditCard: userCardNumber, cardCVV: userCardCVVNumber, cardExpDate: userCardExpDate,  profileImage: url.absoluteString)
                
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.photoURL = url // url.absoluteString for the updateDbUser func
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        //TODO: show alert
                        //print("CommitCjanges error: \(error)")
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Updated", message: "Profile successfully updated")
                        }
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    private func updateDatabaseUser(firstName: String, lastName: String, displayName: String, phoneNumber: String, bio: String, work: String, governmentId: String, creditCard: String, cardCVV: String, cardExpDate: String, profileImage: String) {
      DatabaseService.shared.updateDatabaseUser(firstName: firstName, lastName: lastName, displayName: displayName, phoneNumber: phoneNumber, bio: bio, work: work, governmentId: governmentId, creditCard: creditCard, cardCVV: cardCVV, cardExpDate: cardExpDate, profileImage: profileImage) { [weak self] (result) in
               switch result {
               case .failure(let error):
                   print("failed to update db user: \(error.localizedDescription)")
               case .success:
                   print("successfully updated db user")
                   self?.dismiss(animated: true, completion: nil)
               }
           }
       }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UITextViewDelegate {
    
}

extension CALayer {
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    let border = CALayer()
    switch edge {
    case UIRectEdge.top:
      border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
      break
    case UIRectEdge.bottom:
      border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
      break
    case UIRectEdge.left:
      border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
      break
    case UIRectEdge.right:
      border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
      break
    default:
      //For Center Line
      border.frame = CGRect(x: self.frame.width/2 - thickness, y: 0, width: thickness, height: self.frame.height)
      break
    }
    border.backgroundColor = color.cgColor;
    self.addSublayer(border)
  }
}
