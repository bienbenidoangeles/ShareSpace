//
//  ImageView+Animation.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/4/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    public func playAnimation(urls: [URL]){
        var timer: Timer?
        var timeInterval = 1.0
        
        let downloader = ImageDownloader.default
        var imgs = [UIImage]()
        for url in urls{
            downloader.downloadImage(with: url, options: nil) { (result) in
                switch result {
                case .failure:
                    break
                case .success(let imgResult):
                    imgs.append(imgResult.image)
                }
            }
        }
        self.animationImages = imgs
        self.animationDuration = timeInterval
        self.startAnimating()
//        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: <#T##Selector#>, userInfo: <#T##Any?#>, repeats: <#T##Bool#>)
//         func updateTime() {
//            if timeInterval > 0.05 {
//                timeInterval = timeInterval - 0.05
//
//                cell.animationDuration = timeInterval
//                imgView_ref.startAnimating()
//
//                // We update the timer in order to call this method with the new timeInterval
//                timer?.invalidate()
//                timer = nil
//                timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
//            }
//        }
    }
    
    
}
