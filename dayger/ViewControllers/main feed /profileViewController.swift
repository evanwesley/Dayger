//
//  profileViewController.swift
//  dayger
//
//  Created by Evan Wesley on 2/22/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class profileViewController: UIViewController {
    
  
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    @IBOutlet weak var iceName1TextField: UITextField!
    
    @IBOutlet weak var iceNumber1TextField: UITextField!
    
    @IBOutlet weak var iceName2TextField: UITextField!
    //this is now social media!!
    @IBOutlet weak var iceNumber2TextField: UITextField!
    //this is now nickname!!
    @IBOutlet weak var saveLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var iceStackViewBg: UIView!
   
    @IBOutlet weak var uidLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var placeHolderView: UIView!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    private var db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        let userID = (Auth.auth().currentUser?.uid)!
        

      
        //using this, we can recieve the users email. I don't really know how else to recieve user email so we will need to have someone do that.
        
        
        let uidInfo = "\(userID)"
        
        let backgroundcolor : UIColor = UIColor.white
        let borderColor : UIColor = UIColor(red: 230/255.0, green: 165/255.0, blue: 98/255.0, alpha: 0.8)
        // Do any additional setup after loading the view.
        //in regards to text fields background color 
        self.iceName1TextField.layer.backgroundColor = backgroundcolor.cgColor
        self.iceNumber1TextField.layer.backgroundColor = backgroundcolor.cgColor
        self.iceName2TextField.layer.backgroundColor = backgroundcolor.cgColor
        self.iceNumber2TextField.layer.backgroundColor = backgroundcolor.cgColor
        //border color
        self.iceName1TextField.layer.borderColor = borderColor.cgColor
        self.iceNumber1TextField.layer.borderColor = borderColor.cgColor
        self.iceName2TextField.layer.borderColor = borderColor.cgColor
        self.iceNumber2TextField.layer.borderColor = borderColor.cgColor
        //border
        self.iceName1TextField.layer.borderWidth = 0.75
        self.iceNumber1TextField.layer.borderWidth = 0.75
        self.iceName2TextField.layer.borderWidth = 0.75
        self.iceNumber2TextField.layer.borderWidth = 0.75
        //corner radius
        self.iceNumber1TextField.layer.cornerRadius = 5.0
        self.iceName1TextField.layer.cornerRadius = 5.0
        self.iceNumber2TextField.layer.cornerRadius = 5.0
        self.iceName2TextField.layer.cornerRadius = 5.0
        
        //in regards to background
        self.iceStackViewBg.layer.cornerRadius = 10
        self.iceStackViewBg.layer.borderWidth = 1.75
        self.iceStackViewBg.layer.borderColor = UIColor.black.cgColor
        
        
        
       // self.iceStackViewBg.layer.shadowColor = UIColor.black.cgColor
       // self.iceStackViewBg.layer.shadowOpacity = 0.25
       // self.iceStackViewBg.layer.shadowOffset = .zero
       // self.iceStackViewBg.layer.shadowRadius = 2
        
        self.uidLabel.text = "User ID: \(userID)"
        
        //when information is saved
        saveLabel.alpha = 0
        //for retrieving data
        
        self.setUpTopView() // for the user photo and bitmoji piece
        
        let currentUserEmail = Auth.auth().currentUser!.email
        //yeeyee we need this bro. I am so glad we figured this roadbump out now we can actually continue with the database. Such a simple solution. June 5 2021
        let docRef = db.collection("users").document("\(String(describing: currentUserEmail))")
        //current user email is the tree want.
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                       print("Document data: \(dataDescription)")
                   } else {
                       print("Document does not exist, why is this here?")
                    print("\(String(describing: currentUserEmail!))")
                   }
               }
       
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
      let error = validateFields()
        //save text into firebase
        
        
        
        if error != nil {
            
            saveLabel.alpha = 1
            saveLabel.text = error
            saveLabel.textColor = UIColor.red
            
        } else {
          
           
            
        
        let iceName1 = iceName1TextField.text!
        
        let iceNumber1 = iceNumber1TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //added this for the phone numbers. We will probably change this
        let socialHandle = iceName2TextField.text!
        //this has been changed to social handle
        let nickname = iceNumber2TextField.text!
        //this has been changed to nickname
        
            UserDefaults.standard.set(iceName1, forKey: "iceName")
            UserDefaults.standard.set(iceNumber1, forKey: "iceNumber")
            
            UserDefaults.standard.set(socialHandle, forKey: "social_handle")
            
            UserDefaults.standard.set(nickname, forKey: "nickname")
            
            
        let currentUserEmail = Auth.auth().currentUser!.email
        //using this, we can recieve the users email. I don't really know how else to recieve user email so we will need to have someone do that.
        let docData: [String : Any] = ["ICE-Name-1" : iceName1 , "ICE-Number-1" : iceNumber1 , "social_handle" : socialHandle, "nickname" : nickname]
       
        let userEmail = db.collection("users").document("\(currentUserEmail!)")
        //userEmail refers to the document that holds all the underlying information. Essentially, is the account.
        
        
        //omg literally all you have to do is unwrap the optional
        // apparently the document that I am describing above may not exist, therefore, swift is creating document references that are no existent. We need to fix this.
        
        //Update June 3rd fixed, reference S.0
        userEmail.setData(docData, merge: true)
        //store and append data into firebase
        
        //this appends following information to firebase database
        saveLabel.text = "Updated!"
        saveLabel.alpha = 1
            saveLabel.textColor = UIColor.red
        }
        
        
    }
    func validateFields() -> String? {
           
           //check that all fields filled in
        let delCharSet = NSCharacterSet(charactersIn: "@")
        //this is for deleting the @ key
        if iceNumber1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || iceName1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || iceName2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || iceName2TextField.text?.trimmingCharacters(in: delCharSet as CharacterSet) == "" {
           
            //nickname can be empty
               
               return "Please fill in both ICE fields and provide a Social Media Handle"
           }
           
           return nil
           
        
           
           
       }
    
    func setUpTopView () {
        //this view will contain the image of the person
        
        
        self.circleView.layer.cornerRadius = 50
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOpacity = 0.25
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
        self.placeHolderView.layer.cornerRadius = 48
        //this is gonna be an image
        
        
        
        
        
        
        self.topView.layer.cornerRadius = 10
        self.topView.layer.shadowColor = UIColor.black.cgColor
        self.topView.layer.shadowOpacity = 0.25
        self.topView.layer.shadowOffset = .zero
        self.topView.layer.shadowRadius = 2
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let iceName = UserDefaults.standard.string(forKey: "iceName")
        
        let iceNumber = UserDefaults.standard.string(forKey: "iceNumber")
       
        let socialHandle = UserDefaults.standard.string(forKey: "social_handle")
        
        let nickname = UserDefaults.standard.string(forKey: "nickname")
        
        iceName1TextField.text = iceName
        iceNumber1TextField.text = iceNumber
        iceName2TextField.text = socialHandle
        iceNumber2TextField.text = nickname
        
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
