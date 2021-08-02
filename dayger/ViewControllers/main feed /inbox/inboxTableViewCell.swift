//
//  inboxTableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 7/13/21.
//

import UIKit
import Firebase
import FirebaseDatabase
    



class inboxTableViewCell: UITableViewCell {
    //8 variables to be transfer from verification data model to guest list data model
    
    var firstname = ""
    var lastname = ""
    
    var guestUid : String? = ""//uid
    var docID : String? = ""//
     //uid
   // var event = "" //ig this is event name // might not need
   //eventID
    var sex = ""
    var handle = "" //social
    
   //example data for now
    let iceName = "Evan Wesley"
    let iceNumber = "2145634977"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!

    
    var cellData = [VerificationDataModel]()
    
    let db = Firestore.firestore()
    //going to be passed from verification data model
    
    
    
    weak var delegate : inboxTableViewCellDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.acceptButton.addTarget(self, action: #selector(acceptButtonTapped(_:)), for: .touchUpInside)
          
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        
        let data : [String : Any] = [
            "firstname" : firstname , "lastname" : lastname , "uid" : guestUid! , "eventID" : docID! , "icenumber" : iceNumber , "icename" : iceName , "social" : handle , "sex" : sex ]
        

        db.collection("active_events").document("JTrJ8F92cL2MYlXXCfYK").collection("guest_list").addDocument(data: data)
            
        //this function should add everything into the guest list view controller
        
        
        // deletes document, next adds to queue
        
        db.collection("users").document("\(currentUserEmail!)").collection("inbox").document("\(docID!)").delete()
        
        
        
        
        if let guestUID = guestUid {
            self.delegate?.inboxTableViewCell(self, acceptButtonTappedFor: guestUID)

            
        }
    }
}
protocol inboxTableViewCellDelegate: AnyObject {
  func inboxTableViewCell(_ inboxTableViewCell: inboxTableViewCell, acceptButtonTappedFor guest: String)
    
    
}
