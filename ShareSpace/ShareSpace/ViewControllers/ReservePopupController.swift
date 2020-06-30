//
//  ReservePopupController.swift
//  ShareSpace
//
//  Created by Liubov Kaper  on 6/1/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseFirestore
import Firebase

class ReservePopupController: UIViewController {
    
    private let storageService = StorageService.shared
    
    
    
    @IBOutlet weak var litingTitle: UILabel!
    
    
    @IBOutlet weak var listingBy: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    @IBOutlet weak var dismissBar: UIView!
    
    
    @IBOutlet weak var pricePerNightLabel: UILabel!
    
    @IBOutlet weak var toDateLAbel: UILabel!
    
    @IBOutlet weak var fromDateLabel: UILabel!
    
    
    @IBOutlet weak var messageTextView: UITextView!
    
    
    @IBOutlet weak var numberOgGuestsTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    private var hostOfThisListing: UserModel?
    
    
    private var selectedPost: Post
    private var selectedReservation: Reservation?
    
    private var listener: ListenerRegistration?
    
    init?(coder: NSCoder, selectedPost: Post) {
        self.selectedPost = selectedPost
        super.init(coder: coder)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    
    private var datesRange: [Date]?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listingBy.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        pricePerNightLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        toDateLAbel.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        totalPriceLabel.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        messageTextView.layer.addBorder(edge: UIRectEdge.left, color: .systemGray4, thickness: 1)
        messageTextView.layer.addBorder(edge: UIRectEdge.bottom, color: .systemGray4, thickness: 1)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemGroupedBackground
        messageTextView.delegate = self
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        setupCalendarAppearance()
        updateUI()
        setupDismissBar()
        setupCalendarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener = DatabaseService.shared.isReservationReserved(postId: selectedPost.postId, completion: { (result) in
            switch result {
            case .failure:
                break
            case .success(let listenerResult):
                if listenerResult.isReserved == true {
                    let reservations = listenerResult.reservations ?? [Reservation]()
                    self.selectedReservation = reservations.first
                }
            }
        })
        
        
    }
    
    private func setupCalendarUI() {
        calendar.clipsToBounds = true
        calendar.layer.cornerRadius = 13
        messageTextView.clipsToBounds = true
        messageTextView.layer.cornerRadius = 13
        sendButton.backgroundColor = .yummyOrange
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 13
        
    }
    
    private func setupDismissBar() {
        dismissBar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (topGesturePressed(recognizer:)))
        //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        dismissBar.addGestureRecognizer(tapGesture)
    }
    @objc func topGesturePressed(recognizer: UITapGestureRecognizer) {
        dismiss(animated: true) 
    }
    
    private func setupCalendarAppearance() {
        calendar.scrollDirection = .vertical
        calendar.appearance.todayColor = .yummyOrange
        
        calendar.appearance.selectionColor = .oceanBlue
        calendar.appearance.weekdayTextColor = .oceanBlue
        calendar.appearance.headerTitleColor = .systemYellow
        //calendar.appearance.weekdayTextColor = .white
        calendar.appearance.headerTitleFont = .preferredFont(forTextStyle: .largeTitle)
        calendar.appearance.titleFont = .preferredFont(forTextStyle: .subheadline)
        
        
    }
    
    private func loadUser() {
        
    }
    func updateUI() {
        
        //guard let host = hostOfThisListing else { return }
        
        DatabaseService.shared.loadUser(userId: selectedPost.userId) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                self.hostOfThisListing = user
                self.listingBy.text = "Listing by: \(self.hostOfThisListing?.displayName ?? "no name")"
            }
        }
        pricePerNightLabel.text = "$\(Int(selectedPost.price).description)/Day"
        litingTitle.text = selectedPost.postTitle
        
    }
    
    
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        
        guard let user = Auth.auth().currentUser else { return }
        let hostId = selectedPost.userId
        let chatId = UUID().uuidString
        let renterId = user.uid
        let postId = selectedPost.postId
        let status = Status.undetermined
        let reservationId = UUID().uuidString
        let totalPrice = (Double((datesRange?.count ?? 1)) * selectedPost.price)
        guard let checkIn = datesRange?.first,
            
            let checkOut = datesRange?.last,
            let totalDays = datesRange?.count,
            
            
            let message = messageTextView.text,
            !message.isEmpty else { return }
        let messageID = UUID().uuidString
        let dict:[String : Any]
            = [
                "renterId": renterId,
                "postId": postId,
                "checkIn": Timestamp(date: checkIn),
                "checkOut": Timestamp(date: checkOut),
                "chatId": chatId,
                "status": status.rawValue,
                "reservationId": reservationId,
                "hostId": hostId,
                "totalPrice": totalPrice,
                "totalDays": totalDays
        ]
        DatabaseService.shared.createReservation(reservation: dict) { (result) in
            switch result {
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
                
            case .success:
                let message = Message(id: messageID, content: message, created: Timestamp(), senderID: renterId, senderName: user.displayName ?? "anonymous", wasRead: false)
                self.creatingThread(user1Id: renterId, user2Id: self.selectedPost.userId, reservationId: reservationId, messgae: message, chatId: chatId)
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    // code to remove your view
//                    self.dismiss(animated: true)
//                }
                
                
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // code to remove your view
            self.dismiss(animated: true)
        }
    

        
    }
    
    private func creatingThread(user1Id: String, user2Id: String, reservationId: String, messgae: Message, chatId: String){
        DatabaseService.shared.beginChatConversation(user1ID: user1Id, user2ID: user2Id, reservationId: reservationId, message: messgae.content) { (result) in
            switch result{
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            case .success:
                DispatchQueue.main.async {
                    self.showAlert(title: "Message sent", message: "Host will respond to you after reviewing your request")
                }
                
            }
             
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension ReservePopupController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected")
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            //totalPriceLabel.text = (datesRange?.count ?? 1 * Int(selectedPost?.price.total ?? 1)).description
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
            totalPriceLabel.text = "Total for \(datesRange?.count ?? -1) days:         $\(((datesRange?.count ?? 1) * Int(selectedPost.price)).description)"
            fromDateLabel.text = "From:                           \(datesRange?.first?.toString(givenFormat: "MMM d, yyyy") ?? "no date")"
            toDateLAbel.text = "To:                                \(datesRange?.last?.toString(givenFormat: "MMM d, yyyy") ?? "no date")"
            
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
            
            print("there are:\(datesRange?.count ?? 0) dates")
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
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}


extension ReservePopupController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageTextView.text == "enter your message here" {
            messageTextView.text = ""
            messageTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTextView.text == "" {
            messageTextView.text = "enter your message here" 
        }
    }
}
