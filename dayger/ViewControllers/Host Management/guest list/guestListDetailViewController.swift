//
//  guestListDetailViewController.swift
//  dayger
//
//  Created by Evan Wesley on 10/4/21.
//

import UIKit
import Firebase
import FirebaseStorage

class guestListDetailViewController: UIViewController {
    
    let currentUserEmail = Auth.auth().currentUser!.email
    let userID = (Auth.auth().currentUser?.uid)!
    
    let db = Firestore.firestore()
    
    var sex : Bool = true
    
    var hostFirstName = ""
    var hostLastName = ""
    var hostSocial = ""
    var hostIceNumber = ""
    var hostIceName = ""
    var hostSex : Bool = false
    //defaults as women
    var guestFirstName = ""
    var guestLastName = ""
    var iceNumber = ""
    var iceName = ""
    var uid = ""
    var eventID = ""
    var email = ""
    var social = ""
    var eventName = ""
   
    var promoter : Bool = false
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iCENameLabel: UILabel!
    
    @IBOutlet weak var iceNumberLabel: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
    @IBOutlet weak var kickButton: UIButton!
    
    @IBOutlet weak var socialLabel: UILabel!
   
  
    @IBOutlet weak var promoterButton: UIButton!
    @IBOutlet weak var removePromoterButton: UIButton!
   
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = 124
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        
        self.circleView.layer.cornerRadius = 125
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOpacity = 0.25
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
        
        self.assignLabels()
        self.displayGuestSelfie()
        self.determinePromoterStatus()
        self.determineFriendStatus()
       
        print(email)
        // Do any additional setup after loading the view.
    }
    func assignLabels() {
        nameLabel.text = "\(guestFirstName) \(guestLastName)"
        iCENameLabel.text = iceName
        iceNumberLabel.text = iceNumber
        
    }
    func displayGuestSelfie () {
        
        let storageRef = Storage.storage().reference(withPath: "user_selfies/\(uid).jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                print("there was a problem fetching data: \(error.localizedDescription)")
            }
            if let data = data {
                self?.selfieImage.image = UIImage(data: data)
            }
        }
    }
    
    @IBAction func kickButtonTapped(_ sender: Any) {
        
        
        if promoter == true {
            
            let alert = UIAlertController(title: "\(guestFirstName) is a Co-Host.", message: "Before you can kick \(guestFirstName) you must remove them as a Co-Host.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil ))
            //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
        
        let alert = UIAlertController(title: "Are you sure you'd like to kick \(guestFirstName)?", message: "\(guestFirstName) will be removed from the guest list and their ticket will be deleted.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler:  { [self] action in
            
            db.collection("active_events").document(eventID).collection("guest_list").document(email).delete()
            //removes from guestlist
            
            db.collection("users").document(email).collection("requests").document(eventID).delete()
        //too lazy to change it to home
        self.transitionToPartyManager()
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind...", style: .cancel, handler: nil ))
        //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
        self.present(alert, animated: true, completion: nil)
        
       }
    
    }
    
    @IBAction func promoterButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Make \(guestFirstName) a Co-Host?", message: "Co-Hosts can scan guests into events on behalf of the host.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Co-Host 🎉", style: .default, handler:  { [self] action in
            db.collection("users").document(email).collection("active_events").document(eventID).setData(["name" : eventName , "docID" : eventID])
            //adds event to promoter's array
            
            db.collection("active_events").document(eventID).collection("promoters").document(email).setData(["email" : email, "uid" : uid])
            //adds to list of promoters
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind...", style: .cancel, handler: nil ))
        //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func removePromoterButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Remove \(guestFirstName) as a Co-Host?", message: "\(guestFirstName) will no longer be able to scan tickets for this event.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler:  { [self] action in
            db.collection("users").document(email).collection("active_events").document(eventID).delete()
            //deletes from promoters array
            
            db.collection("active_events").document(eventID).collection("promoters").document(email).delete()
            
            self.promoter = false
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind...", style: .cancel, handler: nil ))
        //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
        self.present(alert, animated: true, completion: nil)
        
        
    }
    


    
    func transitionToDetailsVC () {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "detailsVC")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
        
    }
    func transitionToPartyManager() {
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
        //function for transitioning to Party Manager
        
        
        
    }
    
    func determineFriendStatus() {
        
        db.collection("users").document(currentUserEmail!).collection("friends").document(email).getDocument(source: .cache) { [self] (document, error) in
            if let document = document {
            
                let data = document.data()
                
                let email = data?["email"]
                let guestUid = data?["uid"]
                
                if guestUid != nil && guestUid as! String == self.uid {
                    
                    addFriendButton.isHidden = true
                    addFriendButton.isEnabled = false
                    socialLabel.text = "\(social) | Your Friend"
                }
                else {
                    
                    addFriendButton.isHidden = false
                    addFriendButton.isEnabled = true
                    socialLabel.text = social
                    
                }
            }
        }
    }
    
    func determinePromoterStatus () {
        //to display promoter label
        db.collection("active_events").document(eventID).collection("promoters").document(email).getDocument(source: .cache) { (document, error) in
            if let document = document {
            
                let data = document.data()
                
                let email = data?["email"]
                
                if email != nil {
                    //to check if email is actually a thing. Small fail safe
                    self.promoter = true
                    
                    self.removePromoterButton.alpha = 1
                    
                    self.promoterButton.isHidden = true
                    
                    
                    
                }
             

            } else {
                
                print(error!, "this guest is not a promoter")
                
                self.removePromoterButton.isHidden = true
                self.removePromoterButton.isEnabled = false
                self.promoterButton.isEnabled = true
            }
        }
    }
    func addHostAsFriend () {
        //getting users first and last name. Assigned below
        db.collection("users").document("\(currentUserEmail!)").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let firstname = data?["firstname"] as! String
                   let lastname = data?["lastname"] as! String
                   let iceNumber = data?["ICE-Number-1"] as! String
                   let iceName = data?["ICE-Name-1"] as! String
                   let social = data?["social_handle"] as! String
                   let sex = data?["sex"] as! Bool
                //whatever
                self.hostFirstName = firstname
                self.hostLastName = lastname
                self.hostIceName = iceName
                self.hostIceNumber = iceNumber
                self.hostSocial = social
                self.hostSex = sex
                
                let hostInfo = GuestListDataModel(eventID: self.eventID, firstname: self.hostFirstName, lastname: self.hostLastName, uid: self.userID , icename: self.hostIceName, icenumber: self.hostIceNumber, sex: self.hostSex, social: self.hostSocial, email: self.currentUserEmail!)
                
                db.collection("users").document(email).collection("friends").document(currentUserEmail!).setData(hostInfo.dictionary)
                //adds myself as a friend as well
           }
        }
    }

    
    
    @IBAction func addFriendButtonTapped(_ sender: Any) {
       
        
        let userInfo = GuestListDataModel(eventID: eventID, firstname: guestFirstName, lastname: guestLastName, uid: uid, icename: iceName, icenumber: iceNumber, sex: sex, social: social, email : email)
    
        
        let alert = UIAlertController(title: "Add \(guestFirstName) as friend?", message: "Add this person to your friends list.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:  { [self] action in
            db.collection("users").document(currentUserEmail!).collection("friends").document(email).setData(userInfo.dictionary)
            //adds user to friends
            self.addHostAsFriend()
           
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind...", style: .cancel, handler: nil ))
        //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}

