//
//  RootViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/3/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class RootViewController: NavBarViewController {
    
    let rootView = RootView()
    
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardVC: CardViewController!
    var visualEffectView: UIVisualEffectView!
    
    let cardHeight:CGFloat = 600
    let cardHandleAreaHeight: CGFloat = 65
    
    var cardVisible = false
    
    var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    lazy var tabBarheight:CGFloat = self.tabBarController!.tabBar.frame.size.height
    lazy var navBarHeight:CGFloat = self.navigationController!.navigationBar.frame.size.height
    lazy var searchBarHeight:CGFloat = self.rootView.searchBarView.frame.size.height
    lazy var totalHeight = tabBarheight + navBarHeight + searchBarHeight
    

    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        addTargets()
        setupCard()
        setupMap()
    }
    
    private func delegatesAndDataSources(){
        rootView.searchTextField.delegate = self
    }
    
    private func addTargets(){
        rootView.dateTimeButton.addTarget(self, action: #selector(dateTimeButtonPressed), for: .touchUpInside)
    }
    
    private func setupMap(){
        rootView.mapView.showsCompass = true
        rootView.mapView.showsUserLocation = true
    }
    
    private func setupCard(){
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.rootView.mapView.frame
        self.rootView.mapView.addSubview(visualEffectView)
        cardVC = CardViewController()
        self.addChild(cardVC)
        self.rootView.addSubview(cardVC.view)
        
        cardVC.view.frame = CGRect(x: 0, y: (self.view.frame.height - totalHeight) - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
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
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            //continueTransition
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval){
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardVC.view.frame.origin.y = (self.view.frame.height ) - self.cardHeight
                case .collapsed:
                    self.cardVC.view.frame.origin.y = (self.view.frame.height - self.totalHeight) - self.cardHandleAreaHeight
                }
            }
            frameAnimator.addCompletion { (anim) in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
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
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
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
            "titleTextColor":UIColor.systemBackground,
        ])
        
        let actions = [dateButton, timeButton, confirmButton, cancelButton]
        actions.forEach{actionsheet.addAction($0)}
        present(actionsheet, animated: true, completion: nil)
    }
    
}

extension RootViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
