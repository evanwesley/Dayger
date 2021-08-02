//
//  detailsViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/3/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class detailsViewController: UIViewController {
    var name : String = "" 
    var docID : String = ""
    
    let currentUserEmail = Auth.auth().currentUser!.email
    let db = Firestore.firestore()
    //this is the event name
    
    var guestData = [GuestListDataModel]()
    
    //array
    
    
    @IBOutlet weak var tableView: UITableView!
    //for guest list
    @IBOutlet weak var guestView: UIView!
    
    @IBOutlet weak var infoView: UIView!
   
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var docIDLabel: UILabel!
   
    @IBOutlet weak var sexCountLabel: UILabel!
    
    @IBOutlet weak var liveSwitch: UISwitch!
    
    @IBOutlet weak var atCapacitySwitch: UISwitch!
    
    @IBOutlet weak var anonymousSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.guestView.layer.cornerRadius = 10
        self.guestView.layer.borderColor = UIColor.black.cgColor
        self.guestView.layer.borderWidth = 1.75
        
        self.infoView.layer.cornerRadius = 15
        self.infoView.layer.shadowColor = UIColor.black.cgColor
        self.infoView.layer.shadowOpacity = 0.25
        self.infoView.layer.shadowOffset = .zero
        self.infoView.layer.shadowRadius = 2
        
        //registerTableView Here
        
        self.tableView.register(UINib(nibName: "guestListTableViewCell", bundle: nil), forCellReuseIdentifier: "guestlistCell")
        tableView.delegate = self
        tableView.dataSource = self
   
        
        
        print("\(docID)")
        print("\(currentUserEmail!)")
        
        
        
        //self.infoView.layer.borderColor = UIColor.black.cgColor
        //self.infoView.layer.borderWidth = 1.7
        
        
        retrieveData()
        configureSwitches()
        enableCapSwitch()   
        //call this function to load data for the view controller
        
        getDocCount()
        
        // Do any additional setup after loading the view.
    }
    func configureSwitches () {
        
        db.collection("active_events").document(docID).getDocument(source: .cache) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Cached document data: \(dataDescription)")
                
            //We need to put snapshots in the file scope. So we don't have to call them every time.
                
                let data = document.data()
                
                let live = data?["live"] as! Bool
                let atMax = data?["atCapacity"] as! Bool
                let anonymous = data?["anonymous"] as! Bool
                
                //configuring the switches when loaded
                if live == true {
                    self.liveSwitch.isOn = true
                }else{
                    self.liveSwitch.isOn = false
                    
                }
                
                if atMax == true {
                    self.atCapacitySwitch.isOn = true
                } else {
                    self.atCapacitySwitch.isOn = false
                }
                if anonymous == true {
                    self.anonymousSwitch.isOn = true
                }else {
                    self.anonymousSwitch.isOn = false
                }
                
                
        
            }
        }
    
    }
    
    @IBAction func liveSwitchTapped(_ sender: Any) {
        var live : Bool = false
        if liveSwitch.isOn {
            
            live = true
            
            db.collection("active_events").document(docID).updateData(["live" : live ])
        }else {
            
            live = false
            
            db.collection("active_events").document(docID).updateData(["live" : live ])
        }
    }
    
    
    @IBAction func maxCapTapped(_ sender: Any) {
        var isMax : Bool = false
        
        if atCapacitySwitch.isOn {
            
            isMax = true
            
            db.collection("active_events").document(docID).updateData(["atCapacity" : isMax ])
        }else {
            
            isMax = false
           
            db.collection("active_events").document(docID).updateData(["atCapacity" : isMax ])
        }
    }
    
    
    @IBAction func anonTapped(_ sender: Any) {
        var anon : Bool = false
        
        if anonymousSwitch.isOn {
            anon = true
            
            db.collection("active_events").document(docID).updateData(["anonymous" : anon ])
            
        }else {
            
            anon = false
          
            db.collection("active_events").document(docID).updateData(["anonymous" : anon ])
        }
        
    }
    func enableCapSwitch(){
        //this function is going to ensure that the user only can interact with the capacity switch when the event is live.
        
        
        
        if liveSwitch.isOn == false {
            
            atCapacitySwitch.isEnabled = false
            
            
        } else if liveSwitch.isOn == true {
            
            atCapacitySwitch.isEnabled = true
            
        }
        
        
    }
    func loadData() {
        print("\(docID)")
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("active_events").document("\(docID)").collection("guest-list").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                print(" from load data function!\(querySnapshot?.documents.count)")
                print("func loadData has loaded \(querySnapshot?.documents.count) documents")
                self.guestData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    self.tableView.reloadData()
            
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
        }
    }
    
    func getDocCount () {
    //this function saved my life
        db.collection("active_events").document("\(docID)").collection("guest_list").getDocuments { (querySnapshot,error) in
                if let error = error {
                   print("\(error)")
                } else{
                    
                    print("\(querySnapshot?.documents.count)")
                    
                    self.guestData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                    DispatchQueue.main.async {
                    
                        self.tableView.reloadData()
                    }
                }
            }
        }
    
    
    
    func retrieveData () {
        
         nameLabel.text = "\(name)" // this is the name label of the details vc
         docIDLabel.text = "Event ID: \(docID)"
        sexCountLabel.text = "M | 0   F | 0"
        
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        //this function cancels the event
        
        db.collection("users").document("\(currentUserEmail!)").collection("active_events").document("\(docID)").delete()
        
        db.collection("active_events").document("\(docID)").delete()
        
        
        self.transitionToHome()
        //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
        
    }
    
    func transitionToHome (){
        //back button
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
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
extension detailsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
  
    
  
    return guestData.count
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestlistCell" ,
                                                 
                                                 for: indexPath) as! guestListTableViewCell
        
       let data = guestData[indexPath.row]
        
        cell.nameLabel.text = "\(data.firstname)" + " " + "\(data.lastname)" //firstname and lastname
        
        cell.socialLabel.text = "\(data.social)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    
}
