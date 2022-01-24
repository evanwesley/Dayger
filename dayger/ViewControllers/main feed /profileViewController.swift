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
import AudioToolbox

class profileViewController: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let generator = UINotificationFeedbackGenerator()
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
    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var saveView: UIView!
    
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
    
    @IBOutlet weak var whatsThisButton: UIButton!
    
    //For Bitmoji
    @IBOutlet weak var friendsButton: UIButton!
    
  

    private var db = Firestore.firestore()
    
    var iconView = SCSDKBitmojiIconView()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var cloutPointsLabel: UILabel!
    
    override func viewDidLoad() {
       
        
        self.buttonView.layer.cornerRadius = 20
        self.buttonView.layer.shadowColor = UIColor.orange.cgColor
        self.buttonView.layer.shadowOpacity = 0.25
        self.buttonView.layer.shadowOffset = .zero
        
        self.uploadProgressView.isHidden = true
        
        self.iconView.alpha = 1
        
        self.saveView.layer.cornerRadius = 20
        self.saveView.layer.shadowColor = UIColor.gray.cgColor
        self.saveView.layer.shadowOpacity = 0.25
        self.saveView.layer.shadowOffset = .zero
        //for the text fields
   
       
       
        //using this, we can recieve the users email. I don't really know how else to recieve user email so we will need to have someone do that.
        
        
       
        
        let backgroundcolor : UIColor = UIColor.white
      
        // Do any additional setup after loading the view.
        //in regards to text fields background color 
        self.iceName1TextField.layer.backgroundColor = backgroundcolor.cgColor
        self.iceNumber1TextField.layer.backgroundColor = backgroundcolor.cgColor
        self.iceName2TextField.layer.backgroundColor = backgroundcolor.cgColor
        self.iceNumber2TextField.layer.backgroundColor = backgroundcolor.cgColor
        //shadows
        self.iceNumber1TextField.layer.shadowColor = UIColor.gray
            .cgColor
        self.iceNumber1TextField.layer.shadowOpacity = 0.25
        self.iceNumber1TextField.layer.shadowOffset = .zero
        self.iceNumber1TextField.layer.shadowRadius = 2
        
        self.iceName1TextField.layer.shadowColor = UIColor.gray
            .cgColor
        self.iceName1TextField.layer.shadowOpacity = 0.25
        self.iceName1TextField.layer.shadowOffset = .zero
        self.iceName1TextField.layer.shadowRadius = 2
        
        self.iceNumber2TextField.layer.shadowColor = UIColor.gray
            .cgColor
        self.iceNumber2TextField.layer.shadowOpacity = 0.25
        self.iceNumber2TextField.layer.shadowOffset = .zero
        self.iceNumber2TextField.layer.shadowRadius = 2
        
        self.iceName2TextField.layer.shadowColor = UIColor.gray
            .cgColor
        self.iceName2TextField.layer.shadowOpacity = 0.25
        self.iceName2TextField.layer.shadowOffset = .zero
        self.iceName2TextField.layer.shadowRadius = 2
        
       
        
        
        
        
        //corner radius
        self.iceNumber1TextField.layer.cornerRadius = 25
        self.iceName1TextField.layer.cornerRadius = 25
        self.iceNumber2TextField.layer.cornerRadius = 25
        self.iceName2TextField.layer.cornerRadius = 25
        
        
        
        //in regards to background
       
        self.uidLabel.text = "User ID: \(userID)"
        
        //when information is saved
   
        //for retrieving data
        self.setUpTopView() // for the user photo and bitmoji piece
        
        print("This is \(snapName)")
        print("This is the Bitmoji URL \(snapBitmoji)")
        
        self.getUserFirstLastName()
        self.retrieveData()
        //yeeyee we need this bro. I am so glad we figured this roadbump out now we can actually continue with the database. Such a simple solution. June 5 2021
        
        let swipe : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileViewController.keyboardDismiss))
        
        view.addGestureRecognizer(swipe)
        //current user email is the tree want.
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardDismiss() {
        view.endEditing(true)
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
        guard let uploadImage = self.selfieImage.image?.jpegData(compressionQuality: 0.5) else {
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
            
            if prctComplete == 100 {
                self?.uploadProgressView.alpha = 0
            }
            
        }
    
    }
    func retrieveData(){
        
        db.collection("users").document("\(currentUserEmail!)").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let bio = data?["bio"] as? String
                   let clout = data!["clout"] as? Int
               
                if bio == nil {
                    self.bioTextView.text = "No bio yet"
                    
                } else {
                    self.bioTextView.text = bio
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
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
      let error = validateFields()
        //save text into firebase
        if error != nil {
            
            let alert = UIAlertController(title: "Profile not complete.", message: "\(String(describing: error))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
          
        let selfieImage = selfieImage.image!.pngData()
        let iceName1 = iceName1TextField.text!
        let iceNumber1 = iceNumber1TextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let bio = bioTextView.text!
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
            let docData: [String : Any] = ["ICE-Name-1" : iceName1 , "ICE-Number-1" : iceNumber1 , "social_handle" : socialHandle, "nickname" : nickname, "bio" : bio ]
        let userEmail = db.collection("users").document("\(currentUserEmail!)")
        //userEmail refers to the document that holds all the underlying information. Essentially, is the account.
            self.savePhoto()
        
        //omg literally all you have to do is unwrap the optional
        
            
            
        //apparently the document that I am describing above may not exist, therefore, swift is creating document references that are no existent. We need to fix this.
        
        //Update June 3rd fixed, reference S.0
        userEmail.setData(docData, merge: true)
        //store and append data into firebase
        
        //this appends following information to firebase database
        
         
        //this ensures that the user has set up their profile completely.
        UserDefaults.standard.set(true, forKey: "profilecompleted")
            
            let alert = UIAlertController(title: "Saved!", message: "Your personal profile has been updated", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
        self.present(alert, animated: true, completion: nil)
        }
        
    }
    func validateFields() -> String? {
           
           //check that all fields filled in
        let delCharSet = NSCharacterSet(charactersIn: "@")
        //this is for deleting the @ key
        if iceNumber1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || iceName1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || iceName2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || iceName2TextField.text?.trimmingCharacters(in: delCharSet as CharacterSet) == "" {
           //bio added
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
    
    @IBAction func whatsThisTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "In Case of Emergency Contact.", message: "Safety is a priority for us at Dayger. For your safety, we require that you provide the contact name and number of the person who should be notified if you are in danger. This could be your best friend, roomate, or even a parent. If need be, only the host of an event you attend has access to this information. Thank you for understanding!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil
            ))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func friendsButtonTapped(_ sender: Any) {
        
        generator.notificationOccurred(.success)
        
        
    }
    
    
    
    @IBAction func unwindToProfileVC(segue: UIStoryboardSegue) {

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

