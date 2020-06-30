//
//  CalendarViewController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/4/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarViewControllerDelegate: AnyObject {
    func datesSelected(datesRange: [Date])
}


class CalendarViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var calendarObj: FSCalendar!
    
    weak var delegate: CalendarViewControllerDelegate?
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        delegatesAndDataSources()
//        setupCalendar()

    }
    
    private func setupCalendar(){
        calendarObj.scrollDirection = .horizontal
        calendarObj.allowsMultipleSelection = true
    }
    
    private func delegatesAndDataSources(){
        calendarObj.delegate = self
        calendarObj.dataSource = self
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        guard let datesRange = datesRange, !datesRange.isEmpty  else {
            return
        }
        delegate?.datesSelected(datesRange: datesRange)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CalendarViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
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

extension CalendarViewController:FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
