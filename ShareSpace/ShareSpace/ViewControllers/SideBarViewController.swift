//
//  SideBarViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth

class SideBarViewController: UIViewController {
    
    public var sideBarView = SideBarView()
    //@objc let sharedAppStateInstance = AppState.shared
    
    override func loadView() {
        view = sideBarView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addNavButtons()
        addGestures()
        updateUI()
    }
    
    private func updateUI(){
        //sharedAppStateInstance.addObserver(self, forKeyPath: #keyPath(sharedAppStateInstance.userType), options: [.old, .new], context: nil)
        //        sharedAppStateInstance.observe(\.userType) {[weak self] (appState, change) in
        //            if appState.userType != .guest{
        //                self?.sideBarView.loginLabel.text = "Logout"
        //            } else {
        //                self?.sideBarView.loginLabel.text = "Login"
        //            }
        //        }
        
        if AuthenticationSession.shared.isSignedIn() {
            sideBarView.loginLabel.text = "Logout"
        } else {
            self.sideBarView.loginLabel.text = "Login"
        }
    }
    
    private func addNavButtons(){
        let sideBarButtonC = UIBarButtonItem(customView: UIImageView(image: UIImage(systemName: "xmark")))
        sideBarButtonC.action = #selector(sideBarTapped(_:))
        sideBarButtonC.tintColor = .systemTeal
        
        
        let sideBarButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(sideBarTapped(_:)))
        sideBarButton.tintColor = .systemTeal
        
        navigationItem.leftBarButtonItem = sideBarButton
    }
    
    private func addGestures(){
        
        let loginTapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped(_:label:)))
        let chatTapGesture = UITapGestureRecognizer(target: self, action: #selector(chatLabelTapped))
        let myCollectionsTapGesture = UITapGestureRecognizer(target: self, action: #selector(myCollectionsLabelTapped))
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingsLabelTapped))
        
        sideBarView.loginLabel.addGestureRecognizer(loginTapGesture)
        sideBarView.chatLabel.addGestureRecognizer(chatTapGesture)
        sideBarView.myProfileLabel.addGestureRecognizer(myCollectionsTapGesture)
        sideBarView.settingsLabel.addGestureRecognizer(settingsTapGesture)
    }
    
    @objc private func sideBarTapped(_ recognizer: UITapGestureRecognizer){
        navigationController?.fadeAway()
    }
    
    @objc private func loginLabelTapped(_ recognizer: UITapGestureRecognizer, label: UILabel){
        if let _ =  AuthenticationSession.shared.auth.currentUser {
            do {
                try AuthenticationSession.shared.logout()
                UIViewController.showViewController(viewcontroller: LoginViewController())
            } catch {
                showAlert(title: "Logout Error", message: error.localizedDescription)
            }
        } else {
            //sign in code
        }
        
        //        if AppState.shared.getAppState() != .guest {
        //            do {
        //                try AuthenticationSession.shared.logout()
        //                UIViewController.showViewController(viewcontroller: LoginViewController())
        //            } catch {
        //
        //            }
        //
        //        } else {
        //
        //        }
    }
    
    @objc private func chatLabelTapped(){
        navigationController?.pushViewController(ChatListViewController(), animated: true)
    }
    
    @objc private func myCollectionsLabelTapped(){
        navigationController?.pushViewController(MyPostsReservationsViewController(), animated: true)
    }
    
    @objc private func settingsLabelTapped(){
       // navigationController?.pushViewController( VC, animated: true)
    }
}
