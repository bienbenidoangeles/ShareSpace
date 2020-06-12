//
//  PostViewController.swift
//  ShareSpace
//
//  Created by Yuliia Engman on 6/9/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseFirestore

class PostViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var amenititesTextView: UITextView!
    
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var apartmentTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet weak var imagePosting: UIImageView!
    
    
    private let storageService = StorageService.shared
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    //FIXME: change collection for 1 image
    private var selectedImage: UIImage? {
        didSet {
            imagePosting.image = selectedImage
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        titleTextField.delegate = self
        priceTextField.delegate = self
        streetTextField.delegate = self
        apartmentTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        
        descriptionTextView.delegate = self
        amenititesTextView.delegate = self
        
        imagePosting.image = UIImage(systemName: "house.fill")
        imagePosting.tintColor = .yummyOrange
        
    }
    
    @IBAction func uploadPhotosButtonPressed(_ sender: UIButton) {
        
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
    
    @IBAction func submitListingButtonPressed(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let location = Location(country: "USA", streetAddress: streetTextField.text ?? "no street name", apartmentNumber: apartmentTextField.text ?? "no apartment name", city: cityTextField.text ?? "no city name", state: stateTextField.text ?? "no state name", zip: zipCodeTextField.text ?? "no zip code", locationId: "", postId: "",  longitutude: nil, latitude: nil)
        
        CoreLocationSession.shared.convertAddressToCoors(address: location.fullAddress ?? "no address found") {
            (result) in
            switch result {
            case .failure(let error):
                break
            case .success(let coordinate):
                guard let coordinate = coordinate?.first else {
                    return
                }
                let locationDict: [String: Any] =
                    [ "streetAddress": self.streetTextField.text ?? "no street name",
                      "apartmentNumber": self.apartmentTextField.text ?? "no apartment number",
                      "city": self.cityTextField.text ?? "no city name",
                      "state": self.stateTextField.text ?? "no state name",
                      "zip": self.zipCodeTextField.text ?? "no zip code",
                      "latitude": coordinate.latitude,
                      "longitutude": coordinate.longitude
                ]
                
                let priceDict: [String: Any] =
                    ["spaceRate": self.priceTextField.text ?? "100",
                     "tax": 0.15
                ]
                
                let postId = UUID().uuidString
                let userId = user.uid
                let listedDate = Date()
                
                guard let postTitle = self.titleTextField.text, !postTitle.isEmpty,
                    // let price = priceTextField.text, !price.isEmpty,
                    let description = self.descriptionTextView.text, !description.isEmpty,
                    let amenities = self.amenititesTextView.text,
                    let mainImage = self.selectedImage
                    else {
                        print("missing field")
                        return
                }
                //        guard let user = Auth.auth().currentUser else { return }
                //let resizedImage = UIImage.resizeImage(mainImage)
                
                // let resizedImage = UIImage.resizeImage(originalImage: mainImage, rect: imagePosting.bounds)
                var ameritiesArray = amenities.components(separatedBy: CharacterSet(charactersIn: " ,\n")).filter{$0 != ""}
                
                let resizedImage = UIImage.resizeImageTwo(originalImage: mainImage, rect: self.imagePosting.bounds)
                
                // print("original image size: \(mainImage.size)")
                //  print("resized image size: \(resizedImage)")
                
                let dict:[String : Any]
                    = [
                        "postId": postId,
                        "price": priceDict,
                        "postTitle": postTitle,
                        "userId": userId,
                        "listedDate": listedDate,
                        //"mainImage": resizedImage,
                        "description": description,
                        "amenities": ameritiesArray,
                        "location": locationDict
                ]
                
                DatabaseService.shared.postSpace(post: dict)
                { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error save profile changes", message: error.localizedDescription)
                        }
                    case .success:
                        DispatchQueue.main.async {
                           self?.showAlert(title: "Post was successfully cleated", message: nil)
                            self?.uploadPhoto(photo: resizedImage, documentId: postId)
                           // self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        
        
        // let price = Price(subtotal: 125, spaceRate: priceTextField.text?.toDouble() ?? 0.0, taxRate: 25)
        
        
        
        //HOW TO UPLOAD POSTING PHOTO TO STORAGE
        
        //        storageService.uploadPhoto(userId: nil, postId: postId, image: mainImage) {
        //           [weak self] result in
        //            switch result {
        //                case .failure(let error):
        //                DispatchQueue.main.async {
        //                self?.showAlert(title: "Error uploading post photo", message: "\(error.localizedDescription)")
        //            }
        //            case .success(let url):
        //        }
        
        //        storageService.uploadPhoto(postId: postId, image: mainImage) { [weak self] (result) in
        //            // code here to add the photoURL to the user's photoURL
        //            //     property then commit changes
        //            switch result {
        //            case .failure(let error):
        //                DispatchQueue.main.async {
        //                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
        //                }
        //            case .success(let url):
        //                let request = Auth.auth().currentUser?.createProfileChangeRequest()
        //               // request?.displayName = displayName
        //                request?.photoURL = url
        //                request?.commitChanges(completion: { [unowned self] (error) in
        //                    if let error = error {
        //                        //TODO: show alert
        //                        //print("CommitCjanges error: \(error)")
        //                        DispatchQueue.main.async {
        //                            self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription)")
        //                        }
        //                    } else {
        //                        //print("profile successfully updated")
        //                        DispatchQueue.main.async {
        //                            self?.showAlert(title: "Photo downloded", message: "Post photo succesfully updated")
        //                        }
        //                    }
        //                })
        //            }
        //        }
        
        
    }
    
    private func uploadPhoto(photo: UIImage, documentId: String) {
        storageService.uploadPhoto(postId: documentId, image: photo)
        { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading post photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                self?.updateItemImageURL(url, documentId: documentId)
            }
        }
    }
    
    private func updateItemImageURL( _ url: URL, documentId: String) {
        // update unexisting doc on Firebase
        let imageDict: [String: Any] =
            ["mainImage": url.absoluteString,
             "postId": documentId]
        DatabaseService.shared.editPost(postdictionary: imageDict) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Failed to update item", message: "\(error.localizedDescription)")
                }
            case .success:
                print("all went well with update")
                DispatchQueue.main.async {
                   // self?.dismiss(animated: true)
                self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    private func navigateToMainView() {
        navigationController?.popViewController(animated: true)
        //UIViewController.showViewController(viewcontroller: RootViewController())
       // dRootViewController
    }
    
}

/*
 guard let user = Auth.auth().currentUser else { return }
 let chatId = UUID().uuidString
 let renterId = user.uid
 let postId = selectedPost.postId
 let status = Status.undetermined
 let reservationId = UUID().uuidString
 
 guard let checkIn = datesRange?.first,
 let checkOut = datesRange?.last,
 let message = messageTextView.text,
 !message.isEmpty else { return }
 let messageID = UUID().uuidString
 let dict:[String : Any]
 = [
 “renterId”: renterId,
 “postId”: postId,
 “checkIn”: checkIn,
 “checkOut”: checkOut,
 “chatId”: chatId,
 “status”: status.rawValue,
 “reservationId”: reservationId
 ]
 DatabaseService.shared.createReservation(reservation: dict) { (result) in
 switch result {
 case .failure(let error):
 self.showAlert(title: “Error”, message: error.localizedDescription)
 case .success:
 self.showAlert(title: “Your message was successfully sent”, message: “Your host will reply shortly!“)
 }
 }
 */

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//FIXME: check if properly works
extension PostViewController: UITextViewDelegate {
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //        if(text == "\n")
    //        {
    //            view.endEditing(true)
    //            return false
    //        }
    //        else
    //        {
    //            return true
    //        }
    //    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
