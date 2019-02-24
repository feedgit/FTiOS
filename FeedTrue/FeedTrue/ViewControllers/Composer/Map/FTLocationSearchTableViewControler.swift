//
//  FTLocationSearchTableViewControler.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/23/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class FTLocationSearchTableViewControler: UITableViewController {
    
    fileprivate var cellID = "FTLocationTableViewCell"
    fileprivate var nextURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }
    
    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [FTLocationProperties] = []
    var mapView: MKMapView?
    
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
}

extension FTLocationSearchTableViewControler : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                var p = FTLocationProperties()
                p.mapItem = item
                p.locationLat = item.placemark.coordinate.latitude
                p.locationLong = item.placemark.coordinate.longitude
                p.locationAddress = self.parseAddress(selectedItem: item.placemark)
                p.locationDescription = ""
                p.locationName = item.name ?? ""
                p.locationThumbnail = ""
                p.locationType = ""
                self.matchingItems.append(p)
            }
            //self.matchingItems.append(response.mapItems)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // load from server
        guard searchBarText.count >= 2 else { return }
        WebService.share.searchLocation(searchTerm: searchBarText) { (success, locationResponse) in
            if success {
                self.nextURL = locationResponse?.next
                print(locationResponse.debugDescription)
                if let locations = locationResponse?.results {
                    for item in locations {
                        var p = FTLocationProperties()
                        p.locationLat = item.lat
                        p.locationLong = item.long
                        p.locationAddress = item.address
                        p.locationDescription = item.description
                        p.locationName = item.name
                        p.locationThumbnail = item.thumbnail
                        p.locationType = ""
                        self.matchingItems.append(p)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                // load next
                self.loadNextLocation()
            }
        }
    }
    
    fileprivate func loadNextLocation() {
        guard let urlString = nextURL else { return }
        WebService.share.getNextLocation(next: urlString) { (success, locationResponse) in
            if success {
                self.nextURL = locationResponse?.next
                print(locationResponse.debugDescription)
                // TODO: hanlder load next
                if let locations = locationResponse?.results {
                    for item in locations {
                        var p = FTLocationProperties()
                        p.locationLat = item.lat
                        p.locationLong = item.long
                        p.locationAddress = item.address
                        p.locationDescription = item.description
                        p.locationName = item.name
                        p.locationThumbnail = item.thumbnail
                        p.locationType = ""
                        self.matchingItems.append(p)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension FTLocationSearchTableViewControler {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! FTLocationTableViewCell
        let selectedItem = matchingItems[indexPath.row]
        cell.titleLabel.text = selectedItem.locationName
        if selectedItem.locationAddress.isEmpty == true {
            if let mapItem = selectedItem.mapItem {
                cell.detailLabel.text = parseAddress(selectedItem: mapItem.placemark)
            } else {
                cell.detailLabel.text = nil
            }
        } else {
            cell.detailLabel.text = selectedItem.locationAddress
        }
        //cell.detailLabel.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

extension FTLocationSearchTableViewControler {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]//.placemark
        handleMapSearchDelegate?.dropPinZoomIn(p: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
}
