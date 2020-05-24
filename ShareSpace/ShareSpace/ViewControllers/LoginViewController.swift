//
//  LoginViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountState {
  case existingUser
  case newUser
}
class LoginViewController: UIViewController {

    private var accountState: AccountState = .existingUser
    
    private let loginView = LoginView()
    private lazy var errorLabel = loginView.errorLabel
    private lazy var loginButton = loginView.loginCreateButton
    private lazy var toggleAccStateButton = loginView.accountStateButton
    private lazy var emailTextField = loginView.emailTextField
    private lazy var passwordTextField = loginView.passwordTextField
    private lazy var containerView = loginView.containerView
    private lazy var accMsgLabel = loginView.accountMessageLabel
        
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonTargets()
        clearErrorLabel()
        delegatesAndDataSources()
    }
    
    private func delegatesAndDataSources(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func addButtonTargets(){
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        toggleAccStateButton.addTarget(self, action: #selector(toggleAccButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func loginButtonPressed(){
        guard let email = emailTextField.text,
          !email.isEmpty,
          let password = passwordTextField.text,
          !password.isEmpty else {
            errorLabel.text = "missing fields"
            errorLabel.textColor = .systemRed
            return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    @objc
    private func toggleAccButtonPressed(){
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        // animation duration
        let duration: TimeInterval = 1.0
        
        if accountState == .existingUser {
          UIView.transition(with: containerView, duration: duration, options: [.transitionFlipFromRight], animations: {
            self.loginButton.setTitle("Login", for: .normal)
            self.accMsgLabel.text = "Don't have an account ? Click"
            self.toggleAccStateButton.setTitle("SIGNUP", for: .normal)
          }, completion: nil)
        } else {
          UIView.transition(with: containerView, duration: duration, options: [.transitionFlipFromLeft], animations: {
            self.loginButton.setTitle("Sign Up", for: .normal)
            self.accMsgLabel.text = "Already have an account ?"
            self.toggleAccStateButton.setTitle("LOGIN", for: .normal)
          }, completion: nil)
        }
    }
    
    private func continueLoginFlow(email: String, password: String) {
      if accountState == .existingUser {
        AuthenticationSession.shared.signExistingUser(email: email, password: password) { [weak self] (result) in
          switch result {
          case .failure(let error):
            DispatchQueue.main.async {
              self?.errorLabel.text = "\(error.localizedDescription)"
              self?.errorLabel.textColor = .systemRed
            }
          case .success:
            DispatchQueue.main.async {
              self?.navigateToMainView()
            }
          }
        }
      } else {
        AuthenticationSession.shared.createNewUser(email: email, password: password) { [weak self] (result) in
          switch result {
          case .failure(let error):
            DispatchQueue.main.async {
              self?.errorLabel.text = "\(error.localizedDescription)"
              self?.errorLabel.textColor = .systemRed
            }
          case .success(let authDataResult):
            self?.createDatabaseUser(authDataResult: authDataResult)
          }
        }
      }
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
        DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult) { [weak self] (result) in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            self?.showAlert(title: "Account error", message: error.localizedDescription)
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
    
    private func clearErrorLabel() {
      errorLabel.text = ""
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
