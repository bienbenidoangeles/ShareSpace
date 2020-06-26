//
//  NavBarViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/2/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class NavBarViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = UIImage(systemName: "person.fill") else {
            return
        }
        addNavBarItems(image: image)
        loadUser()
    }
    
    func loadUser() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        DatabaseService.shared.loadUser(userId: user.uid) {
            (result) in
            switch result {
            case .failure(let error):
                print("error load user: \(error.localizedDescription)")
            case .success(let user):
                self.getProfileImage(user: user)
            }
        }
    }
    
    func getProfileImage(user: UserModel){
        guard let userProfileImg = user.profileImage, let url = URL(string: userProfileImg) else {
            return
        }
        
        let imageSize = CGSize(width: 25, height: 25)
        let mainImgprocessor =
            DownsamplingImageProcessor(size: imageSize)
        |>
            ResizingImageProcessor(referenceSize: imageSize)
        |>
            RoundCornerImageProcessor(cornerRadius: imageSize.height/2.0)
        
        KingfisherManager.shared.retrieveImage(with: url, options: [.processor(mainImgprocessor)], progressBlock: nil, downloadTaskUpdated: nil) { [weak self] (result) in
            switch result{
            case .failure:
                break
            case .success(let image):
                self?.addNavBarItems(image: image.image)
            }
        }
    }
    
    private func addNavBarItems(image: UIImage){
        
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pushToFirstProfileViewController), for: .touchUpInside)
        //button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        //button.imageView?.layer.cornerRadius = button.frame.width/2.0
        
        let barButtonItem = UIBarButtonItem(customView: button)
        if image != UIImage(systemName: "person.fill"){
            barButtonItem.image = image
        }
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func pushToFirstProfileViewController(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        let storyboard = UIStoryboard(name: "FirstProfileStoryboard", bundle: nil)
        let firstProfilelVC = storyboard.instantiateViewController(identifier: "FirstProfileViewController")
        { (coder) in
            return FirstProfileViewController(coder: coder, userId: user.uid)
        }
        navigationController?.pushViewController(firstProfilelVC, animated: true)
    }
}
