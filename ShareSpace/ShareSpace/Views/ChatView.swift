//
//  ChatView.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/10/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class ChatView: UIView {
  
  public lazy var headView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()

  public lazy var chatCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.backgroundColor = .green
    return cv
  }()
  
  public lazy var messageView: UIView = {
    let mv = UIView()
    mv.backgroundColor = .white
    return mv
  }()
  
  public lazy var textField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "enter message"
    tf.borderStyle = .bezel
    tf.returnKeyType = .send
    tf.backgroundColor = .orange
    
    return tf
  }()
  
  public lazy var sendButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
    button.setImage(UIImage(systemName: "paperplane"), for: .selected)
//    button.contentMode = .bottomRight
    return button
  }()
    
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    setupConstraints()
  }
  
  private func cvConstraints() {
    addSubview(chatCollection)
    chatCollection.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      chatCollection.topAnchor.constraint(equalTo: headView.bottomAnchor),
      chatCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
      chatCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
      chatCollection.bottomAnchor.constraint(equalTo: messageView.topAnchor)
    ])
  }
  
  private func headerConstraints() {
    addSubview(headView)
    headView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      headView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      headView.leadingAnchor.constraint(equalTo: leadingAnchor),
      headView.trailingAnchor.constraint(equalTo: trailingAnchor),
      headView.heightAnchor.constraint(equalToConstant: 100)
    ])
  }
  
  private func stackViewConstraints() {
    messageView.addSubview(textField)
    messageView.addSubview(sendButton)
    addSubview(messageView)
    messageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageView.heightAnchor.constraint(equalToConstant: 45),
      messageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      messageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      messageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
    
  }
  
  


}

extension ChatView {
  private func setupConstraints() {
    headerConstraints()
    mesageViewConstraints()
    cvConstraints()
  }
  
  private func mesageViewConstraints() {
    messageView.addSubview(textField)
    messageView.addSubview(sendButton)
    addSubview(messageView)
    textField.translatesAutoresizingMaskIntoConstraints = false
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    messageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageView.heightAnchor.constraint(equalToConstant: 45),
      messageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      messageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      messageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      textField.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 3),
      textField.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 3),
      textField.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 3),
      textField.widthAnchor.constraint(equalToConstant: 350),
      sendButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -3),
      sendButton.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -3),
      sendButton.widthAnchor.constraint(equalToConstant: 45),
      sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)
    ])
  }
}
