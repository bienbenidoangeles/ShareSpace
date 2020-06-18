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

protocol CardViewControllerDelegate: AnyObject {
    func postsFound(posts:[Post], coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>))
}

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
    
    private var rootVC: RootViewController?
    weak var delegate: CardViewControllerDelegate?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        delegatesAndDataSources()
        let coordinate = CoreLocationSession.shared.locationManager.location?.coordinate.toString
        let coorRang = (lat: 40.0...41.0, long: -75.0...(-74.0))
        //loadPosts(given: coorRang)
        registerCell()
    }
    
    private func delegatesAndDataSources(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        guard let rootVC = self.parent as? RootViewController else {
            return
        }
        
        self.rootVC = rootVC
        rootVC.delegate = self
    }
    
    //  private var databaseServices = DatabaseService.shared
    
    
    private func loadPosts(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        
        DatabaseService.shared.loadPosts(coordinateRange: coordinateRange) { (result) in
            switch result {
            case .failure(let error):
                print("It failed")
            case .success(let posts):
                guard let posts = posts, !posts.isEmpty else {
                    self.posts.removeAll() // have an empty view
                    self.delegate?.postsFound(posts: self.posts, coordinateRange: coordinateRange)
                    return
                }
                self.posts = posts
                self.delegate?.postsFound(posts: posts, coordinateRange: coordinateRange)
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
    
    private func loadPosts(given fulladdress: String, coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)){
        //Call on db func
        self.delegate?.postsFound(posts: posts, coordinateRange: coordinateRange)
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
    func readPostsFromSearchBar(given coordinate: CLLocationCoordinate2D, searchResult: String) {
        
    }
    
    func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        loadPosts(given: coordinateRange)
    }
}
