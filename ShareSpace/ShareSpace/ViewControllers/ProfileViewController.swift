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
    
    private var selectedIdImage: UIImage? {
        didSet {
            profileView.idImageView.image = selectedIdImage
        }
    }
    
    private let storageService = StorageService.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        updateUI()
        
        profileView.scrollView.delegate = self
        
        profileView.userDisplayNameTextfield.delegate = self
        profileView.userFirstNameTextfield.delegate = self
        profileView.userLastNameTextfield.delegate = self
        profileView.userTypeTextfield.delegate = self
        profileView.userPhoneNumberTextfield.delegate = self
        profileView.userBioTextfield.delegate = self
        profileView.userOccupationTextfield.delegate = self
        profileView.governmentIdTextfield.delegate = self
        profileView.userCreditcardTextfield.delegate = self
        profileView.userCreditcardCVVNumberTextfield.delegate = self
        profileView.userExpirationDateTextfield.delegate = self
        
        profileView.editProfileImageButton.addTarget(self, action: #selector(userImageEditButtonPressed), for: .touchUpInside)
        profileView.uploadIdButton.addTarget(self, action: #selector(uploadIdButtonPressed), for: .touchUpInside)
        profileView.saveChangesButton.addTarget(self, action: #selector(saveUserProfileButtonPressed), for: .touchUpInside)
        addNavSignOutButton()
    }
    
    
    //FIXME:
    private func addNavSignOutButton(){
        let barButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(signOutButtonPressed(_:)))
        navigationItem.rightBarButtonItems?.append(barButtonItem)
    }
    
    @objc private func signOutButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            UIViewController.showViewController(viewcontroller: LoginViewController())
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Unable to signout", message: "Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        //        emailLabel.text = user.email
        // profileView.userDisplayNameTextfield.text = user.displayName
        //        profileImageView.kf.setImage(with: user.photoURL)
        
        //I think we have to add photo to user model
        //profileView.profileImageView.kf.setImage(with: user.photoURL)
        
        // profileView.userDisplayNameLabel.text = user.displayName
        
        // profileView.userNameLabel.text = user.firstName
        profileView.userPhoneNumberTextfield.text = user.phoneNumber
        
        profileView.emailLabel.text = user.email
        
        // profileView.userBioTextfield.text = user.bio
        // profileView.userOccupationTextfield.text = user.work
        // profileView.governmentIdLabel.text = user.govermentId
        // profileView.paymentLabel.text = user.payment
    }
    
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
    
    
    //FIXME: to add chosed pic to idImageView
     @objc func uploadIdButtonPressed() {
           
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
        
        guard let displayName = profileView.userDisplayNameTextfield.text,
            !displayName.isEmpty,
            let userFirstName = profileView.userFirstNameTextfield.text,
            !userFirstName.isEmpty,
            let userLastName = profileView.userLastNameTextfield.text,
            !userLastName.isEmpty,
            let userType = profileView.userTypeTextfield.text,
            !userType.isEmpty,
            let userPhoneNumber = profileView.userPhoneNumberTextfield.text,
            !userPhoneNumber.isEmpty,
            let userBio = profileView.userBioTextfield.text,
            !userBio.isEmpty,
            let userGovenmentId = profileView.governmentIdTextfield.text,
            !userGovenmentId.isEmpty,
            let userOccupation = profileView.userOccupationTextfield.text, !userOccupation.isEmpty,
            let userCardNumber = profileView.userCreditcardTextfield.text, !userCardNumber.isEmpty,
            let userCardCVVNumber = profileView.userCreditcardCVVNumberTextfield.text,
            !userCardCVVNumber.isEmpty,
            let userCardExpDate = profileView.userExpirationDateTextfield.text, !userCardExpDate.isEmpty,
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
                request?.photoURL = url
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        //TODO: show alert
                        //print("CommitCjanges error: \(error)")
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription)")
                        }
                    } else {
                        //print("profile successfully updated")
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Updated", message: "Profile successfully updated")
                        }
                    }
                })
            }
        }
        
        DatabaseService.shared.updateDatabaseUser(firstName: userFirstName, lastName: userLastName, displayName: displayName, phoneNumber: userPhoneNumber, bio: userBio, work: userOccupation, userType: userType, governmentId: userGovenmentId, creditCard: userCardNumber, cardCVV: userCardCVVNumber, cardExpDate: userCardExpDate){ [weak self]
        (result) in
            switch result {
            case .failure(let error):
              DispatchQueue.main.async {
                self?.showAlert(title: "Error save profile changes", message: error.localizedDescription)
              }
            case .success:
              DispatchQueue.main.async {
                self?.navigateToMainView()
              }
            }
    }
    }
        
        private func navigateToMainView() {
          UIViewController.showViewController(viewcontroller: TabBarController())
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
