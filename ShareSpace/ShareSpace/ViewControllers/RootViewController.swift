//
//  RootViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MapKit

protocol RootViewControllerDelegate: AnyObject {
    func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>))
    func annontationPressed(given annotation: MKPointAnnotation, cardState: Int)
}

class RootViewController: NavBarViewController {
    private let locationSession = CoreLocationSession.shared.locationManager
    
    let rootView = RootView()
    
    private lazy var mapView = rootView.mapView
    //lazy var tabBarheight:CGFloat = self.tabBarController!.tabBar.frame.size.height
    private lazy var navBarHeight:CGFloat = self.navigationController!.navigationBar.frame.size.height
    private lazy var searchBarHeight:CGFloat = self.rootView.searchBarView.frame.size.height
    private lazy var searchThisAreaHeight = rootView.searchByMapViewButton.frame.size.height
    private lazy var safeAreaHeight = view.frame.size.height
    private lazy var totalHeight =  navBarHeight + searchBarHeight + searchThisAreaHeight
    
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardVC: CardViewController!
    
    var visualEffectView: UIVisualEffectView!
    
    let screenWidth = UIScreen.main.bounds.width
    
    private lazy var collaspedCardSize:CGSize = cardVC.cvCellSize ?? CGSize(width: screenWidth, height: screenWidth * 0.25)
    let expandedCardHeight:CGFloat = 600
    private lazy var expandedCardSize: CGSize = CGSize(width: screenWidth, height: expandedCardHeight)
    
    let cardHandleAreaHeight: CGFloat = 30
    
    var cardVisible = false
    
    weak var delegate: RootViewControllerDelegate?
    
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    private lazy var topRightCoor = rootView.mapView.convert(CGPoint(x: rootView.mapView.bounds.width, y: 0), toCoordinateFrom: rootView.mapView)
    private lazy var bottomLeftCoor = rootView.mapView.convert(CGPoint(x: 0, y: rootView.mapView.bounds.height), toCoordinateFrom: rootView.mapView)
    
    //private var searchVC: SearchResultsViewController?
    
    override func loadView() {
        super.loadView()
        view = rootView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        addTargets()
        setupCard()
        setupMap()
        addNavButtons()
        //setupGestures()
        print(
            """
            navBarHeight \(navBarHeight)
            searchBarHeight \(searchBarHeight)
            searchThisAreaHeight \(searchThisAreaHeight)
            safeAreaHeight \(safeAreaHeight)
            totalHeight \(totalHeight)
            cardHeight \(expandedCardHeight)
            """
        )
    }
    
    private func delegatesAndDataSources(){
        rootView.mapView.delegate = self
        rootView.searchLabel.delegate = self
        let searchCompletor =  CoreLocationSession.shared.searchCompletor
        //let searchVC = SearchResultsViewController(searchCompletor: searchCompletor)
        //self.searchVC = searchVC
        cardVC = CardViewController(rootVC: self, searchCompletor: searchCompletor)
        cardVC.delegate = self
    }
    
