//
//  invitationViewController.swift
//  dayger
//
//  Created by Evan Wesley on 8/12/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class invitationViewController: UIViewController {

    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)

    
    var incomingURL = ""
    var eventID = "" //from link
    
    
    let currentUserEmail = Auth.auth().currentUser!.email
    let userID = (Auth.auth().currentUser?.uid)!
    let hostID = ""
    var requestedEventName = ""
    
    
    let iceName = UserDefaults.standard.string(forKey: "iceName")
    let iceNumber = UserDefaults.standard.string(forKey: "iceNumber")
    let socialHandle = UserDefaults.standard.string(forKey: "social_handle")
   
    var userFirstName = ""
    var userLastName = ""
    var sex : Bool = true
    
    
    
    private var db = Firestore.firestore()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var inviteStatusLabel: UILabel!
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    @IBOutlet weak var statsLabel: UILabel! //likes
    @IBOutlet weak var sharesLabel: UILabel!
    
    
    
    @IBOutlet weak var selfieView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet var backgroundView: UIView!
    
    
    @IBOutlet weak var messageTextView: UITextView!
    
    
    @IBOutlet weak var getTicketButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageTextView.layer.cornerRadius = 20
        
        
        
        
        self.subView.layer.cornerRadius = 15
        self.subView.layer.shadowColor = daygerColor.cgColor
        self.subView.layer.shadowOpacity = 0.75
        self.subView.layer.shadowOffset = .zero
        self.subView.layer.shadowRadius = 3
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        
        self.selfieView.layer.cornerRadius = selfieView.bounds.width / 2
        self.selfieView.layer.shadowColor = UIColor.black.cgColor
        self.selfieView.layer.shadowOpacity = 0.25
        self.selfieView.layer.shadowOffset = .zero
        self.selfieView.layer.shadowRadius = 2
        
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            incomingURL = sd.url
            eventID = sd.event
            //works
        }
        
        self.getEventDetails()
        
        print("This is the event ID, from the invitation VC: \(eventID)")
        print("This is the incoming URL: \(incomingURL)")
        // Do any additional setup after loading the view.
    }
    
    func getEventDetails () {
        db.collection("users").document("\(currentUserEmail!)").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                let data = document.data()
                
                let firstname = data?["firstname"] as! String
                let lastname = data?["lastname"] as! String
                let sex = data?["sex"] as! Bool
                
                self.userFirstName = firstname
                self.userLastName = lastname
                self.sex = sex
            }
        }
        
        
        
        db.collection("active_events").document("\(eventID)").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let eventName = data?["name"] as! String
                   let eventTime = data?["time"] as! String
                   let eventDate = data?["date"] as! String
                   
                   let firstname = data?["firstname"] as! String
                   let lastname = data?["lastname"] as! String
                   let host = data?["uid"] as! String //the hosts ID for now
                   let inviteStatus = data?["closed_invite"] as! Bool
                   
                   let shares = data?["shares"] as! Int
                   let likes = data?["likes"] as! Int
                
                   let anonymous = data?["anonymous"] as! Bool
                
                
                let storageRef = Storage.storage().reference(withPath: "user_selfies/\(host).jpg")
                storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] data, error in
                    if let error = error {
                        
                        print("there was a problem fetching selfie \(error.localizedDescription)")
                    }
                    if let data = data {
                        self?.selfieImage.image = UIImage(data: data)
                    }
                }
                
                if inviteStatus == false {
                    //this means its open invite
                    self.inviteStatusLabel.text = "Open Invite"
                    self.additionalInfoLabel.text = "This event will go straight to your feed!"
                    self.messageTextView.isEditable = false
                    self.messageTextView.text = "N/A"
                    
                } else {
                    
                    if inviteStatus == true {
                        self.inviteStatusLabel.text = "Closed Invite"
                        self.additionalInfoLabel.text = "The host must verify your request for this event..."
                        
                    }
                    
                }
                if anonymous == false {
                    
                    self.hostLabel.text = "Host | \(firstname) \(lastname )"
                    
                } else {
                    
                    if anonymous == true {
                        
                        self.hostLabel.text = "Host | Anonymous"
                        self.selfieView.backgroundColor = UIColor.white
                        self.selfieImage.alpha = 0.03
                    }
                }
                
                
                self.statsLabel.text = "\(likes)"
                self.sharesLabel.text = "\(shares)"
                self.dateLabel.text = eventDate
                self.timeLabel.text = "@\(eventTime)"
                self.nameLabel.text = eventName
                self.requestedEventName = "\(eventName)"
                  
            }
            if error != nil {
            //document does not exist
                self.nameLabel.text = "This event no longer exists :("
                self.hostLabel.alpha = 0
                self.selfieView.alpha = 0
                self.dateLabel.alpha = 0
                self.timeLabel.alpha = 0
                self.inviteStatusLabel.text = "You'll get em' next time..."
                self.additionalInfoLabel.alpha = 0
                self.getTicketButton.isEnabled = false
                self.getTicketButton.alpha = 0.3
            }
        }
    }
    
    @IBAction func getTicketButtonTapped(_ sender: Any) {
        
        
        db.collection("users").document(currentUserEmail!).collection("requests").document(eventID).getDocument { [self] (document, error) in
            if document?.exists == true {
                
                let alert = UIAlertController(title: "Whoa There!", message: " It seems that you already have your ticket to this event, or it is still in your queue!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:  nil ))
                
                self.present(alert, animated: true, completion: nil)
                return
               
        } else {
        
        
        if checkIfProfileCompleted() == false {
            
            let alert = UIAlertController(title: "Profile not completed", message: "To continue with Dayger, please ensure that your personal profile is completed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:   nil
                ))
            self.present(alert, animated: true, completion: nil)
        
        } else {
        
        if checkIfAtTicketCapacity() == true {
            let alert = UIAlertController(title: "Ticket limit reached", message: "It seems you have too many tickets right now. You can delete some by tapping the trash button located on the top left of each ticket.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            
        
        } else {
            
        let userAcceptedInfo = GuestListDataModel(eventID: eventID, firstname: userFirstName, lastname: userLastName, uid: userID, icename: iceName!, icenumber: iceNumber!, sex: sex, social: socialHandle!, email : currentUserEmail!)
      
        let userInfo = VerificationDataModel(firstname: userFirstName, lastname: userLastName, guestUid: userID, event: requestedEventName, docID: eventID , handle: socialHandle!, icename: iceName!, icenumber: iceNumber!, sex: sex , email: currentUserEmail!)
        //this adds the ticket to the hosts queue
        print("ticket request sent")
        print(userInfo.dictionary)
        
        db.collection("active_events").document("\(eventID)").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let inviteStatus = data?["closed_invite"] as! Bool
            
                  
                let hostEmail = data?["email"] as! String
                
                
                if inviteStatus == false {
                    //this means its open
                    db.collection("active_events").document(eventID).collection("guest_list").document(currentUserEmail!).setData(userAcceptedInfo.dictionary)
                    
                    
                    
                    db.collection("users").document(self.currentUserEmail!).collection("requests").document("\(eventID)").setData(["accepted" : true , "docID" : "\(eventID)"])

                    //this adds the document to the users guest list array or verification array. either or depending
                    
                    
                    
                    let alert = UIAlertController(title: "Got it!", message: "Head over to the home screen and refresh your feed to get your ticket.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:{[self] action in
                        self.transitionToHome()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                   
                    db.collection("users").document(self.currentUserEmail!).collection("requests").document("\(eventID)").setData(["accepted" : false, "docID" : "\(eventID)"] )
                    
                    db.collection("users").document("\(hostEmail)").collection("inbox").document(currentUserEmail!).setData(userInfo.dictionary)
                   
                    db.collection("users").document(self.currentUserEmail!).updateData(["clout" : FieldValue.increment(Int64(1))])
                    
                    db.collection("users").document("\(hostEmail)").updateData(["clout" : FieldValue.increment(Int64(1))])
                    
                    
                    let alert = UIAlertController(title: "This ticket has been added to your queue.", message: "The host of this event has recieved your ticket request.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:{[self] action in
                        self.transitionToHome()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                    
                    //add data to the hosts verification list.
                    //this means its closed invite

                        //works
                        //this sends a request the host for the specified event. All of the information is retrieved from the users end and sent to the hosts end through firebase.
                    
                        
                    }
                }
            }
        }
    }
        //filler for this function
        }
    }
}



   
    
    
    func checkIfAtTicketCapacity () -> Bool {
        //we will eventually incorporate requested events
        
        if  UserDefaults.standard.integer(forKey: "tickets") >= 10 {
            return true
            
        } else {
            return false
        }
    }
   

    
    
    func transitionToHome (){
        //back button
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
       
        
    }
    func checkIfProfileCompleted() -> Bool {
        if UserDefaults.standard.bool(forKey: "profilecompleted") == false {
            
            
            return false
            
        } else {
          
            return true
    }
        
    }
    func transitionToProfile () {
        //transition to profile
        let profileViewController =
            self.storyboard?.instantiateViewController(identifier: "profileVC")
        
        self.view.window?.rootViewController = profileViewController
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

