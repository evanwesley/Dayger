//
//  friendsDetailViewController.swift
//  dayger
//
//  Created by Evan Wesley on 11/15/21.
//

import UIKit
import Firebase

class friendsDetailViewController: UIViewController {
    
    var guestUid = ""
    var handle = ""
    var firstname = ""
    var lastname = ""
    var icename = ""
    var icenumber = ""
    
    var docID = ""
    var sex : Bool = true
    var email = ""
    let db = Firestore.firestore()
    
   
    
    
    @IBOutlet weak var cloutPointsLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var selfieImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var kickButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailView.layer.cornerRadius = 15
        self.detailView.layer.borderColor = UIColor.black.cgColor
        self.detailView.layer.shadowColor = UIColor.black.cgColor
        self.detailView.layer.shadowOpacity = 0.25
        self.detailView.layer.shadowOffset = .zero
        self.detailView.layer.shadowRadius = 2
        // Do any additional setup after loading the view.
        
       
    
        self.displayGuestSelfie()
        self.retrieveData()

        // Do any additional setup after loading the view.
    }
    func displayGuestSelfie () {
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 1
        self.selfieImage.layer.borderColor = UIColor.orange.cgColor
        
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
        
        let guestName = "\(firstname) \(lastname)"
        
        self.handleLabel.text = "\(handle)"
        self.nameLabel.text = guestName
        
        db.collection("users").document(email).getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let bio = data?["bio"] as? String
                let clout = data!["clout"] as? Int
                
               
                if bio == nil {
                    self.descriptionLabel.text = "No bio"
                    
                } else {
                    self.descriptionLabel.text = bio
                }
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
    func transitionToFriends (){
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    
   
    
    @IBAction func removeFriendButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Remove \(firstname) as a friend?", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler:  { [self] action in
            db.collection("users").document(currentUserEmail!).collection("friends").document(email).delete()
           
            db.collection("users").document(email).collection("friends").document(currentUserEmail!).delete()
            
            self.transitionToProfile()
         
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind...", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func transitionToProfile () {
        //transition to profile
        let profileViewController =
            self.storyboard?.instantiateViewController(identifier: "profileVC")
        
        self.view.window?.rootViewController = profileViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
    
}
