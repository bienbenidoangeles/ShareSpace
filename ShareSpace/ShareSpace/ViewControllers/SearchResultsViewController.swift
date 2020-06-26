//
//  SearchResultsViewController.swift
//  ShareSpace
//
//  Created by Bienbenido Angeles on 6/11/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit
import MapKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func readPostsFromSearchBar(given coordinate: CLLocationCoordinate2D, searchResult: String, region: MKCoordinateRegion?)
    //func readPostsFromMapView(given coordinateRange: (lat: ClosedRange<CLLocationDegrees>, long: ClosedRange<CLLocationDegrees>))
}

class SearchResultsViewController: UIViewController {
        
    private let searchResultsView = SearchResultsView()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet{
            DispatchQueue.main.async {
                self.searchResultsView.tableView.reloadData()
            }
        }
    }
    
    private var selectedResult: MKLocalSearchCompletion?
    
    private var searchCompletor: MKLocalSearchCompleter
    
    init(searchCompletor: MKLocalSearchCompleter) {
        self.searchCompletor = searchCompletor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchResultsView
        view.backgroundColor = .systemBackground
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegatesAndDataSources()
        addFakeNavBar()
    }
    
    private func addFakeNavBar(){
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "xmark")
        self.searchResultsView.searchTextField.becomeFirstResponder()
    }
    
    private func delegatesAndDataSources(){
        searchResultsView.searchTextField.delegate = self
        searchResultsView.tableView.delegate = self
        searchResultsView.tableView.dataSource = self
        searchCompletor.delegate = self
    }
    
    
//    func convertAddressToCoor(address: String){
//        CoreLocationSession.shared.convertAddressToPlaceMarks(address: address) {[weak self] (result) in
//            switch result{
//            case .failure(let error):
//                //message pop-up for errors
//                self?.showAlert(title: "GeoCoder Error", message: error.localizedDescription)
//            case .success(let placemarks):
//                guard let placemarks = placemarks, let placemark = placemarks.first, let coor = placemark.location?.coordinate else {
//                    self?.showAlert(title: nil, message: "Could not parse location")
//                    return
//                }
//
//
//                self?.delegate?.readPostsFromSearchBar(given: coor, searchResult: address, region: nil)
//                //self.searchResultsView.searchTextField.resignFirstResponder()
//                self?.navigationController?.popViewController(animated: true)
//            }
//        }
//    }
    
    func getRegion(localSearch: MKLocalSearchCompletion){
        CoreLocationSession.shared.getMKRegion(given: localSearch) { [weak self](result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "GeoCoder Error", message: error.localizedDescription)
            case .success(let region):
                let centerCoor = region.center
                let searchTitle = localSearch.title
                let searchSubtitle = localSearch.subtitle
                guard let firstCharOfTitle = searchTitle.first else { return }
                let searchResult = searchSubtitle.isEmpty || !firstCharOfTitle.isNumber ? searchTitle : searchTitle + " " + searchSubtitle
                self?.delegate?.readPostsFromSearchBar(given: centerCoor, searchResult: searchResult, region: region)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension SearchResultsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let address = textField.text, !address.isEmpty, let searchResult = searchResults.first else {
            return false
        }
        
        getRegion(localSearch: searchResult)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let address = textField.text, !address.isEmpty{
            searchCompletor.queryFragment = address
        }
        return true
    }
}

extension SearchResultsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuery = searchResults[indexPath.row]
        //let addressTitle = selectedQuery.title
        //let addressSubTitle = selectedQuery.subtitle
//        addressSubTitle.isEmpty || !addressTitle.first!.isNumber ? convertAddressToCoor(address: addressTitle): convertAddressToCoor(address: addressTitle + " " + addressSubTitle)
//        if addressSubTitle.isEmpty || !addressTitle.first!.isNumber {
//            getRegion(localSearch: selectedQuery)
//        }
        
        getRegion(localSearch: selectedQuery)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchResultsView.searchTextField.resignFirstResponder()
    }
}

extension SearchResultsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    
}

extension SearchResultsViewController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //handle error
        showAlert(title: "SearchCompleter Error", message: error.localizedDescription)
    }
}
