//
//  ReservePopupController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/1/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FSCalendar

class ReservePopupController: UIViewController {
    
    
//    private var selectedPost: Post
//    
//    
//    
//    init?(coder: NSCoder, selectedPost: Post) {
//        self.selectedPost = selectedPost
//        super.init(coder: coder)
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    // first date in the range
       private var firstDate: Date?
       // last date in the range
       private var lastDate: Date?
       
       private var datesRange: [Date]?
       
           override func viewDidLoad() {
               super.viewDidLoad()
               calendar.delegate = self
               calendar.dataSource = self
               calendar.allowsMultipleSelection = true
               setupCalendarAppearance()
       }
       
       private func setupCalendarAppearance() {
           calendar.scrollDirection = .vertical
           calendar.appearance.todayColor = .yummyOrange
           
           calendar.appearance.selectionColor = .oceanBlue
           calendar.appearance.weekdayTextColor = .oceanBlue
           calendar.appearance.headerTitleColor = .sunnyYellow
           //calendar.appearance.weekdayTextColor = .white
           calendar.appearance.headerTitleFont = UIFont(name: "Verdana", size: 23.0)
        calendar.appearance.titleFont = UIFont(name: "Verdana", size: 18.0)
           
           
       }



}

extension ReservePopupController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected")
         // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            //print("datesRange contains: \(datesRange!)")
            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                //print("datesRange contains: \(datesRange!)")
                return
            }

            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

}
