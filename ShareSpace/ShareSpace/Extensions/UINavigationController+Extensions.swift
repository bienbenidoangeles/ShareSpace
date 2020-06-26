//
//  UINavigationController+Extensions.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/23/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

extension UINavigationController{
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        let navButtonTransition = CATransition()
        navButtonTransition.subtype = .fromRight
        view.layer.add(transition, forKey: nil)
        //navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem?.customView?.layer.add(navButtonTransition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func fadeToHard(_ viewController: SideBarViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
            
        let navButtonTransition = CATransition()
        navButtonTransition.subtype = .fromRight
            
        let contentTransition = CATransition()
            contentTransition.type = .fade
            contentTransition.subtype = .fromBottom
            contentTransition.duration = 30
        
        viewController.sideBarView.loginLabel.layer.add(contentTransition, forKey: nil)
        viewController.sideBarView.stackView.layer.add(contentTransition, forKey: nil)
        view.layer.add(transition, forKey: nil)
        //navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem?.customView?.layer.add(navButtonTransition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
    
    func fadeAway() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        
        let navButtonTransition = CATransition()
        navButtonTransition.subtype = .fromLeft
        
        view.layer.add(transition, forKey: nil)
        //navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.leftBarButtonItem?.customView?.layer.add(navButtonTransition, forKey: nil)
        popViewController(animated: false)
    }
    
    func fadeAway(_ viewController: SideBarViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        
        let navButtonTransition = CATransition()
        navButtonTransition.subtype = .fromLeft
        
        let contentTransition = CATransition()
            contentTransition.type = .fade
            contentTransition.subtype = .fromBottom
            contentTransition.duration = 30
        
        viewController.sideBarView.loginLabel.layer.add(contentTransition, forKey: nil)
        viewController.sideBarView.stackView.layer.add(contentTransition, forKey: nil)
        
        view.layer.add(transition, forKey: nil)
        //navigationItem.setHidesBackButton(false, animated: true)
        self.navigationItem.leftBarButtonItem?.customView?.layer.add(navButtonTransition, forKey: nil)
        popViewController(animated: false)
    }
    
}
