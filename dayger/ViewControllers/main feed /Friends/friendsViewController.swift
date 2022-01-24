//
//  friendsViewController.swift
//  dayger
//
//  Created by Evan Wesley on 11/12/21.
//

import UIKit
import Firebase

class friendsViewController: UIViewController {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var yourFriendsLabel: UILabel!
    
    
    let currentUserEmail = Auth.auth().currentUser!.email
    
    let db = Firestore.firestore()
    var cellData = [GuestListDataModel]()
    //the same as the guest list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.register(UINib(nibName: "guestListTableViewCell", bundle: nil), forCellReuseIdentifier: "guestlistCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
 
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("users").document(currentUserEmail!).collection("friends").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                print(" from load data function!\(querySnapshot!.documents.count)")
                print("func loadData has loaded \(querySnapshot!.documents.count) documents")
                
                self.yourFriendsLabel.text = "My Friends (\(querySnapshot!.documents.count))"
                self.cellData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    self.tableView.reloadData()
            
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
        }
    }
    func transitionToProfile (){
        let vc = self.storyboard?.instantiateViewController(identifier: "profileVC")
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    

    @IBAction func exitButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "FriendsUW", sender: self)
        
        
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
extension friendsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestlistCell" ,
                                                 
                                                 for: indexPath) as! guestListTableViewCell
        
        let data = cellData[indexPath.row]
         
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toFriendDetails", sender: indexPath.row)
        
    }
    
    @IBAction func unwindToPFriendsVC(segue: UIStoryboardSegue) {

        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            
        
            guard let destinationVC = segue.destination as? friendsDetailViewController else {return}
            
            
            
            destinationVC.guestUid = cellData[indexPath.row].uid
            destinationVC.handle = cellData[indexPath.row].social
            destinationVC.firstname = cellData[indexPath.row].firstname
            destinationVC.lastname = cellData[indexPath.row].lastname
            destinationVC.icename = cellData[indexPath.row].icename
            destinationVC.icenumber = cellData[indexPath.row].icenumber
            
            destinationVC.sex = cellData[indexPath.row].sex
            destinationVC.docID = cellData[indexPath.row].eventID
            destinationVC.email = cellData[indexPath.row].email
            
            //all of this passes data from the inbox data model to the details view.
            
        }
        
        

}
}
