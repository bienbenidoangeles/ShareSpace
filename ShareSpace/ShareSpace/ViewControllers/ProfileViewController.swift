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
        profileView.userDisplayNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userFirstNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userLastNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userLocationTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userPhoneNumberTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userBioTextview.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userOccupationTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.governmentIdNameTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        profileView.userExpirationDateTextfield.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.leftBarButtonItem?.tintColor = .oceanBlue
        navigationItem.title = "Edit Your Profile"
        profileView.scrollView.delegate = self
        
        profileView.userDisplayNameTextfield.delegate = self
        profileView.userFirstNameTextfield.delegate = self
        profileView.userLastNameTextfield.delegate = self
        profileView.userPhoneNumberTextfield.delegate = self
        profileView.userBioTextview.delegate = self
        profileView.userOccupationTextfield.delegate = self
        profileView.governmentIdNameTextfield.delegate = self
        profileView.userCreditcardTextfield.delegate = self
        profileView.userCreditcardCVVNumberTextfield.delegate = self
        profileView.userExpirationDateTextfield.delegate = self
        
        profileView.editProfileImageButton.addTarget(self, action: #selector(userImageEditButtonPressed), for: .touchUpInside)
        profileView.saveChangesButton.addTarget(self, action: #selector(saveUserProfileButtonPressed), for: .touchUpInside)
        loadUser()
    }
    
    func updateUI() {
        guard let user = user else {
            return
        }
        if let user = Auth.auth().currentUser {
            if user.uid == self.userId {
                profileView.emailLabel.text = user.email ?? "no email"
            }
        }
        
        profileView.userDisplayNameTextfield.text = user.displayName
        profileView.userFirstNameTextfield.text = user.firstName
        profileView.userLastNameTextfield.text = user.lastName
        profileView.userLocationTextfield.text = user.cityState
        profileView.userPhoneNumberTextfield.text = user.phoneNumber
        profileView.userBioTextview.text = user.bio
        profileView.userOccupationTextfield.text = user.work
        profileView.governmentIdNameTextfield.text = user.governmentId
        profileView.userCreditcardTextfield.text = user.creditCard
        profileView.userCreditcardCVVNumberTextfield.text = user.cardCVV
        profileView.userExpirationDateTextfield.text = user.cardExpDate
        
        DispatchQueue.main.async {
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
    
    @objc func userImageEditButtonPressed() {
        
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        { [weak self] alertAction in
            self?.imagePickerController.sourceType = .camera
            self?.present(self!.imagePickerController, animated: true)
        }
        let phototLibararyAction = UIAlertAction(title: "Photo Library", style: .default)
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
            let userCityState = profileView.userLocationTextfield.text,
            !userCityState.isEmpty,
            let userPhoneNumber = profileView.userPhoneNumberTextfield.text,
            !userPhoneNumber.isEmpty,
            let userBio = profileView.userBioTextview.text,
            !userBio.isEmpty,
            let userGovenmentId = profileView.governmentIdNameTextfield.text,
            !userGovenmentId.isEmpty,
            let userOccupation = profileView.userOccupationTextfield.text,
            !userOccupation.isEmpty,
            let userCardNumber = profileView.userCreditcardTextfield.text,
            !userCardNumber.isEmpty,
            let userCardCVVNumber = profileView.userCreditcardCVVNumberTextfield.text,
            !userCardCVVNumber.isEmpty,
            let userCardExpDate = profileView.userExpirationDateTextfield.text, !userCardExpDate.isEmpty,
            
            let selectedImage = selectedImage else {
                print("missing field")
                DispatchQueue.main.async {
                    self.showAlert(title: "Missing fields", message: "All fields are required")
                }
                return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        // let resizedImage = UIImage.resizeImage(selectedImage)
        
        print("original image size: \(selectedImage.size)")
        // print("resized image size: \(resizedImage)")
        
        storageService.uploadPhoto(userId: user.uid, image: selectedImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateDatabaseUser(firstName: userFirstName, lastName: userLastName, displayName: displayName, phoneNumber: userPhoneNumber, bio: userBio, work: userOccupation, governmentId:userGovenmentId, creditCard: userCardNumber, cardCVV: userCardCVVNumber, cardExpDate: userCardExpDate, cityState: userCityState,  profileImage: url.absoluteString)
                
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.displayName = displayName
                request?.photoURL = url // url.absoluteString for the updateDbUser func
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
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
    
    private func updateDatabaseUser(firstName: String, lastName: String, displayName: String, phoneNumber: String, bio: String, work: String, governmentId: String, creditCard: String, cardCVV: String, cardExpDate: String, cityState: String, profileImage: String) {
        DatabaseService.shared.updateDatabaseUser(firstName: firstName, lastName: lastName, displayName: displayName, phoneNumber: phoneNumber, bio: bio, work: work, governmentId: governmentId, creditCard: creditCard, cardCVV: cardCVV, cardExpDate: cardExpDate, cityState: cityState, profileImage: profileImage) { [weak self] (result) in
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
