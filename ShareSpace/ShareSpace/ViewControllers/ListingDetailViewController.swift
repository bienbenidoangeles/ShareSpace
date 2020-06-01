//
//  ListingDetailViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 5/29/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MapKit


class ListingDetailViewController: UIViewController {
    
    
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

        updateUI()
        configureCollectionView()
    }
    
    private func updateUI() {
        titleLabel.text = selectedPost.postTitle
        descriptionLabel.text = selectedPost.description
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    

    @IBAction func reserveButtonPressed(_ sender: UIBarButtonItem) {
    }
    

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
