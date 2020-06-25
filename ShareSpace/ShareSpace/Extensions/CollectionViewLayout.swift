//
//  CollectionViewLayout.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout{
    func animateScrollDirection(scrollDir: UICollectionView.ScrollDirection?, progress: CGFloat?, duration: TimeInterval?){
        
        let transition: CATransition = CATransition()
        if let progress = progress {
            transition.startProgress = Float(progress)
        } else if let duration = duration{
            transition.duration = duration
        }
        transition.type = .fade
        transition.subtype = scrollDir == .vertical ? .fromTop : .fromLeft
        collectionView?.layer.add(transition, forKey: nil)
        if let scrollDir = scrollDir {
            scrollDirection = scrollDir
            collectionView?.layoutIfNeeded()
            //invalidateLayout()
        }
        
    }
}
