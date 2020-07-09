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
    
    public var cvCellSize:CGSize?
    
    private var posts = [Post](){
        didSet{
            DispatchQueue.main.async {
                self.mainView.collectionView.reloadData()
            }
            if posts.isEmpty {
                mainView.collectionView.backgroundView = EmptyView(title: "No lisitings found", messege: "Why not search for some?")
            } else {
                mainView.collectionView.backgroundView = nil
            }
        }
    }
    
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet{
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
            if searchResults.isEmpty {
                mainView.collectionView.backgroundView = EmptyView(title: "Invalid Search", messege: "Why not try again?")
            } else {
                mainView.collectionView.backgroundView = nil
            }
        }
    }
    
    private var selectedResult: MKLocalSearchCompletion?
    
    private var searchCompletor: MKLocalSearchCompleter
    
    // private var selectedAnnotation: MKPointAnnotation?
    
    private var rootVC: RootViewController
    //private var searchVC: SearchResultsViewController
    weak var delegate: CardViewControllerDelegate?
    
    //    init(rootVC: RootViewController, searchResultsVC: SearchResultsViewController) {
    //        self.rootVC = rootVC
    //        self.searchVC = searchResultsVC
    //        super.init(nibName: nil, bundle: nil)
    //    }
    
    init(rootVC: RootViewController, searchCompletor: MKLocalSearchCompleter) {
        self.rootVC = rootVC
        self.searchCompletor = searchCompletor
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
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        delegatesAndDataSources()
        let coordinate = CoreLocationSession.shared.locationManager.location?.coordinate.toString
        let coorRang = (lat: 40.0...41.0, long: -75.0...(-74.0))
        //loadPosts(given: coorRang)
        registerCell()
        addNFCobservers()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(true)
    //        addNFCobservers()
    //    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func delegatesAndDataSources(){
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        //        guard let rootVC = self.parent as? RootViewController else {
        //            return
        //        }
        //
        //        self.rootVC = rootVC
        
        //searchVC.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        searchCompletor.delegate = self
        rootVC.delegate = self
        //addNFCobservers()
    }
    
    private func addNFCobservers(){
        NotificationCenterManager.shared.nfc.addObserver(self, selector: #selector(searchCompletorFragment(_:)), name: NotificationCenterManager.textFieldshouldChangeCharactersIn, object: nil)
        NotificationCenterManager.shared.nfc.addObserver(self, selector: #selector(getInitialResult(_:)), name: NotificationCenterManager.textFieldShouldReturn, object: nil)
        NotificationCenterManager.shared.nfc.addObserver(self, selector: #selector(textFieldBeganEditing(_:)), name: NotificationCenterManager.textFieldDidBeginEditing, object: nil)
        NotificationCenterManager.shared.nfc.addObserver(self, selector: #selector(searchButtonPressed(_:)), name: NotificationCenterManager.mapViewDidChangeVisibleRegion, object: nil)
    }
    
    private func removeNFCobservers(){
        NotificationCenterManager.shared.nfc.removeObserver(self, name: NotificationCenterManager.textFieldshouldChangeCharactersIn, object: nil)
        NotificationCenterManager.shared.nfc.removeObserver(self, name: NotificationCenterManager.textFieldShouldReturn, object: nil)
        NotificationCenterManager.shared.nfc.removeObserver(self, name: NotificationCenterManager.textFieldDidBeginEditing, object: nil)
        NotificationCenterManager.shared.nfc.removeObserver(self, name: NotificationCenterManager.mapViewDidChangeVisibleRegion, object: nil)
    }
    
    //  private var databaseServices = DatabaseService.shared
    @objc private func textFieldBeganEditing(_ notification: NSNotification){
        hideTableViewButNotCV(false)
    }
    
    @objc private func searchCompletorFragment( _ notification: NSNotification){
        if let queryFrag = notification.userInfo?[NotificationCenterManager.textFieldshouldChangeCharactersIn] as? String {
            searchCompletor.queryFragment = queryFrag
            hideTableViewButNotCV(false)
        }
    }
    
    @objc private func getInitialResult(_ notification: NSNotification){
        guard let searchResult = searchResults.first else {
            return
        }
        getRegion(localSearch: searchResult)
        hideTableViewButNotCV(true)
    }
    
    @objc private func searchButtonPressed(_ notification: NSNotification){
        hideTableViewButNotCV(true)
    }
    
    private func hideTableViewButNotCV(_ temp : Bool) {
        if mainView.collectionView.isHidden == true && mainView.tableView.isHidden == true {
            return
        }
        mainView.tableView.isHidden = temp
        cv.isHidden = !temp
    }
    
    private func callDelegate(region: MKCoordinateRegion?, coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)){
        if let region = region {
            self.delegate?.postsFoundFromSearchBar(posts: self.posts , coordinateRange: coordinateRange, region: region)
        } else {
            self.delegate?.postsFoundFromMapView(posts: self.posts , coordinateRange: coordinateRange)
        }
    }
    
    private func loadPosts(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>), region: MKCoordinateRegion? = nil) {
        
        guard let selfId = AuthenticationSession.shared.auth.currentUser?.uid else {
            return
        }
        
        DatabaseService.shared.loadPosts(coordinateRange: coordinateRange) {[weak self] (result) in
            switch result {
            case .failure(let error):
                self?.rootVC.showAlert(title: error.localizedDescription, message: nil)
            case .success(let posts):
                guard let posts = posts, !posts.isEmpty else {
                    self?.posts.removeAll() // have an empty view
                    self?.callDelegate(region: region, coordinateRange: coordinateRange)
                    self?.hideTableViewButNotCV(true)
                    return
                }
                DatabaseService.shared.loadUser(userId: selfId) { (result) in
                    switch result {
                    case .failure(let error):
                        self?.rootVC.showAlert(title: error.localizedDescription, message: nil)
                    case .success(let user):
                        guard let blockedUsers = user.blockedUsers else {
                            return
                        }
                        let postsWOBlockedUser = posts.filter{!blockedUsers.contains($0.userId)}
                        self?.hideTableViewButNotCV(true)
                        self?.posts = postsWOBlockedUser
                        self?.callDelegate(region: region, coordinateRange: coordinateRange)
                    }
                }
                
                
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
    
    func getRegion(localSearch: MKLocalSearchCompletion){
        CoreLocationSession.shared.getMKRegion(given: localSearch) { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "GeoCoder Error", message: error.localizedDescription)
            case .success(let region):
                let coordinate = region.center
                let latDelta = region.span.latitudeDelta
                let longDelta = region.span.longitudeDelta
                let searchTitle = localSearch.title
                let searchSubtitle = localSearch.subtitle
                guard let firstCharOfTitle = searchTitle.first else { return }
                let searchResult = searchSubtitle.isEmpty || !firstCharOfTitle.isNumber ? searchTitle : searchTitle + " " + searchSubtitle
                let latLower = coordinate.latitude-latDelta
                let latUpper = coordinate.latitude+latDelta
                let longLower = coordinate.longitude-longDelta
                let longUpper = coordinate.longitude+longDelta
                
                let coorRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>) = (lat: latLower...latUpper, long:longLower...longUpper)
                
                self?.loadPosts(given: coorRange, region: region)
                //self?.hideTableViewButNotCV(true)
            }
        }
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
        cell.delegate = self
        return cell
    }
}

extension CardViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxSize:CGSize = UIScreen.main.bounds.size
        let itemWidth:CGFloat = maxSize.width
        let itemHeight:CGFloat = itemWidth*0.25
        let cellSize = CGSize(width: itemWidth, height: itemHeight)
        cvCellSize = cellSize
        return cellSize
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //scroll view dragging
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}

