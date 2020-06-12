//
//  ListingDetailViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/29/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class ListingDetailViewController: UIViewController {
    
    private let locationSession = CoreLocationSession.shared.locationManager
    private var annotation = MKPointAnnotation()
    private var isShowingNewAnnotation = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
   
    @IBOutlet weak var map: MKMapView!
    
    
    
    @IBOutlet weak var priceRating: UIBarButtonItem!
    
    
    
    private var selectedPost: Post
    
    init?(coder: NSCoder, selectedPost: Post) {
        self.selectedPost = selectedPost
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.showsCompass = true
        map.showsUserLocation = true
        updateUI()
        configureCollectionView()
        loadMap()
    }
    
    private func loadMap() {
         makeAnnotation(for: selectedPost)
       
    }
    
    func returnCoordinates(address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) ->())  {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let placemark = placemarks{
                let lat = placemark.first?.location?.coordinate.latitude
            let lon = placemark.first?.location?.coordinate.longitude
                 print("Lat: \(lat ?? 0), Lon: \(lon ?? 0)")
                completion(.success(CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lon ?? 0)))
            }
           
        }
    }
  
    private func makeAnnotation(for post: Post)  {
        selectedPost = post
        let annotation = MKPointAnnotation()
       // let coordinate = CLLocationCoordinate2D
        returnCoordinates(address: "\(post.location.streetAddress), \(post.location.city), \(post.location.state)", completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let coordinates):
                //annotation.coordinate.latitude = coordinates.first?.latitude
            
                let lat = coordinates.latitude
                let long = coordinates.longitude
                let coordinate = CLLocationCoordinate2D(latitude: lat , longitude: long )
                annotation.coordinate = coordinate
                annotation.title = post.price.total.description
                self.isShowingNewAnnotation = true
                self.annotation = annotation
                self.map.addAnnotation(annotation)
                let location = CLLocation(latitude: lat, longitude: long)
                self.map.centerToLocation(location)
                self.map.getDirections(coordinate: coordinate, map: self.map)
            }
        })
        
        
       
        
    }
    
    private func updateUI() {
        titleLabel.text = selectedPost.postTitle
        descriptionLabel.text = selectedPost.description
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
   // override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let detailsVC = segue.destination as? ReservePopupController else {
//                fatalError("unable to segue properly-MainViewController")
//        }
//        if segue.destination is ReservePopupController {
//            let reserveVC = segue.destination as? ReservePopupController
//            reserveVC?.selectedPost = selectedPost
//        }
//    
//    }
//    
    
    @IBAction func inquireButtonPressed(_ sender: UIBarButtonItem) {
     
        let storyboard = UIStoryboard(name: "ListingDetail", bundle: nil)
         let popupVC = storyboard.instantiateViewController(identifier: "ReservePopupController", creator: { (coder) -> ReservePopupController? in
            return ReservePopupController(coder: coder, selectedPost: self.selectedPost)
        })
        
       // let popupVC = ReservePopupController(selectedPost: selectedPost)
       // navigationController?.pushViewController(popupVC, animated: true)
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.modalPresentationStyle = .fullScreen
        //navigationController?.pushViewController(popupVC, animated: true)
        present(popupVC, animated: true) 
        print("button pressed")
    }
    
    
    @IBAction func price(_ sender: UIBarButtonItem) {
        print("pressed")
    }
    
//    @IBAction func reserveButtonPressed(_ sender: UIBarButtonItem) {
//        print("pressed reserv button")
//        let storyboard = UIStoryboard(name: "ListingDetail", bundle: nil)
//        let detailVC = storyboard.instantiateViewController(identifier: "ReservePopupController")
//        navigationController?.pushViewController(detailVC, animated:false)
//
//        let storyBoard: UIStoryboard = UIStoryboard(name: "ListingDetail", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newViewController") as! ReservePopupController
//
//

       // self.present(newViewController, animated: true, completion: nil)
//
 //       }
    
    
    

}

extension ListingDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //selectedPost.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listingPhotosCell", for: indexPath)
        cell.backgroundColor = .sunnyYellow
        return cell 
    }
    
}

extension ListingDetailViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = view.safeAreaLayoutGuide.layoutFrame.size
        let itemWidth = maxSize.width
        let itemHeight = maxSize.height * 0.70
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension ListingDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
      //  if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.tintColor = .black
            annotationView?.markerTintColor = .systemRed
            
       // } else {
       //     annotationView?.annotation = annotation
           // annotationView?.canShowCallout = true
      //  }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        // renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.systemBlue
        
        renderer.lineWidth = 3.0
        
        // renderer.lineDashPattern = [10]
        
        return renderer
    }
    
}
