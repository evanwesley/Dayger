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
import FirebaseStorage


import SCSDKLoginKit
import SCSDKBitmojiKit

class profileViewController: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    let variables = ["page": "bitmoji"]
    
    var snapName = ""
    var snapBitmoji = ""
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    @IBOutlet weak var iceName1TextField: UITextField!
    @IBOutlet weak var iceNumber1TextField: UITextField!
    @IBOutlet weak var iceName2TextField: UITextField!
    //this is now social media!!
    @IBOutlet weak var iceNumber2TextField: UITextField!
    //this is now nickname!!
    @IBOutlet weak var saveLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var iceStackViewBg: UIView!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var topView: UIView!
   
    
    @IBOutlet weak var selfieImage: UIImageView!
    @IBOutlet weak var circleView: UIView!
   
    @IBOutlet weak var uploadButton: UIButton!
   
    @IBOutlet weak var uploadProgressView: UIProgressView!
    
    let userID = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = Auth.auth().currentUser!.email
    
    
    //For Bitmoji
    
  

    private var db = Firestore.firestore()
    
    var iconView = SCSDKBitmojiIconView()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uploadProgressView.isHidden = true
       
        self.iconView.alpha = 1
        
        //for the text fields
   
       
       
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
        self.iceName1TextField.layer.borderWidth = 1.75
        self.iceNumber1TextField.layer.borderWidth = 1.75
        self.iceName2TextField.layer.borderWidth = 1.75
        self.iceNumber2TextField.layer.borderWidth = 1.75
        //corner radius
        self.iceNumber1TextField.layer.cornerRadius = 5.0
        self.iceName1TextField.layer.cornerRadius = 5.0
        self.iceNumber2TextField.layer.cornerRadius = 5.0
        self.iceName2TextField.layer.cornerRadius = 5.0
        
        //in regards to background
        self.iceStackViewBg.layer.cornerRadius = 10
        self.iceStackViewBg.layer.borderWidth = 1.75
        self.iceStackViewBg.layer.borderColor = UIColor.black.cgColor
        self.uidLabel.text = "User ID: \(userID)"
        
        //when information is saved
        saveLabel.alpha = 0
        //for retrieving data
        self.setUpTopView() // for the user photo and bitmoji piece
        
        print("This is \(snapName)")
        print("This is the Bitmoji URL \(snapBitmoji)")
        
        self.getUserFirstLastName()
        //yeeyee we need this bro. I am so glad we figured this roadbump out now we can actually continue with the database. Such a simple solution. June 5 2021
        
        //current user email is the tree want.
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    func getUserFirstLastName () {
        //getting users first and last name. Assigned below
        db.collection("users").document("\(currentUserEmail!)").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let firstname = data?["firstname"] as! String
                   let lastname = data?["lastname"] as! String
               
                //we could move this line of code
                //we could also use this code to add the verified checkmark to certain users
                self.nameLabel.text = "\(firstname) \(lastname)"
                
           }
            
        }
        
   
    }
    
    func savePhoto() {
        //save
        self.uploadProgressView.isHidden = false
        let uploadRef = Storage.storage().reference().child("user_selfies").child("\(userID).jpg")
        guard let uploadImage = self.selfieImage.image?.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
       
        let taskReference = uploadRef.putData(uploadImage, metadata: uploadMetadata) { downloadMetadata, error in
            if let error = error {
                print("there was an error uploading your selfie \(error.localizedDescription)")
            return
            }
            print("Success in uploading your selfie \(String(describing: downloadMetadata))")
        }
        taskReference.observe(.progress) {[weak self] (snapshot) in
           
            guard let prctComplete = snapshot.progress?.fractionCompleted else {return}
          
            print("you are \(prctComplete) there")
            self?.uploadProgressView.progress = Float(prctComplete)
            
            
            
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
          
        let selfieImage = selfieImage.image!.pngData()
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
            UserDefaults().set(selfieImage, forKey: "selfie_image") //sets the selfie image in user defaults
            
        let currentUserEmail = Auth.auth().currentUser!.email
        //using this, we can recieve the users email. I don't really know how else to recieve user email so we will need to have someone do that.
        let docData: [String : Any] = ["ICE-Name-1" : iceName1 , "ICE-Number-1" : iceNumber1 , "social_handle" : socialHandle, "nickname" : nickname]
        let userEmail = db.collection("users").document("\(currentUserEmail!)")
        //userEmail refers to the document that holds all the underlying information. Essentially, is the account.
            self.savePhoto()
        
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
               
               return "Please fill in all fields and provide a profile picture"
           }
           
           return nil
           
        
           
           
       }
    
    func setUpTopView () {
        
        self.view.layoutIfNeeded()
        //works
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        
        let image = UserDefaults.standard.object(forKey: "selfie_image") as? Data
        let defaultImage = UserDefaults.standard.object(forKey: "default_image") as! Data
        
        selfieImage.image = UIImage(data: image ?? defaultImage)
     
      
        //this view will contain the image of the person
        self.circleView.layer.cornerRadius = 50
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOpacity = 0.25
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
        
     
        
        
        self.topView.layer.cornerRadius = 10
        self.topView.layer.shadowColor = UIColor.black.cgColor
        self.topView.layer.shadowOpacity = 0.25
        self.topView.layer.shadowOffset = .zero
        self.topView.layer.shadowRadius = 2
        
        let iceName = UserDefaults.standard.string(forKey: "iceName")
        let iceNumber = UserDefaults.standard.string(forKey: "iceNumber")
        let socialHandle = UserDefaults.standard.string(forKey: "social_handle")
        let nickname = UserDefaults.standard.string(forKey: "nickname")
      
        
        
        
        iceName1TextField.text = iceName
        iceNumber1TextField.text = iceNumber
        iceName2TextField.text = socialHandle
        iceNumber2TextField.text = nickname
        
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.transitionToHome()
    
    }
    func transitionToHome (){
        //back button
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
       
        
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
    
        
        self.selfieImage.image = image
        
        dismiss(animated: true)
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

