//
//  LocationSearchTable.swift
//  dayger
//
//  Created by Evan Wesley on 5/2/21.
//

import UIKit
import MapKit


class LocationSearchTable : UITableViewController {
   
    private var search: MKLocalSearch? //swift
    var resultSearchController:UISearchController? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    @IBOutlet var searchTableView: UITableView!
    
    
}
extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView,
              let searchBarText = searchController.searchBar.text else {
            return}
        // if there is an ongoing search, cancel it first. //swift
               self.search?.cancel()

        
        
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response
            else {
                return
            }
            self.matchingItems = response.mapItems
            self.searchTableView.reloadData()
        }
        // make sure `search` is not released. //swift
               self.search = search
    }

        
     
}
extension LocationSearchTable {
    override func tableView(_ searchTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchingItems.count
        
    }
    func tableView(searchTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
}
extension LocationSearchTable {
        func tableView(searchTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
            handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
            dismiss(animated: true, completion: nil)
    }
}
