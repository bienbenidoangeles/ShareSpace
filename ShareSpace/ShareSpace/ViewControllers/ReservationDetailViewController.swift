//
//  ReservationDetailViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import Kingfisher

class ReservationDetailViewController: UIViewController {
    
    private var reservationDetailView = ReservationDetailView()
    
    override func loadView() {
        super.loadView()
        view = reservationDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
    }
    

    

}
