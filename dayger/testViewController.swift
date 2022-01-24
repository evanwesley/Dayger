//
//  testViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/13/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class testViewController: UIViewController {
    
    let userID = (Auth.auth().currentUser?.uid)!
    public let currentUserEmail = Auth.auth().currentUser!.email
    let db = Firestore.firestore()
    
    @IBOutlet weak var inboxButton: UIButton!
    
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var eventIDTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    //in regards to the qr code function
    
    var incomingUID = ""
    
    var incomingEventID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func inboxButtonTapped(_ sender: Any) {
        
        let sex : [Int:String] = [1:"M" , 2: "F"]
        let handle : [Int:String] = [1 : "cranappleradio", 2: "817evan" , 3: "sosa" , 4: "frat_g0d" , 5 : "art_junkie" , 6 : "big30"]
        let age : [Int:String] = [1:"16", 2: "21" , 3:"25" , 4: "18", 5:"23"]
        
        let nameData : [Int : String] = [ 1:"Evan", 2: "Gigi" , 3 : "Max" , 4 : "Alex", 5 : "Ellis" , 6 : "Laura"]
        
        let lastNameData : [Int : String] = [ 1:"Delgado", 2: "Lancisi" , 3 : "Antinone" , 4 : "Boydstun", 5 : "Wesley" , 6 : "Jovien"]
        
        
        let eventData : [Int : String] = [1 : "Nicks Kickback" , 2 : "SF Trip" , 3 : "Dinner at Mas" , 4 : "Saturdayge" , 5 : "Pi Kapp Latenight"]
        
        let invite_accepted : [Int : Bool] = [1 : true , 2 : false]
        
        let uid = userID
        

        let ref =
        self.db.collection("users").document("\(currentUserEmail!)").collection("inbox").document()
        
       // let docID = ref.documentID
        let docID = "JTrJ8F92cL2MYlXXCfYK"
        print("document \(docID) added to inbox")
        
        self.db.collection("users").document("\(currentUserEmail!)").collection("inbox").document().setData(["firstname":nameData[Int.random(in: 1..<7)]! , "lastname" : lastNameData[Int.random(in: 1..<7)]! , "guestUid" : "\(uid)" , "invite_accepted" : invite_accepted[Int.random(in: 1..<3)]! , "event" : eventData[Int.random(in: 1..<6)]! , "docID" : "JTrJ8F92cL2MYlXXCfYK", "sex" : sex[Int.random(in: 1..<3)]! , "handle" : handle[Int.random(in: 1..<7)]! , "age" : age[Int.random(in: 1..<6)]!])
        
        
        //doc ID is hard coded. This will change eventually
    }
    
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        
       
        
        self.verifyInvite()
        //Works
        
    }
    
    
    
    
    func verifyInvite () {
        //this is going to verify the data when the qr code is scanned
        
        self.incomingUID = userIDTextField.text!
        self.incomingEventID = eventIDTextField.text!
        
        
        let uid = "Evan"
        let eventID = "0920"
        
        if incomingUID == uid && incomingEventID != eventID {
            print("This guest is invited but they may have the wrong ticket! Make sure they are using the right ticket")
        } else if incomingUID != uid && incomingEventID == eventID {
            print("Uh oh! It seems that this guest isn't on the Guestlist")
            
            
            
        } else if incomingUID != uid && incomingEventID != eventID {
            
            print("This ticket is invalid")
            
            
        } else if incomingUID == uid && incomingEventID == eventID {
            
            
            print("Welcome in Evan! ")
            //picture shown next
            
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
