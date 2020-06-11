//
//  MainViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: NavBarViewController {
    
    private let mainView = MainView()
    
    private var posts = [Post](){
        didSet{
            DispatchQueue.main.async {
                self.mainView.collectionView.reloadData()
            }
        }
    }

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addNavSignOutButton()
      addChatButton()
        delegatesAndDataSources()
      loadPost()
        registerCell()
      print(Auth.auth().currentUser?.uid)
    }
    
    private func delegatesAndDataSources(){

        
mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
  
//  private var databaseServices = DatabaseService.shared
  
  
  private func loadPost() {
    DatabaseService.shared.loadPost { (result) in
      switch result {
      case .failure(let error):
        print("It failed")
      case .success(let post):
        self.posts = post
      }
    }
  }
  
  

        
    
    
    private func registerCell(){
        mainView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "feedCell")
    }

    
    private func addNavSignOutButton(){
        let barButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(signOutButtonPressed(_:)))
        navigationItem.rightBarButtonItems?.append(barButtonItem)
    }
  private func addChatButton(){
       let barButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: self, action: #selector(loadChatList))
       navigationItem.rightBarButtonItems?.append(barButtonItem)
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
  
  @objc private func loadChatList() {
    let chatList = ChatListViewController(nibName: nil, bundle: nil)
    navigationController?.pushViewController(chatList, animated: true)
  }

}



extension MainViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            fatalError()
        }
        let post = posts[indexPath.row]
        cell.configureCell(for: post)
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize:CGSize = UIScreen.main.bounds.size
        let itemWidth:CGFloat = maxSize.width
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    // ADDED BY ME LET BIEN KNOW
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aPost = posts[indexPath.row]
        let storyboard = UIStoryboard(name: "ListingDetail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "ListingDetailViewController") { (coder) in
            return ListingDetailViewController(coder: coder, selectedPost: aPost)
        }
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}
