//
//  messageViewController.swift
//  dayger
//
//  Created by Evan Wesley on 11/25/21.
//

import UIKit
import Firebase



class messageViewController: UIViewController {

    var eventID = ""
    
    let db = Firestore.firestore()
    let currentUserEmail = Auth.auth().currentUser!.email
    let userID = (Auth.auth().currentUser?.uid)!
    
    
    
    @IBOutlet weak var messageTextField: UITextView!
    
    @IBOutlet weak var buttonView: UIView!
    
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTextField.layer.backgroundColor = UIColor.white.cgColor
        self.messageTextField.layer.cornerRadius = 20
       
      
        
        self.buttonView.layer.shadowColor = UIColor.orange.cgColor
        self.buttonView.layer.shadowOpacity = 0.25
        self.buttonView.layer.shadowOffset = .zero
        self.buttonView.layer.shadowRadius = 2
        self.buttonView.layer.cornerRadius = 20

        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func getTime () -> String {
       
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        let formattedDate = formatter.string(from: Date())
        
     return "\(formattedDate)"
        
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
       
        var ref:DocumentReference? = nil
        
        
        let messageInfo = MessageDataModel(message: self.messageTextField.text, timeStamp: getTime(), email: currentUserEmail!, uid: userID, docID: "")
  
        
        ref =
        db.collection("active_events").document(eventID).collection("messages").addDocument(data: messageInfo.dictionary)
       
        let docID = ref?.documentID
        
        db.collection("active_events").document(eventID).collection("messages").document(docID!).updateData(["docID" : docID!])        //adds messages and shit
        
        self.performSegue(withIdentifier: "unwindToContainerVC", sender: self)
        
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
