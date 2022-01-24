//
//  inboxDetailsViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/13/21.
//

import UIKit
import FirebaseStorage
import Firebase

class inboxDetailsViewController: UIViewController {

    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser!.email
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    
    var guestName = ""
    
    @IBOutlet weak var selfieImage: UIImageView!
    var guestUid  = ""
    var handle  = ""
    var firstname = ""
    var lastname = ""
    var icename = ""
    var icenumber = ""
    var event = ""
    var docID = ""
    var sex : Bool = true
    var email = ""
    
    //guest email
    //this will be mutated
    //social media
   
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
   
    // we are going to have to import those symbols
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    //social media handle
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    

    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var cloutPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.detailView.layer.cornerRadius = 15
       self.detailView.layer.borderColor = UIColor.black.cgColor
       self.detailView.layer.shadowColor = UIColor.black.cgColor
       self.detailView.layer.shadowOpacity = 0.25
       self.detailView.layer.shadowOffset = .zero
       self.detailView.layer.shadowRadius = 2
        
        
        self.acceptButton.alpha = 0
        self.denyButton.alpha = 0
        self.acceptButton.isEnabled = false
        self.denyButton.isEnabled = false
       // self.detailView.layer.borderWidth = 1.75
        
        self.backgroundView.alpha = 0.5
        // Do any additional setup after loading the view.
        
       
        
        self.retrieveData()
        self.displayGuestSelfie()
  
    }
    func displayGuestSelfie () {
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 1
        self.selfieImage.layer.borderColor = daygerColor.cgColor
        
        let storageRef = Storage.storage().reference(withPath: "user_selfies/\(guestUid).jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                
                print("there was a problem fetching data for")
            }
            if let data = data {
                self?.selfieImage.image = UIImage(data: data)
            }
        }

     
        
        
    }
    
    func retrieveData(){
        
        self.handleLabel.text = "\(handle)"
        self.nameLabel.text = "\(guestName)"
        self.infoLabel.text = "\(firstname) would like to attend \(event)! Tip: you can accept individuals by swiping right, and deny them by swiping left on their message."
        
        db.collection("users").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()

                let clout = data!["clout"] as? Int
                
        
                if clout == nil {
                    self.cloutPointsLabel.text = " | 0"
                } else {
                    
                    self.cloutPointsLabel.text = " | \(clout ?? 0)"
                    
                }
                //we could move this line of code
                //we are going to add stats as well
           }
        }
        
    }
    
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        //information to be sent to the guest list
        //functions to be sent to the guest list
        let userInfo = GuestListDataModel(eventID: docID, firstname: firstname, lastname: lastname, uid: guestUid, icename: icename, icenumber: icenumber, sex: sex, social: handle, email : email)
        
        //adds guest to guest list
        db.collection("active_events").document(docID).collection("guest_list").document(email).setData(userInfo.dictionary)
        //adds event to guest feed.
        db.collection("users").document(email).collection("requests").document(docID).setData(["accepted" : true , "docID": docID], merge: true)
       
        //deletes request from inbox
        db.collection("users").document(currentUserEmail!).collection("inbox").whereField("guestUid" , isEqualTo: guestUid).whereField("docID", isEqualTo: docID).getDocuments {(querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
               
                let document = querySnapshot!.documents[0]
                
                let inboxRequest = document.documentID
                  //this is the document
                
                self.db.collection("users").document(self.currentUserEmail!).collection("inbox").document(inboxRequest).delete()
                
            }
        }
        //functions for the host to access the ticket
    }
    
    @IBAction func denyButtonTapped(_ sender: Any) {
        
        db.collection("users").document(currentUserEmail!).collection("inbox").whereField("guestUid" , isEqualTo: guestUid).whereField("docID", isEqualTo: docID).getDocuments {(querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
               
                let document = querySnapshot!.documents[0]
                
                let inboxRequest = document.documentID
                  //this is the document
                
                self.db.collection("users").document(self.currentUserEmail!).collection("inbox").document(inboxRequest).delete()
                
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
