//
//  MyPostsReservationsViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/16/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FirebaseAuth
//import FirebaseStorage
//import Kingfisher

enum ViewState {
    case myPosts
    case myReservations
    case reservedByMe
}

class MyPostsReservationsViewController: UIViewController {
    
    private var prView = MyPostsReservationsView()
    
    override func loadView() {
        view = prView
    }
    
    private var viewState: ViewState = .myPosts {
        didSet {
            prView.postsReservationsCV.reloadData()
        }
    }
    
    private var myPosts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.prView.postsReservationsCV.reloadData()
            }
        }
    }
    
    private var myReservations = [Reservation]() {
        didSet {
            DispatchQueue.main.async {
                self.prView.postsReservationsCV.reloadData()
            }
        }
    }
    
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Collections"
        
        view.backgroundColor = .systemGroupedBackground
        
       refreshControl = UIRefreshControl()
        prView.postsReservationsCV.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        configureCollectionView()
       // loadData()
        segmentedControllChanged()
    }
    private func configureCollectionView() {
        prView.postsReservationsCV.register(ProgrammaticPostReservationCell.self, forCellWithReuseIdentifier: "postReservationCell")
        prView.postsReservationsCV.delegate = self
        prView.postsReservationsCV.dataSource = self
    }
    
    @objc private func loadData() {
         fetchPosts()
         fetchReservations()
     }
     
     @objc private func fetchPosts() {
         guard let user = Auth.auth().currentUser else {
             refreshControl.endRefreshing()
             return
         }
         DatabaseService.shared.loadPosts(userId: user.uid) { [weak self](result) in
             switch result {
             case .failure(let error):
                 DispatchQueue.main.async {
                     self?.showAlert(title: "error loading posts", message: error.localizedDescription)
                 }
             case .success(let myPosts):
                 guard let myPosts = myPosts else {
                     return
                 }
                 self?.myPosts = myPosts
             }
             DispatchQueue.main.async {
                 self?.refreshControl.endRefreshing()
             }
         }
     }
     private func fetchReservations() {
         guard let user = Auth.auth().currentUser else {
             refreshControl.endRefreshing()
             return
         }
         DatabaseService.shared.loadReservations(renterId: user.uid) {[weak self] (result) in
             switch result {
             case .failure(let error):
                 DispatchQueue.main.async {
                     self?.showAlert(title: "error loading reservations", message: error.localizedDescription)
                 }
             case .success(let myReservations):
                 guard let myreservations = myReservations else {
                     return
                 }
                 self?.myReservations = myreservations
             }
         }
     }
    
     
    
    private func segmentedControllChanged() {
        prView.segmentedControl.addTarget(self, action: #selector(segmentedControl(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewState = .myPosts
        case 1:
            viewState = .myReservations
        case 2:
            viewState = .reservedByMe
        default:
            break
        }
    }
    
}

extension MyPostsReservationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if viewState == .myPosts {
                 return myPosts.count
         } else if viewState == .myReservations {
        }
        return myReservations.count
             
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postReservationCell", for: indexPath) as? ProgrammaticPostReservationCell else {
             fatalError("Could not downcase to ProgrammaticPostReservationCell")
         }
         if viewState == .myPosts {
         let myPost = myPosts[indexPath.row]
         cell.configureCell(for: myPost)
         } else {
             let reservation = myReservations[indexPath.row]
             cell.configureCell(for: reservation)
         }
         cell.backgroundColor = .white
         return cell
    }
    
    
}
extension MyPostsReservationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = prView.safeAreaLayoutGuide.layoutFrame.size
        let itemWidth = maxSize.width
        let itemHeight = maxSize.height * 0.50
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
    }
    
    
}
