//
//  inboxViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/6/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class inboxViewController: UIViewController , UITextFieldDelegate{
    
    
 
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var docID : String?
   
    
    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser!.email
    var cellData = [VerificationDataModel]() //array
    //were just going to use cell data. Its simple
    var searchData = [VerificationDataModel]()
    //for swiping right
    
    
    
    var searching = false
    
    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "inboxTableViewCell", bundle: nil), forCellReuseIdentifier: "inboxCell")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        tableView.refreshControl = UIRefreshControl()
        tableView.separatorStyle = .none
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        self.loadData()
        
        
        
        print("view appeared")
        print(cellData.count)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        
    }
    @objc private func didPullToRefresh () {
        //refetch data
        
        self.loadData()
    }
    func transitionToHome (){
        //back button
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
       
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "inboxUW", sender: self)
        
        
    }
    func loadData() {
        //need this to work
        db.collection("users").document("\(currentUserEmail!)").collection("inbox").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else{
                self.cellData = querySnapshot!.documents.compactMap({VerificationDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                    
            }
        }
    }
}
    
 
 
}
extension inboxViewController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if searching == true {
        
            return searchData.count
        
        } else {
            
            return cellData.count
        }
            
    }
       

    //the cell works
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let data = cellData[indexPath.row]
        
        
        if editingStyle == .delete {

            cellData.remove(at: indexPath.row)
            tableView.reloadData()
            
            
            db.collection("users").document(currentUserEmail!).collection("inbox").whereField("guestUid" , isEqualTo: data.guestUid).whereField("docID", isEqualTo: data.docID).getDocuments {(querySnapshot,error) in
                if let error = error {
                   print("\(error)")
                } else{
                   
                    let document = querySnapshot!.documents[0]
                    
                    let inboxRequest = document.documentID
                      //this is the document
                    
                    self.db.collection("users").document(self.currentUserEmail!).collection("inbox").document(inboxRequest).delete()
                    
            // remove the item from the data model
            
            // delete the table view row
                }
        
            }
        
            tableView.reloadData()
            
        }
        
    }
            
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Deny"
    }
    
 
    
    func tableView(_ tableView: UITableView,
                    leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
        let editAction = UIContextualAction(style: .normal, title:  "Accept", handler: { [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let swipeData = self.cellData[indexPath.row]
            
            
            self.cellData.remove(at: indexPath.row)
            tableView.reloadData()
            
            let docID = swipeData.docID
            let firstname = swipeData.firstname
            let lastname = swipeData.lastname
            let guestUid = swipeData.guestUid
            let icename = swipeData.icename
            let icenumber = swipeData.icenumber
            let sex = swipeData.sex
            let handle = swipeData.handle
            let email = swipeData.email
            //this is all for the right swipe not to be confused
            
            let userInfo = GuestListDataModel(eventID: docID, firstname: firstname, lastname: lastname, uid: guestUid, icename: icename, icenumber: icenumber, sex: sex, social: handle, email : email)
            
            //adds guest to guest list
            self.db.collection("active_events").document(docID).collection("guest_list").document(email).setData( userInfo.dictionary)
            //adds event to guest feed.
            self.db.collection("users").document(email).collection("requests").document(docID).setData(["accepted" : true , "docID": docID], merge: true)
            
            self.db.collection("users").document(self.currentUserEmail!).updateData(["clout" : FieldValue.increment(Int64(1))])
            
            self.db.collection("users").document("\(email)").updateData(["clout" : FieldValue.increment(Int64(1))])
            
            //deletes request from inbox
            self.db.collection("users").document(self.currentUserEmail!).collection("inbox").whereField("guestUid" , isEqualTo: guestUid).whereField("docID", isEqualTo: docID).getDocuments {(querySnapshot,error) in
                if let error = error {
                   print("\(error)")
                } else{
                   
                    let document = querySnapshot!.documents[0]
                    
                    let inboxRequest = document.documentID
                      //this is the document
                    
                    self.db.collection("users").document(self.currentUserEmail!).collection("inbox").document(inboxRequest).delete()
                    
                }
            }
        })
        
        editAction.backgroundColor = UIColor.orange
        
        
            tableView.reloadData()
             return UISwipeActionsConfiguration(actions: [editAction])
        
     }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell",
                                                 
                                                 for: indexPath) as! inboxTableViewCell
        
        
        
        
        
        
        if searching == true {
            let data = searchData[indexPath.row]
           
            
            
            
            cell.infoLabel.text = "Would like to attend: \(data.event)"
            cell.nameLabel.text = "\(data.firstname) \(data.lastname)"
            cell.delegate = self
            cell.guestUid = data.guestUid
            
            cell.docID = data.docID
            cell.firstname = data.firstname
            cell.lastname = data.lastname
            cell.handle = data.handle
         
            
        } else {
            
            
        
        
        let data = cellData[indexPath.row]
            let storageRef = Storage.storage().reference(withPath: "user_selfies/\(data.guestUid).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                if let error = error {
                    
                    print("there was a problem fetching data for the event \(error.localizedDescription)")
                }
                if let data = data {
                    cell.selfieImage.image = UIImage(data: data)
                }
            }
            
            
        cell.infoLabel.text = "Would like to attend: \(data.event)"
        cell.nameLabel.text = "\(data.firstname) \(data.lastname)"
        cell.delegate = self
        cell.guestUid = data.guestUid
        
        cell.docID = data.docID
        cell.firstname = data.firstname
        cell.lastname = data.lastname
        cell.handle = data.handle //social
            
            
        }
        //adding iceName and number, this makes it 8
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toInboxDetails", sender: indexPath.row)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            
        
            guard let destinationVC = segue.destination as? inboxDetailsViewController else {return}
            
            destinationVC.guestName = "\(cellData[indexPath.row].firstname + " " + cellData[indexPath.row].lastname)"
            
            
            
            destinationVC.guestUid = cellData[indexPath.row].guestUid
            destinationVC.handle = cellData[indexPath.row].handle
            destinationVC.firstname = cellData[indexPath.row].firstname
            destinationVC.lastname = cellData[indexPath.row].lastname
            destinationVC.icename = cellData[indexPath.row].icename
            destinationVC.icenumber = cellData[indexPath.row].icenumber
            destinationVC.event = cellData[indexPath.row].event
            destinationVC.sex = cellData[indexPath.row].sex
            destinationVC.docID = cellData[indexPath.row].docID
            destinationVC.email = cellData[indexPath.row].email
            
            //all of this passes data from the inbox data model to the details view.
            
        }
    }
}
extension inboxViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchData = self.cellData.filter({$0.firstname.contains(searchText)}).map({return ($0)})
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


extension inboxViewController : inboxTableViewCellDelegate {
   
  
    
    func inboxTableViewCell(_ inboxTableViewCell: inboxTableViewCell, acceptButtonTappedFor guestUID: String) {
        // quality control
        
       
        
        
       // db.collection("users").document("\(currentUserEmail!)").collection("inbox").document("\(docID!)").delete()
        
    }
    
    
    
    
}
