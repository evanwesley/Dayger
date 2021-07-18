//
//  locationSearchTableViewController.swift
//  dayger
//
//  Created by Evan Wesley on 6/8/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import MapKit

let currentUserEmail = Auth.auth().currentUser!.email
private var db = Firestore.firestore()
//for firebase
var searchCompleter = MKLocalSearchCompleter()
// These are the results that are returned from the searchCompleter & what we are displaying
// on the searchResultsTable
var searchResults = [MKLocalSearchCompletion]()
let vc = createEventViewController()

class locationSearchTableViewController: UIViewController, MKLocalSearchCompleterDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self

        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Setting our searchResults variable to the results that the searchCompleter returned
        searchResults = completer.results

        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }

    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
// Setting up extensions for the table view
extension locationSearchTableViewController: UITableViewDataSource {
// This method declares the number of sections that we want in our table.
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

// This method declares how many rows are the in the table
// We want this to be the number of current search results that the
// searchCompleter has generated for us
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
}

// This method declares the cells that are table is going to show at a particular index
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Get the specific searchResult at the particular index
   let searchResult = searchResults[indexPath.row]

   //Create  a new UITableViewCell object
   let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

   //Set the content of the cell to our searchResult data
   cell.textLabel?.text = searchResult.title
   cell.detailTextLabel?.text = searchResult.subtitle

    return cell
  }
    
}


extension locationSearchTableViewController: UITableViewDelegate {
// This method declares the behavior of what is to happen when the row is selected

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   tableView.deselectRow(at: indexPath, animated: true)

   let result = searchResults[indexPath.row]
   let searchRequest = MKLocalSearch.Request(completion: result)
   let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
       guard let name = response?.mapItems[0].name else {
             return
       }
       let lat = coordinate.latitude
       let lon = coordinate.longitude
       print(lat)
       print(lon)
       print(name)
            //Store data location data into Firebase (below)
            let location:GeoPoint = GeoPoint(latitude:lat,longitude:lon)
            let docData: [String:Any] = ["location(coordinates)" : location , "location(name)": name ]
            db.collection("users").document("\(currentUserEmail!)").collection("events").document("event-1").setData(docData, merge: true)
            //assign data bac to the create event vc
           
            //return to the create event VC
            self.returnToCreateEvent()
            
     }
    
  }
    //calling in the above function
    func returnToCreateEvent () {
        let createEventVC = self.storyboard?.instantiateViewController(identifier: "createEventVC")
        self.view.window?.rootViewController = createEventVC
        self.view.window?.makeKeyAndVisible()
        
        
    }
}