    //    private func setupGestures(){
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchLabelTapped(_:)))
    //       // let sideBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(sideBarTapped(_:)))
    //        rootView.searchLabel.addGestureRecognizer(tapGesture)
    ////        rootView.sideBarIV.addGestureRecognizer(sideBarTapGesture)
    //    }
    
    private func addTargets(){
        rootView.dateTimeButton.addTarget(self, action: #selector(dateTimeButtonPressed), for: .touchUpInside)
        rootView.searchByMapViewButton.addTarget(self, action: #selector(mapViewButtonPressed), for: .touchUpInside)
    }
    
    private func addNavButtons(){
//        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar.circle"), style: .plain, target: self, action: #selector(calenderButtonPressed))
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(calenderButtonPressed))
        barButtonItem.tintColor = .systemTeal
        let sideBarButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(sideBarTapped(_:)))
        
        
        let customView = UIImageView(image: UIImage(systemName: "line.horizontal.3"))
        customView.isUserInteractionEnabled = true
        let sideBarButtonC = UIBarButtonItem(customView: customView)
        sideBarButtonC.action = #selector(sideBarTapped(_:))
        sideBarButtonC.tintColor = .systemTeal
        
        sideBarButton.tintColor = .systemTeal
        navigationItem.leftBarButtonItem = sideBarButton
        navigationItem.rightBarButtonItems?.append(barButtonItem)
    }
    
    @objc private func sideBarTapped(_ recognizer: UITapGestureRecognizer){
        //print("test")
        let sideBarVC = SideBarViewController()
        navigationController?.fadeTo(sideBarVC)
    }
    
    //    @objc private func searchLabelTapped(_ recognizer: UITapGestureRecognizer){
    //        guard let searchVC = searchVC else{
    //            return
    //        }
    //        searchVC.modalTransitionStyle = .crossDissolve
    //        navigationController?.pushViewController(searchVC, animated: true)
    //    }
    
    @objc private func calenderButtonPressed(){
        //        let vc = VC()
        //        navigationController?.pushViewController(vc, animated: true)
        
        let storyboard = UIStoryboard(name: "Post", bundle: nil)
        let postVC = storyboard.instantiateViewController(identifier: "PostViewController")
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    //    private func addNavBarItems(){
    //            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(pushToFirstProfileViewController))
    //            navigationItem.rightBarButtonItem = barButtonItem
    //        }
    
    
    //    @objc private func pushToFirstProfileViewController(){
    //    //        let profileVC = ProfileViewController()
    //        let storyboard = UIStoryboard(name: "FirstProfileStoryboard", bundle: nil)
    //        let firstProfilelVC = storyboard.instantiateViewController(identifier: "FirstProfileViewController")
    //        navigationController?.pushViewController(firstProfilelVC, animated: true)
    //    }
    
    private func setupMap(){
        rootView.mapView.showsCompass = true
        rootView.mapView.showsUserLocation = true
        let usersLocation = locationSession.location
        let tempLocation = CLLocation(latitude: 40.8765478, longitude: -73.9089867)
        rootView.mapView.centerToLocation(tempLocation)
        rootView.searchByMapViewButton.isHidden = true
        topRightCoor = rootView.mapView.convert(CGPoint(x: rootView.mapView.bounds.width, y: 0), toCoordinateFrom: rootView.mapView)
        bottomLeftCoor = rootView.mapView.convert(CGPoint(x: 0, y: rootView.mapView.bounds.height), toCoordinateFrom: rootView.mapView)
    }
    
    private func setupCard(){
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.rootView.mapView.frame
        self.rootView.mapView.addSubview(visualEffectView)
        
        self.addChild(cardVC)
        self.rootView.addSubview(cardVC.view)
        
        cardVC.view.frame = CGRect(x: 0, y: (self.view.frame.height - collaspedCardSize.height - navBarHeight - cardHandleAreaHeight), width: collaspedCardSize.width, height: collaspedCardSize.height + cardHandleAreaHeight)
        cardVC.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
        cardVC.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardVC.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            //startTransition
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            //updateTransition
            let translation = recognizer.translation(in: self.cardVC.handleArea)
            var fractionComplete = translation.y / expandedCardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            //continueTransition
            continueInteractiveTransition(state: nextState)
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval){
        if runningAnimations.isEmpty {
            if state != nextState{
                return
            }
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardVC.view.frame.origin.y = (self.view.frame.height ) - self.expandedCardHeight - self.navBarHeight
                    self.cardVC.view.frame.size = self.expandedCardSize
                    //                    if let layout = self.cardVC.cv.collectionViewLayout as? UICollectionViewFlowLayout {
                    //                        self.cardVC.cv.layoutIfNeeded()
                    //                        layout.scrollDirection = .vertical
                //                    }
                case .collapsed:
                    self.cardVC.view.frame.origin.y = (self.view.frame.height - self.collaspedCardSize.height - self.navBarHeight - self.cardHandleAreaHeight)
                    let newCardSize = CGSize(width: self.collaspedCardSize.width, height: self.collaspedCardSize.height + self.cardHandleAreaHeight)
                    self.cardVC.view.frame.size = newCardSize
                    //                    if let layout = self.cardVC.cv.collectionViewLayout as? UICollectionViewFlowLayout {
                    //                        self.cardVC.cv.layoutIfNeeded()
                    //                        layout.scrollDirection = .horizontal
                    //
                    //                    }
                }
            }
            frameAnimator.addCompletion { (anim) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
                if let layout = self.cardVC.cv.collectionViewLayout as? UICollectionViewFlowLayout {
                    switch state {
                    case .collapsed:
                        layout.animateScrollDirection(scrollDir: .horizontal, progress: nil, duration: 0.5)
                        self.rootView.searchLabel.resignFirstResponder()
                    case .expanded:
                        layout.animateScrollDirection(scrollDir: .vertical, progress: nil, duration: 0.5)
                    }
                }
                
            }
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardVC.view.layer.cornerRadius
                        = 12
                case .collapsed:
                    self.cardVC.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval){
        if runningAnimations.isEmpty{
            //run animations
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted
                + animationProgressWhenInterrupted
        }
        if let layout = cardVC.cv.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.animateScrollDirection(scrollDir: nil, progress: fractionCompleted
                + animationProgressWhenInterrupted, duration: nil)
        }
    }
    
    func continueInteractiveTransition(state: CardState) {
        var animatorProgress: CGFloat = 0
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            animatorProgress = animator.fractionComplete
        }
        let scrollDir:UICollectionView.ScrollDirection
        switch state {
        case .collapsed:
            scrollDir = .horizontal
        case .expanded:
            scrollDir = .vertical
        }
        if let layout = cardVC.cv.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.animateScrollDirection(scrollDir: scrollDir, progress: animatorProgress, duration: nil)
        }
        
    }
    
    @objc private func mapViewButtonPressed(){
        //if rootView.searchByMapViewButton.isHidden == false {
            rootView.searchByMapViewButton.isHidden = true
            //return
        //}
        
        //rootView.searchByMapViewButton.isHidden = true
        let latRange:ClosedRange<CLLocationDegrees>
        let longRange:ClosedRange<CLLocationDegrees>
        let topRightLat = topRightCoor.latitude
        let topRightLong = topRightCoor.longitude
        let bottomLeftLat = bottomLeftCoor.latitude
        let bottomLeftLong = bottomLeftCoor.longitude
        
        if topRightLat > bottomLeftLat {
            latRange = bottomLeftLat...topRightLat
        } else {
            latRange = topRightLat...bottomLeftLat
        }
        
        if topRightLong > bottomLeftLong{
            longRange = bottomLeftLong...topRightLong
        } else {
            longRange = topRightLong...bottomLeftLong
        }
        
        let latLongTuple = (lat: latRange, long: longRange)
        
        delegate?.readPostsFromMapView(given: latLongTuple)
    }
    
    @objc private func dateTimeButtonPressed(){
        let actionsheet = UIAlertController(title: "Nope, I mean...", message: nil, preferredStyle: .actionSheet)
        let dateButton = UIAlertAction(title: Date().toString(givenFormat: "E MM.dd"), style: .default) { (action) in
            //show calendar
            //selected dates stored on a property and used to filter with location
        }
        let timeButton = UIAlertAction(title: "\(Date().toString(givenFormat: "h:mm a")) - \(Date().addingTimeInterval(Double.hoursToSeconds(hours: 1)).toString(givenFormat: "h:mm a"))", style: .default) { (action) in
            //show timer
            //selected time frame stored on a property
        }
        let confirmButton = UIAlertAction(title: "Confirm", style: .default) { (action) in
            self.dismiss(animated: true) {
                //store and apply both date and time
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        confirmButton.setValuesForKeys(
            [
                //"backgroundColor":UIColor.systemOrange,
                "titleTextColor":UIColor.systemOrange,
        ])
        
        let actions = [dateButton, timeButton, confirmButton, cancelButton]
        actions.forEach{actionsheet.addAction($0)}
        present(actionsheet, animated: true, completion: nil)
    }
    
    public func makeAnnotations(posts: [Post]) -> [MKPointAnnotation]? {
        var annotations = [MKPointAnnotation]()
        for post in posts {
            guard let lat = post.latitude, let long = post.longitude else {
                return nil
            }
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.title = post.postTitle
            annotation.coordinate = coordinates
            annotations.append(annotation)
        }
        //        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1500, longitudinalMeters: 1500)
        //        mapView.setRegion(region, animated: true)
        return annotations
    }
    
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    private func validateMapRegion(_ region: MKCoordinateRegion?) -> MKCoordinateRegion?{
        guard let region = region else { return nil }
        if ( (region.center.latitude >= -90) && (region.center.latitude <= 90)     && (region.center.longitude >= -180)     && (region.center.longitude <= 180)) {
            return region
        } else {
            return nil
        }
    }
    
    func didSearchViewBGColorOrange(view: UIView, textField: UITextField, dateTimeButton: UIButton, eval: Bool) {
         let transitation = CATransition()
         transitation.type = .fade
         transitation.subtype = .fromBottom
         transitation.duration = 0.3
         let items = [view, textField, dateTimeButton]
         for item in items {
             item.layer.add(transitation, forKey: nil)
         }
         
         if eval == true {
             view.backgroundColor = .systemBackground
             textField.textColor = .systemOrange
             dateTimeButton.backgroundColor = .systemOrange
             dateTimeButton.tintColor = .systemBackground
             dateTimeButton.setTitleColor(.systemBackground, for: .normal)
         } else {
             view.backgroundColor = .systemOrange
             textField.textColor = .systemBackground
             dateTimeButton.backgroundColor = .systemBackground
             dateTimeButton.tintColor = .systemOrange
             dateTimeButton.setTitleColor(.systemOrange, for: .normal)
         }
     }
}

//extension RootViewController: SearchResultsViewControllerDelegate{
//    func readPostsFromSearchBar(given coordinate: CLLocationCoordinate2D, searchResult: String, region: MKCoordinateRegion?) {
//        guard let region = validateMapRegion(region) else {
//            return
//        }
//        let regionThatFits = mapView.regionThatFits(region)
//        mapView.setRegion(regionThatFits, animated: true)
//
//    }
//
//    //    func readPostsFromSearchBar(given coordinate: CLLocationCoordinate2D, searchResult: String) {
//    //        //map view to center location from addrr
//    //
//    //        self.rootView.mapView.centerToLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
//    //    }
//
//    func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
//
//    }
//
//}

extension RootViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        guard rootView.searchByMapViewButton.isHidden == true else {
            topRightCoor = rootView.mapView.convert(CGPoint(x: rootView.mapView.bounds.width, y: 0), toCoordinateFrom: rootView.mapView)
            bottomLeftCoor = rootView.mapView.convert(CGPoint(x: 0, y: rootView.mapView.bounds.height), toCoordinateFrom: rootView.mapView)
            return
        }
        topRightCoor = rootView.mapView.convert(CGPoint(x: rootView.mapView.bounds.width, y: 0), toCoordinateFrom: rootView.mapView)
        bottomLeftCoor = rootView.mapView.convert(CGPoint(x: 0, y: rootView.mapView.bounds.height), toCoordinateFrom: rootView.mapView)
        let transitation = CATransition()
        transitation.type = .reveal
        transitation.subtype = .fromRight
        transitation.duration = 1
        rootView.searchByMapViewButton.layer.add(transitation, forKey: nil)
        rootView.searchByMapViewButton.isHidden = false
        NotificationCenterManager.shared.nfc.post(name: NotificationCenterManager.mapViewDidChangeVisibleRegion, object: nil)
        rootView.searchLabel.resignFirstResponder()
        
        
        //print("topRight",topRightCoor,"bottomLeft", bottomLeftCoor)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedAnnotation = view.annotation as? MKPointAnnotation else {
            return
        }
        var cardState = 0
        if nextState == .collapsed{
            cardState = 1
        }
        
        delegate?.annontationPressed(given: selectedAnnotation, cardState: cardState)
        
    }
    
}

