//
//  MainViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

protocol CardViewControllerDelegate: AnyObject {
    func postsFoundFromMapView(posts:[Post], coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>))
    //func postsFound(posts:[Post], geoHash: String, geoHashNeighbors: [String]?)
    func postsFoundFromSearchBar(posts:[Post], coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>), region: MKCoordinateRegion)
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
            if posts.isEmpty {
                mainView.collectionView.backgroundView = EmptyView(title: "No posts found", messege: "Why no search for some?")
            } else {
                mainView.collectionView.backgroundView = nil
            }
        }
    }
    
    private var rootVC: RootViewController
    private var searchVC: SearchResultsViewController
    weak var delegate: CardViewControllerDelegate?
    
    init(rootVC: RootViewController, searchResultsVC: SearchResultsViewController) {
        self.rootVC = rootVC
        self.searchVC = searchResultsVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
//        guard let rootVC = self.parent as? RootViewController else {
//            return
//        }
//
//        self.rootVC = rootVC
        
        searchVC.delegate = self
        rootVC.delegate = self
    }
    
    //  private var databaseServices = DatabaseService.shared
    
    
    private func callDelegate(region: MKCoordinateRegion?, coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)){
        if let region = region {
            self.delegate?.postsFoundFromSearchBar(posts: self.posts , coordinateRange: coordinateRange, region: region)
        } else {
            self.delegate?.postsFoundFromMapView(posts: self.posts , coordinateRange: coordinateRange)
        }
    }
    
    private func loadPosts(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>), region: MKCoordinateRegion? = nil) {
        
        DatabaseService.shared.loadPosts(coordinateRange: coordinateRange) {[weak self] (result) in
            switch result {
            case .failure(let error):
                self?.rootVC.showAlert(title: error.localizedDescription, message: nil)
            case .success(let posts):
                guard let posts = posts, !posts.isEmpty else {
                    self?.posts.removeAll() // have an empty view
                    self?.callDelegate(region: region, coordinateRange: coordinateRange)
                    return
                }
                self?.posts = posts
                self?.callDelegate(region: region, coordinateRange: coordinateRange)
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
    
    //    private func loadPosts(given fulladdress: String, geoHash: String, geoHashNeighbors: [String]?){
    //        //Call on db func
    //        self.delegate?.postsFound(posts: posts, geoHash: geoHash, geoHashNeighbors: geoHashNeighbors)
    //    }
    
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

extension CardViewController: RootViewControllerDelegate{
    func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        loadPosts(given: coordinateRange)
    }
}

extension CardViewController: SearchResultsViewControllerDelegate{
    func readPostsFromSearchBar(given coordinate: CLLocationCoordinate2D, searchResult: String, region: MKCoordinateRegion?) {
        guard let region = region else { return }
        let range = CoreLocationSession.shared.getRegionDetails(region: region)
        loadPosts(given: range, region: region)
    }
    
    //    func readPostsFromSearchBar(given coordinate: CLLocationCoordinate2D, searchResult: String) {
    ////        let geoHash = Geohash.encode(latitude: coordinate.latitude, longitude: coordinate.longitude)
    ////        let geoHashNeighbors = Geohash.neighbors(geoHash)
    //        let latLower = coordinate.latitude-1.0
    //        let latUpper = coordinate.latitude+1.0
    //        let longLower = coordinate.longitude-1.0
    //        let longUpper = coordinate.longitude+1.0
    //
    //        let coorRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>) = (lat: latLower...latUpper, long:longLower...longUpper)
    //        loadPosts(given: coorRange)
    //    }
}
