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

class ProfileViewController: UIViewController {
    
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
    
    //???
    private let storageService = StorageService()
    

    override func viewDidLoad() {
        super.viewDidLoad()

       view.backgroundColor = .systemGroupedBackground
        
        updateUI()
        
        profileView.updateProfileButton.isHidden = true
        profileView.editProfileImageButton.isHidden = true
        
        profileView.userDisplayNameTextfield.isHidden = true
        profileView.userDisplayNameTextfield.delegate = self
        
        profileView.userNameTextfield.isHidden = true
        profileView.userNameTextfield.delegate = self
        
        profileView.userPhoneNumberTextfield.isHidden = true
        profileView.userPhoneNumberTextfield.delegate = self
        
        profileView.userBioTextfield.isHidden = true
        profileView.userBioTextfield.delegate = self
        
        profileView.userOccupationTextfield.isHidden = true
        profileView.userOccupationTextfield.delegate = self
        
        profileView.userCreditcardTextfield.isHidden = true
        profileView.userCreditcardTextfield.delegate = self
        profileView.userCreditcardCVVNumberTextfield.isHidden = true
        profileView.userCreditcardCVVNumberTextfield.delegate = self
        profileView.userExpirationDateTextfield.isHidden = true
        profileView.userExpirationDateTextfield.delegate = self
        
       // profileView.editProfileImageButton.addTarget(self, action: #selector(userImageEditButtonPressed), for: .touchUpInside)
        
        profileView.editProfileButton.addTarget(self, action: #selector(editUserProfileButtonPressed), for: .touchUpInside)

    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
//        emailLabel.text = user.email
//        displayUsernameTextField.text = user.displayName
//        profileImageView.kf.setImage(with: user.photoURL)
        
        //I think we have to add photo to user model
        //profileView.profileImageView.kf.setImage(with: user.photoURL)
       
       // profileView.userDisplayNameLabel.text = user.displayName
       
        // profileView.userNameLabel.text = user.firstName
       // profileView.phoneNumberLabel.text = user.phoneNumber
        
        profileView.emailLabel.text = user.email
        
        //profileView.bioLabel.text = user.bio
       // profileView.occupationLabel.text = user.work
        //profileView.governmentIdLabel.text = user.govermentId
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
    
    @objc func editUserProfileButtonPressed() {
        
        //profileView.emailLabel
        
        profileView.editProfileImageButton.isHidden = false
        
        profileView.userDisplayNameTextfield.isHidden = false
        profileView.userDisplayNameLabel.isHidden = true
        
        profileView.userNameTextfield.isHidden = false
        profileView.userNameLabel.isHidden = true
        
        profileView.userPhoneNumberTextfield.isHidden = false
        profileView.phoneNumberLabel.isHidden = true
        
        profileView.userBioTextfield.isHidden = false
        profileView.bioLabel.isHidden = true
        
        profileView.userOccupationTextfield.isHidden = false
        profileView.occupationLabel.isHidden = true
        
        profileView.userCreditcardTextfield.isHidden = false
        profileView.userCreditcardCVVNumberTextfield.isHidden = false
        profileView.userExpirationDateTextfield.isHidden = false
        profileView.paymentLabel.isHidden = true
        
        profileView.editProfileImageButton.addTarget(self, action: #selector(userImageEditButtonPressed), for: .touchUpInside)
        
        profileView.editProfileButton.isHidden = true
        profileView.updateProfileButton.isHidden = false
        
       // profileView.updateProfileButton.addTarget(self, action: #selector(updateUserProfileButtonPressed), for: .touchUpInside)
    }
    
    /*
    @objc func updateUserProfileButtonPressed() {
        
        guard let displayName = profileView.userDisplayNameTextfield.text,
            !displayName.isEmpty,
          let userFullName = profileView.userNameTextfield.text,
            !userFullName.isEmpty,
          let userPhoneNumber = profileView.userPhoneNumberTextfield.text,
            !userPhoneNumber.isEmpty,
        let userBio = profileView.userBioTextfield.text,
            !userBio.isEmpty,
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
        storageservice.uploadPhoto(userId: user.uid, image: resizedImage) { [weak self] (result) in
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
        
        
        
        profileView.updateProfileButton.isHidden = false
        
    }

*/
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