extension RootViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didSearchViewBGColorOrange(view: rootView.searchBarView, textField: rootView.searchLabel, dateTimeButton: rootView.dateTimeButton, eval: false)
        animateTransitionIfNeeded(state: .expanded, duration: 0.9)
        NotificationCenterManager.shared.nfc.post(name: NotificationCenterManager.textFieldDidBeginEditing, object: nil)
        rootView.searchByMapViewButton.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let address = textField.text, !address.isEmpty else {
            return false
        }
        didSearchViewBGColorOrange(view: rootView.searchBarView, textField: rootView.searchLabel, dateTimeButton: rootView.dateTimeButton, eval: true)
        animateTransitionIfNeeded(state: .collapsed, duration: 0.9)
        NotificationCenterManager.shared.nfc.post(name: NotificationCenterManager.textFieldShouldReturn, object: nil)
        rootView.searchByMapViewButton.isHidden = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let address = textField.text, !address.isEmpty{
            NotificationCenterManager.shared.nfc.post(name: NotificationCenterManager.textFieldshouldChangeCharactersIn, object: nil, userInfo: [NotificationCenterManager.textFieldshouldChangeCharactersIn: address])
            //searchCompletor.queryFragment = address
        }
        return true
    }
}

extension RootViewController: CardViewControllerDelegate{
    func postsFoundFromSearchBar(posts: [Post], coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>), region: MKCoordinateRegion) {
        guard let region = validateMapRegion(region), let annotations = makeAnnotations(posts: posts) else {
            return
        }
        let regionThatFits = mapView.regionThatFits(region)
        mapView.setRegion(regionThatFits, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        didSearchViewBGColorOrange(view: rootView.searchBarView, textField: rootView.searchLabel, dateTimeButton: rootView.dateTimeButton, eval: true)
        posts.isEmpty ?
            animateTransitionIfNeeded(state: .expanded, duration: 0.9) : animateTransitionIfNeeded(state: .collapsed, duration: 0.9)
    }
    
    func postsFoundFromMapView(posts: [Post], coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>)) {
        guard let annotations = makeAnnotations(posts: posts) else {
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        didSearchViewBGColorOrange(view: rootView.searchBarView, textField: rootView.searchLabel, dateTimeButton: rootView.dateTimeButton, eval: true)
        //posts.isEmpty ?
        //animateTransitionIfNeeded(state: .collapsed, duration: 0.9) : animateTransitionIfNeeded(state: .collapsed, duration: 0.9)
    }
}
