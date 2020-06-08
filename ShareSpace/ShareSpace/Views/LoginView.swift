//
//  LoginView.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    public lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "ERROR"
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    public lazy var emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "email"
        textfield.textContentType = .emailAddress
        textfield.textAlignment = .center
        textfield.backgroundColor = .systemBackground
        return textfield
    }()
    
    public lazy var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "password"
        textfield.textContentType = .password
        textfield.textAlignment = .center
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = .systemBackground
        return textfield
    }()
    
    public lazy var loginCreateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.tintColor = .systemBackground
        button.titleLabel?.font = .systemFont(ofSize: 26, weight: .bold)
        button.backgroundColor = .systemGray
        return button
    }()
    
    public lazy var loginToggleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemBackground
        return stackView
    }()
    
    public lazy var accountMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "Don't have an account? Click"
        return label
    }()
    
    public lazy var accountStateButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGNUP", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        button.setTitleColor(.systemGray, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .systemBackground
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        errorLabelConstrainsts()
        emailTextFieldConstrainsts()
        containerViewContrainsts()
    }
    
    private func errorLabelConstrainsts(){
        addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func containerViewContrainsts(){
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        emailTextFieldConstrainsts()
        passwordTextFieldConstrainsts()
        loginCreateButtonConstrainsts()
        loginToggleStackViewConstrainsts()
    }
    
    private func emailTextFieldConstrainsts(){
        containerView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            emailTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func passwordTextFieldConstrainsts(){
        containerView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            passwordTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func loginCreateButtonConstrainsts(){
        containerView.addSubview(loginCreateButton)
        loginCreateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginCreateButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginCreateButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginCreateButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            loginCreateButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func loginToggleStackViewConstrainsts(){
        containerView.addSubview(loginToggleStackView)
        loginToggleStackView.addArrangedSubview(accountMessageLabel)
        loginToggleStackView.addArrangedSubview(accountStateButton)
        loginToggleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginToggleStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loginToggleStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            loginToggleStackView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.1),
            loginToggleStackView.topAnchor.constraint(equalTo: loginCreateButton.bottomAnchor, constant: 30)
        ])
    }

}
