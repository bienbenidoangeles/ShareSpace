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
    @objc let sharedAppStateInstance = AppState.shared
    
    override func loadView() {
        view = sideBarView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNavButtons()
    }
    
    private func updateUI(){
        sharedAppStateInstance.addObserver(self, forKeyPath: #keyPath(sharedAppStateInstance.userType), options: [.old, .new], context: nil)
//        sharedAppStateInstance.observe(\.userType) {[weak self] (appState, change) in
//            if appState.userType != .guest{
//                self?.sideBarView.loginLabel.text = "Logout"
//            } else {
//                self?.sideBarView.loginLabel.text = "Login"
//            }
//        }
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
        
        //sideBarView.loginLabel.addGestureRecognizer(<#T##gestureRecognizer: UIGestureRecognizer##UIGestureRecognizer#>)
    }
    
    @objc private func sideBarTapped(_ recognizer: UITapGestureRecognizer){
        navigationController?.fadeAway()
    }
    
    @objc private func loginLabelTapped(_ recognizer: UITapGestureRecognizer, label: UILabel){
        if AppState.shared.getAppState() != .guest {
            do {
                try AuthenticationSession.shared.logout()
                UIViewController.showViewController(viewcontroller: LoginViewController())
            } catch {
                
            }
            
        } else {
            
        }
    }

}
