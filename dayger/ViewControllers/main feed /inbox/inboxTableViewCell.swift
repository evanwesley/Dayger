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
    
    
   

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!

    
    var cellData = [VerificationDataModel]()
    
    let db = Firestore.firestore()
    var guest : String?
    var docID : String?
    
    
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
        
        print("This is \(docID!)") //quality control
        
        
        
        
        // deletes document, next adds to queue
        
        db.collection("users").document("\(currentUserEmail!)").collection("inbox").document("\(docID!)").delete()
        
        if let guest = guest {
            self.delegate?.inboxTableViewCell(self, acceptButtonTappedFor: guest)
            
        }
    }
}
protocol inboxTableViewCellDelegate: AnyObject {
  func inboxTableViewCell(_ inboxTableViewCell: inboxTableViewCell, acceptButtonTappedFor guest: String)
    
    
}
