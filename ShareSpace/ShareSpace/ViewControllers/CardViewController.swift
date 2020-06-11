//
//  MainViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

class CardViewController: UIViewController {
    
    private let mainView = CardView()
    
    public lazy var handleArea = mainView.topView
    
    public lazy var cv = mainView.collectionView
    
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
        delegatesAndDataSources()
        let coordinate = CoreLocationSession.shared.locationManager.location?.coordinate.toString
        let coorRang = (lat: 0...1.5, long: 0...1.5)
        loadPost(given: coorRang)
        registerCell()
    }
    
    private func delegatesAndDataSources(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        guard let rootVC = self.parent as? RootViewController else {
            return
        }
        rootVC.delegate = self
    }
  
//  private var databaseServices = DatabaseService.shared
  
  
    private func loadPost(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        
        DatabaseService.shared.loadPosts(coordinateRange: coordinateRange) { (result) in
      switch result {
      case .failure(let error):
        print("It failed")
      case .success(let posts):
        guard let posts = posts else {
            return // have an empty view
        }
        self.posts = posts
      }
    }
        
//        for _ in 0...9{
//            let genPost = Post.generatePostAsDict()
//            DatabaseService.shared.postSpace(post: genPost) { (result) in
//                switch result{
//                case .failure:
//                    break
//                case .success:
//                    let location = genPost["location"] as? [String:Any]
//                    DatabaseService.shared.createDBLocation(location:  location!) { (result) in
//                        switch result{
//                        case .failure:
//                            break
//                        case.success(let locId):
//                            //print(locId)
//                            break
//                        }
//                    }
//                }
//            }
//        }
    
  }
    
    private func registerCell(){
        mainView.collectionView.register(UINib(nibName: "CollapsedCell", bundle: nil), forCellWithReuseIdentifier: "collapsedFeedCell")
    }

}

extension CardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainView.collectionView.dequeueReusableCell(withReuseIdentifier: "collapsedFeedCell", for: indexPath) as? FeedCollapsedCell else {
            fatalError()
        }
        let post = posts[indexPath.row]
        cell.configureCell(for: post)
        return cell
    }
}

extension CardViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize:CGSize = UIScreen.main.bounds.size
        let itemWidth:CGFloat = maxSize.width
        let itemHeight:CGFloat = itemWidth*0.25
        return CGSize(width: itemWidth, height: itemHeight)
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

extension CardViewController: SearchPostDelegate{
    func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        loadPost(given: coordinateRange)
    }
    
    func readPostsFromSearchBar(given coordinate: [CLLocationCoordinate2D]) {
        
    }
}
