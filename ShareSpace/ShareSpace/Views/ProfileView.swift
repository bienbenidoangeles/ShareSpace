//
//  ProfileView.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/27/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    lazy var contentViewSize = CGSize(width: self.frame.width, height: self.frame.height + 400)
    
    // FIXME: Scroll view
        public lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.backgroundColor = .white
            scrollView.frame = self.bounds
            scrollView.contentSize = contentViewSize
            scrollView.autoresizingMask = .flexibleHeight
            scrollView.showsHorizontalScrollIndicator = true
            scrollView.bounces = true
            return scrollView
        }()
    
//    lazy var scrollView: UIScrollView = {
//            let view = UIScrollView(frame: .zero)
//            view.backgroundColor = .white
//            view.frame = self.view.bounds
//            view.contentSize = contentViewSize
//            view.autoresizingMask = .flexibleHeight
//            view.showsHorizontalScrollIndicator = true
//            view.bounces = true
//            return view
//        }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()
    
    override func layoutSubviews() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layoutSubviews()
        imageView.backgroundColor = .systemOrange
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    public lazy var editProfileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.tintColor = .systemOrange
        return button
    }()
    
    public lazy var userDisplayNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter username"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userNameTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your first and last name"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userPhoneNumberTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your phone number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email"
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    public lazy var userBioTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Type your bio"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userOccupationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your occupation"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var governmentIdTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter government ID name and number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userCreditcardTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your credit ot debit card number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userCreditcardCVVNumberTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your card CVV number"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var userExpirationDateTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter your card expiration date"
        textfield.textAlignment = .left
        return textfield
    }()
    
    public lazy var uploadIdButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload ID", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    //FIXME: fix the size of imageview
    public lazy var idImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        //imageView.layoutSubviews()
        imageView.backgroundColor = .systemGray3
        return imageView
    }()
    
    public lazy var saveChangesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.backgroundColor = .systemYellow
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame:UIScreen.main.bounds)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        commomInit()
    }
    
    private func commomInit() {
        // setUpScrollviewConstraints()
        setUpProfileImageViewConstraints()
        setUpEditProfileImageButtonConstraints()
        setUpStackViewTextFieldConstraints()
        setUpSaveChangesButtonConstraints()
    }
    
        private func setUpScrollviewConstraints() {
            addSubview(scrollView)
            scrollView.addSubview(containerView)
            
            containerView.addSubview(stackView)
            
            scrollView.translatesAutoresizingMaskIntoConstraints =  false
    
            NSLayoutConstraint.activate([
    
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
                scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            ])
        }
    
    /*

     class ViewController: UIViewController {

         override func viewDidLoad() {
             super.viewDidLoad()

             view.addSubview(scrollView)
             scrollView.addSubview(scrollViewContainer)
             scrollViewContainer.addArrangedSubview(redView)
             scrollViewContainer.addArrangedSubview(blueView)
             scrollViewContainer.addArrangedSubview(greenView)

             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
             scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
             scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

             scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
             scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
             scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
             scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
             // this is important for scrolling
             scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
         }

         let scrollView: UIScrollView = {
             let scrollView = UIScrollView()

             scrollView.translatesAutoresizingMaskIntoConstraints = false
             return scrollView
         }()

         let scrollViewContainer: UIStackView = {
             let view = UIStackView()

             view.axis = .vertical
             view.spacing = 10

             view.translatesAutoresizingMaskIntoConstraints = false
             return view
         }()

         let redView: UIView = {
             let view = UIView()
             view.heightAnchor.constraint(equalToConstant: 500).isActive = true
             view.backgroundColor = .red
             return view
         }()

         let blueView: UIView = {
             let view = UIView()
             view.heightAnchor.constraint(equalToConstant: 200).isActive = true
             view.backgroundColor = .blue
             return view
         }()

         let greenView: UIView = {
             let view = UIView()
             view.heightAnchor.constraint(equalToConstant: 1200).isActive = true
             view.backgroundColor = .green
             return view
         }()
     }
     */
    
    private func setUpProfileImageViewConstraints() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            profileImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.32)
        ])
    }
    
    private func setUpEditProfileImageButtonConstraints() {
        addSubview(editProfileImageButton)
        editProfileImageButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            editProfileImageButton.topAnchor.constraint(equalTo:  safeAreaLayoutGuide.topAnchor, constant: 120),
            editProfileImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -140),
        ])
    }
    
    private func setUpStackViewTextFieldConstraints() {
        addSubview(stackView)
        stackView.addArrangedSubview(userDisplayNameTextfield)
        stackView.addArrangedSubview(userNameTextfield)
        stackView.addArrangedSubview(userPhoneNumberTextfield)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(userBioTextfield)
        stackView.addArrangedSubview(userOccupationTextfield)
        stackView.addArrangedSubview(governmentIdTextfield)
        stackView.addArrangedSubview(uploadIdButton)
        stackView.addArrangedSubview(idImageView)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardTextfield)
        stackView.addArrangedSubview(userCreditcardCVVNumberTextfield)
        stackView.addArrangedSubview(userExpirationDateTextfield)
        
        stackView.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpSaveChangesButtonConstraints() {
        addSubview(saveChangesButton)
        saveChangesButton.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            saveChangesButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            saveChangesButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

/*
 import TinyConstraints

 class SimpleRootViewController: UIViewController {
     
     // MARK: - Proterties
     
     lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
     
     // MARK: - Views
     
     lazy var scrollView: UIScrollView = {
         let view = UIScrollView(frame: .zero)
         view.backgroundColor = .white
         view.frame = self.view.bounds
         view.contentSize = contentViewSize
         view.autoresizingMask = .flexibleHeight
         view.showsHorizontalScrollIndicator = true
         view.bounces = true
         return view
     }()
     
     lazy var containerView: UIView = {
         let view = UIView()
         view.backgroundColor = .white
         view.frame.size = contentViewSize
         return view
     }()
     
     lazy var label: UILabel = {
         let label = UILabel()
         label.text = "Center of container view"
         return label
     }()
     
     // MARK: - View Controller Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         // Do any additional setup after loading the view, typically from a nib.
         view.backgroundColor = .white
         
         view.addSubview(scrollView)
         scrollView.addSubview(containerView)
         
         containerView.addSubview(label)
         
         label.center(in: containerView)
         
     }


 }
 */
