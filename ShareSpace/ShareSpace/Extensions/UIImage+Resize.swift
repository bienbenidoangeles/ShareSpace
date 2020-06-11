//
//  UIImage+Resize.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 5/24/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {
    func resizeImage(width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    
    static func resizeImageTwo(originalImage: UIImage, rect: CGRect) -> UIImage {
     let rect = AVMakeRect(aspectRatio: originalImage.size, insideRect: rect)
     let size = CGSize(width: rect.width, height: rect.height)
     let renderer = UIGraphicsImageRenderer(size: size)
     return renderer.image { (context) in
      originalImage.draw(in: CGRect(origin: .zero, size: size))
     }
    }
}