extension CardViewController: RootViewControllerDelegate{
    func annontationPressed(given annotation: MKPointAnnotation, cardState: Int) {
        //selectedAnnotation = annotation
        let coordinate = annotation.coordinate
        let postIndex = posts.firstIndex{$0.coordinate == coordinate} ?? 0
        
        let indexPath = IndexPath(row: postIndex, section: 0)
        hideTableViewButNotCV(true)
        cv.selectItem(at: indexPath, animated: true, scrollPosition: cardState == 0 ? .left : .top)
    }
    
    func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        loadPosts(given: coordinateRange)
    }
    
    
}

extension CardViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuery = searchResults[indexPath.row]
        getRegion(localSearch: selectedQuery)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        rootVC.rootView.searchLabel.resignFirstResponder()
    }
}

extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
}

extension CardViewController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //handle error
        showAlert(title: "SearchCompleter Error", message: error.localizedDescription)
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

extension CardViewController: AccessoryButtonDelegate {
    func showActionSheetOptions(selectedPost: Post) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (action) in
            
            let alertVC = UIAlertController(title: "Why would you like to report this listing?", message: nil, preferredStyle: .alert)
            alertVC.addTextField { (tf) in
                tf.placeholder = "Explain here"
            }
            let okAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
                //let report = Report(reportText: alertVC.textFields?.first?.text)
                Report.reportUser(userId: selectedPost.userId) { (result) in
                    switch result {
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    case .success:
                        self.showAlert(title: "Item reported", message: nil)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actions = [okAction, cancelAction]
            actions.forEach{alertVC.addAction($0)}
            self.present(alertVC, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actions = [reportAction, cancelAction]
        actions.forEach{actionSheet.addAction($0)}
        present(actionSheet, animated: true, completion: nil)
    }
}
