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
  
  var message: Message! {
    didSet {
      updateUI()
    }
  }
  
  var leadingConstraint: NSLayoutConstraint!
  var trailingConstraint: NSLayoutConstraint!
  
  var incomeDateConstraints: NSLayoutConstraint!
  var outgoingDateConstraint: NSLayoutConstraint!
  
  var isIncoming: Bool! {
    didSet {
      messageBackgroundView.backgroundColor = isIncoming ? .yummyOrange : .white
      messageLabel.textColor = isIncoming ? .white : .yummyOrange
    }
  }
  
  public lazy var messageLabel: UILabel = {
    let label = UILabel()
    label.text = "Message here is needed to use ehway hedkfh it should be allowed to extende the cell further down because the number of lines will be set to zero. TYhere words are just so the string has a lot in side of it"
    label.numberOfLines = 0
    return label
  }()
  
  public lazy var messageBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .orange
    return view
  }()
  
  public lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .footnote)
    label.text = "date label here"
    return label
  }()
  

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupConstraints()
  }
  
  private func updateUI() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm a"
    let dateString = dateFormatter.string(from: message.created.dateValue())
    self.dateLabel.text = dateString
  }
 
  
}



extension ChatCell {
  private func setupConstraints() {
    addSubview(messageBackgroundView)
    addSubview(messageLabel)
    addSubview(dateLabel)
    messageLabelConstraints()
    bkViewConstraints()
    dateLabelConstraints()
  }

  private func bkViewConstraints() {
    messageBackgroundView.layer.cornerRadius = 10
    messageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
      messageBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
      messageBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
      messageBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16)

    ])
  }

  private func messageLabelConstraints() {
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
      messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
    ])
    
    leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
    leadingConstraint.isActive = false
    
    trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    trailingConstraint.isActive = true
  }
  
  private func dateLabelConstraints() {
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: messageBackgroundView.bottomAnchor, constant: 4),
      dateLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: 0)
    ])
    incomeDateConstraints = dateLabel.trailingAnchor.constraint(equalTo: messageBackgroundView.trailingAnchor, constant: 0)
    incomeDateConstraints.isActive = true
    
    outgoingDateConstraint = dateLabel.leadingAnchor.constraint(equalTo: messageBackgroundView.leadingAnchor, constant: 0)
    outgoingDateConstraint.isActive = false
  }
  
  

}
