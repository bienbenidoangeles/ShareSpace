//
//  StorageService.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
  
  private let storageRef = Storage.storage().reference()
  
  private init() {}
  static let shared = StorageService()
  
    public func uploadPhoto(userId: String? = nil, userPhotoId: String? = nil, postId:String? = nil, postPhotoId: String? = nil, image: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
    
    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
      return
    }
    
    var photoReference: StorageReference! // nil
    
    //MARK:- Subject to change

    if  let userId = userId { // coming from ProfileViewController
      photoReference = storageRef.child("UserProfilePhotos/\(userId)/.jpg")
        //let userPhotoId = userPhotoId,
      //  \(userPhotoId)
    } else if let postPhotoId = postPhotoId, let postId = postId { // coming from AddPostsVC
      photoReference = storageRef.child("Photos/\(postId)/\(postPhotoId).jpg")
    }
    
    // configure metatdata for the object being uploaded
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpg" // MIME type
    
    let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
      if let error = error {
        completion(.failure(error))
      } else if let _ = metadata {
        photoReference.downloadURL { (url, error) in
          if let error = error {
            completion(.failure(error))
          } else if let url = url {
            completion(.success(url))
          }
        }
      }
    }
    
  }
}
