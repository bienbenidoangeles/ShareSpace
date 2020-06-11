//
//  ChatVC.swift
//  ShareSpace
//
//  Created by Eric Davenport on 6/10/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Firebase

class ChatVC: UIViewController {
  
  private var chatView = ChatView()
  
  private var thread = [Message]() {
    didSet {
      chatView.chatCollection.reloadData()
      print(thread)
    }
  }
   override func loadView() {
     view = chatView
   }

    override func viewDidLoad() {
        super.viewDidLoad()
      chatView.chatCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "threadCell")
      chatView.chatCollection.dataSource = self
      listenerSetup()
      chatView.chatCollection.delegate = self
        // Do any additional setup after loading the view.
    }
  
  private func listenerSetup() {
    Firestore.firestore().collection("chats").document("tKSrjOIKouZgwyUItrO4").collection(DatabaseService.threadCollection).order(by: "created", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { (snapshot, error) in
      if let error = error {
        print("Error: \(error)")
        return
      } else {
        self.thread.removeAll()
        for message in snapshot!.documents {
          let msg = Message( message.data())
          self.thread.append(msg)
          print("Data: \(msg.content ?? "no message content found")")
        }
//        self.messagesCollectionView.reloadData()
//        self.messagesCollectionView.scrollToBottom(animated: true)
      }
    })

  }
    


}


extension ChatVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return thread.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "threadCell", for: indexPath)
    cell.backgroundColor = .white
    return cell
  }
  
  
}

extension ChatVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      let maxSize:CGSize = UIScreen.main.bounds.size
      let itemWidth:CGFloat = maxSize.width
      return CGSize(width: itemWidth, height: itemWidth)
  }
}
