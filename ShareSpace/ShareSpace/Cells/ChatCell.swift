//
//  ChatCell.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/15/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase

class ChatCell: UITableViewCell {
  
  //  @IBOutlet weak var usernameLabel: UILabel!
  public lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "userName Label"
    return label
  }()
  
  //  @IBOutlet weak var messageLabel: UILabel!
  public lazy var messageLabel: UILabel = {
    let label = UILabel()
    label.text = "mesage text here"
    return label
  }()
  
  //  @IBOutlet weak var dateLabel: UILabel!
  public lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.text = "date label"
    return label
  }()
  
  //  @IBOutlet weak var leftView: UIView!
  public lazy var leftView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemRed
    return view
  }()
  
  //  @IBOutlet weak var rightView: UIView!
  public lazy var rightView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBlue
    return view
  }()
  
  public lazy var topStackView: UIStackView = {
    let sv = UIStackView()
    sv.alignment = .fill
    sv.distribution = .fill
    sv.spacing = 8
    sv.axis = .horizontal
    sv.backgroundColor = .gray
    return sv
  }()
  
  public lazy var innerStackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.alignment = .fill
    sv.distribution = .fill
    sv.spacing = 8
    sv.backgroundColor = .green
    return sv
  }()
  
  public var message: Message? {
    didSet {
//      print("cell message: \(message?.content)")
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    setupConstraints()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //        setupCell()
//    configureCell()
    //    self.setNeedsLayout()
    //    self.layoutIfNeeded()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  public func setupCell() {
    guard let currentUser = Auth.auth().currentUser else { return }
    if self.message?.senderID == currentUser.uid {
      usernameLabel.textAlignment = .right
      dateLabel.textAlignment = .right
      messageLabel.textAlignment = .right
      rightView.isHidden = true
    } else if self.message?.senderID != currentUser.uid {
      usernameLabel.textAlignment = .left
      dateLabel.textAlignment = .left
      messageLabel.textAlignment = .left
      leftView.isHidden = true
    }
  }
  
  public func configureCell(_ msg: Message) {
//    guard let msg = message else { return }
//    print("configure cell: \(msg.senderID)")
    self.usernameLabel.text = msg.senderName
    self.messageLabel.text = msg.content
    self.dateLabel.text = "06/07/20"
    self.backgroundColor = .systemGroupedBackground
  }
  
}



extension ChatCell {
  private func setupConstraints() {
    leftViewConstraints()
    topStackConstaints()
    innerStackSetUp()
  }
  
  private func topStackConstaints() {
    addSubview(topStackView)
    topStackView.addArrangedSubview(leftView)
    topStackView.addArrangedSubview(innerStackView)
    topStackView.addArrangedSubview(rightView)
    topStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topStackView.topAnchor.constraint(equalTo: self.topAnchor),
      topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      topStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  private func innerStackSetUp() {
    innerStackView.addArrangedSubview(usernameLabel)
    innerStackView.addArrangedSubview(messageLabel)
    innerStackView.addArrangedSubview(dateLabel)
    innerStackView.translatesAutoresizingMaskIntoConstraints = false
    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
    
    ])
  }
  
  private func leftViewConstraints() {
    NSLayoutConstraint.activate([
      leftView.widthAnchor.constraint(equalToConstant: 20),
      rightView.widthAnchor.constraint(equalToConstant: 20)
    ])
  }
  
  private func rightViewConstraints() {
    
  }
}
