//
//  guestlistViewController.swift
//  dayger
//
//  Created by Evan Wesley on 8/19/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class guestlistViewController: UIViewController , UITextFieldDelegate {
    let db = Firestore.firestore()
    var guestData = [GuestListDataModel]()
    var docID = ""
    
    var searchData = [GuestListDataModel]()
    var searching = false
    var eventName = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //registerTableView Here
        
        self.tableView.register(UINib(nibName: "guestListTableViewCell", bundle: nil), forCellReuseIdentifier: "guestlistCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.loadData()

        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        print(docID)
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("active_events").document(docID).collection("guest_list").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                print(" from load data function!\(querySnapshot!.documents.count)")
                print("func loadData has loaded \(querySnapshot!.documents.count) documents")
                self.guestData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    self.tableView.reloadData()
            
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
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
}
extension guestlistViewController : UITableViewDelegate , UITableViewDataSource {
    
    
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    if searching == true {
    
        return searchData.count
    
    } else {
        return guestData.count
    }
        
}
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestlistCell" ,
                                                 
                                                 for: indexPath) as! guestListTableViewCell
        
        if searching == true {
            let data = searchData[indexPath.row]
           
            
            
            
            
            cell.nameLabel.text = "\(data.firstname) \(data.lastname)"
            cell.socialLabel.text = "\(data.social)"
         
            
    } else {
       let data = guestData[indexPath.row]
        
            let storageRef = Storage.storage().reference(withPath: "user_selfies/\(data.uid).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                if let error = error {
                    
                    print("there was a problem fetching data for the event \(error.localizedDescription)")
                }
                if let data = data {
                    cell.selfieImage.image = UIImage(data : data)
                }
            }
        
        cell.nameLabel.text = "\(data.firstname)" + " " + "\(data.lastname)" //firstname and lastname
        
        cell.socialLabel.text = "\(data.social)"
        cell.selectionStyle = .none
    }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let destinationVC = segue.destination as? guestListDetailViewController else {return}
            
            destinationVC.eventID = docID
            destinationVC.eventName = eventName
            
            destinationVC.guestFirstName = guestData[indexPath.row].firstname
            
            destinationVC.guestLastName = guestData[indexPath.row].lastname
            
            destinationVC.iceNumber = guestData[indexPath.row].icenumber
            
            destinationVC.iceName = guestData[indexPath.row].icename
            
            destinationVC.email = guestData[indexPath.row].email
            destinationVC.uid = guestData[indexPath.row].uid
            
            destinationVC.social = guestData[indexPath.row].social
            destinationVC.sex = guestData[indexPath.row].sex
    }
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toGuestListDetailsVC", sender: indexPath.row)
        
    }
}
extension guestlistViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchData = self.guestData.filter({$0.firstname.contains(searchText)}).map({return ($0)})
        searching = true
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    
    
}
