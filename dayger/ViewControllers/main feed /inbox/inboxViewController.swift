//
//  inboxViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/6/21.
//

import UIKit
import Firebase
import FirebaseDatabase
class inboxViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var docID : String?
    
    
    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser!.email
    var cellData = [VerificationDataModel]() //array
    //were just going to use cell data. Its simple
    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "inboxTableViewCell", bundle: nil), forCellReuseIdentifier: "inboxCell")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadData()
        
        print("view appeared")
        print(cellData.count)
        // Do any additional setup after loading the view.
    }
    func transitionToHome (){
        //back button
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
       
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        
        self.transitionToHome()
        
        
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
                    
            }
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
extension inboxViewController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    
        
       
        return cellData.count
    //the cell works
            
        
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell",
                                                 
                                                 for: indexPath) as! inboxTableViewCell
        
        let data = cellData[indexPath.row]
        cell.infoLabel.text = "Would like to attend: \(data.event)"
        cell.nameLabel.text = "\(data.guest)"
        cell.delegate = self
        cell.guest = data.guest
        
        cell.docID = data.docID
        
     
        
       
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toInboxDetails", sender: indexPath.row)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            
        
            guard let destinationVC = segue.destination as? inboxDetailsViewController else {return}
            
            destinationVC.name = cellData[indexPath.row].guest
            destinationVC.handle = cellData[indexPath.row].handle
            destinationVC.age = cellData[indexPath.row].age
            destinationVC.sex = cellData[indexPath.row].sex
            //all of this passes data from the inbox data model to the details view.
            //this data is going to be sourced from a profile. For now we are going to generate sample data
        }
    }
    
    
    
}
extension inboxViewController : inboxTableViewCellDelegate {
   
  
    
    func inboxTableViewCell(_ inboxTableViewCell: inboxTableViewCell, acceptButtonTappedFor guest: String) {
        // quality control
        
       
        
        
       // db.collection("users").document("\(currentUserEmail!)").collection("inbox").document("\(docID!)").delete()
        
    }
    
    
    
    
}
