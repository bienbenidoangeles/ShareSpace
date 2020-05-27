//
//  MainViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    private let mainView = MainView()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addNavSignOutButton()
        delegatesAndDataSources()
    }
    
    private func delegatesAndDataSources(){
        
    }
    
    
    private func addNavSignOutButton(){
        let barButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(signOutButtonPressed(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
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

}
