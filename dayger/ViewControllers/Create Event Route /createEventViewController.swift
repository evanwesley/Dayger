//
//  createEventViewController.swift
//  dayger
//
//  Created by Evan Wesley on 1/17/21.
//





import UIKit
import FirebaseDatabase
import Firebase
import SCSDKBitmojiKit
import SCSDKCoreKit
import SCSDKLoginKit

class createEventViewController: UIViewController, UITextViewDelegate



{
    
 
    
    //Top Half View Controller
  
    //This will be sourced from snapchat
    //Bottom Half View
    
    
    
  
    @IBOutlet weak var circleView: UIView!
   
    @IBOutlet weak var selfieImage: UIImageView!
    
    
    @IBOutlet weak var stackViewBg: UIView!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var additionalInfoTextView: UITextView!
   
    @IBOutlet var continueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    let datePicker = UIDatePicker()
    let db = Firestore.firestore()
        override func viewDidLoad() {
        super.viewDidLoad()
        
        //infotext is the text view. Following code it Textboxt setup
        let borderColor : UIColor = UIColor(red: 230/255.0, green: 165/255.0, blue: 98/255.0, alpha: 0.8)
        //for the border
        self.additionalInfoTextView.layer.borderColor = borderColor.cgColor
        self.additionalInfoTextView.layer.borderWidth = 1.5
        let infotext = additionalInfoTextView
        infotext!.delegate = self
        infotext!.text = "This is where you can inform your guests of any more details. Is there a theme? Will there be a preformer? Any Rules? Is this a birthday party, a meeting, a fun cookout, or a small kickback? Let your guests know!"
        infotext!.textColor = UIColor.lightGray
        infotext!.layer.cornerRadius = 5
        //following code is in regards to text fields
        self.eventNameTextField.backgroundColor = UIColor.white
        self.dateTextField.backgroundColor = UIColor.white
        self.timeTextField.backgroundColor = UIColor.white
        self.capacityTextField.backgroundColor = UIColor.white
        
        self.eventNameTextField.layer.borderColor = borderColor.cgColor
        self.dateTextField.layer.borderColor = borderColor.cgColor
        self.timeTextField.layer.borderColor = borderColor.cgColor
        self.capacityTextField.layer.borderColor = borderColor.cgColor
        
        self.eventNameTextField.layer.borderWidth = 1.5
        self.dateTextField.layer.borderWidth = 1.5
        self.timeTextField.layer.borderWidth = 1.5
        self.capacityTextField.layer.borderWidth = 1.5
        
        self.eventNameTextField.layer.cornerRadius = 5
        self.dateTextField.layer.cornerRadius = 5
        self.timeTextField.layer.cornerRadius = 5
        self.capacityTextField.layer.cornerRadius = 5
    
        self.stackViewBg.layer.cornerRadius = 10
        self.stackViewBg.layer.borderColor = UIColor.black.cgColor
        self.stackViewBg.layer.borderWidth = 1.75
            
            self.circleView.layer.cornerRadius = 25
            self.circleView.layer.shadowColor = UIColor.black.cgColor
            self.circleView.layer.shadowOpacity = 0.25
            self.circleView.layer.shadowOffset = .zero
            self.circleView.layer.shadowRadius = 2
            
            self.view.layoutIfNeeded()
            self.selfieImage.layer.masksToBounds = true
            self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
            self.selfieImage.layer.borderWidth = 2
            self.selfieImage.layer.borderColor = UIColor.white.cgColor
            let image = UserDefaults.standard.object(forKey: "selfie_image") as? Data
            let defaultImage = UserDefaults.standard.object(forKey: "default_image") as! Data
            
            selfieImage.image = UIImage(data: image ?? defaultImage)
         
            
        createTimePicker()
        createDatePicker()
            
            //add to ensure datepicker and timepicker are working
            
            
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    } 
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            //we want to make it so that if user starts editing the text goes away but if there is no user text, placeholder stays.
        }

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
   
    @IBAction func continueButtonTapped(_ sender: Any) {
        //when this button is tapped we are adding all the information into firebase
        let db = Firestore.firestore()
        let currentUserEmail = Auth.auth().currentUser!.email
        let userEmail = db.collection("users").document("\(currentUserEmail!)")
        //this is all necessary for us to be able to go down the right document/selection path
        
        
        let eventName = eventNameTextField.text!
        let eventDate = dateTextField.text!
        let eventTime = timeTextField.text!
        let capacity = capacityTextField.text!
        let additionalInformation = additionalInfoTextView.text!
        //This means that we need to implement a function where everything must be filled in.
        //for capacity we might want to have this be automatic.
        
        let docData : [String : Any] = ["event-name": eventName , "date": eventDate, "time" : eventTime, "additionalInformation" : additionalInformation]
        
        let eventInformation = userEmail.collection("events").document("event-1")
        
        eventInformation.setData(docData, merge: true)
        
        
        
        
        
        //adds the event information into the equation
        self.transitionToFinalizeVC()
    
    }
    
    func transitionToFinalizeVC () {
        
        let finalizeTicketVC =
       
            self.storyboard?.instantiateViewController(identifier: "finalizeTicketVC")
        
        self.view.window?.rootViewController =  finalizeTicketVC
        self.view.window?.makeKeyAndVisible()
        //function for transitioning to Party Manager
        
        
        
        
        
        
    }
    func createDatePicker () {

        datePicker.preferredDatePickerStyle = .wheels //we might wanna change this to the modern date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil , action: #selector(donePressedDate))
        toolbar.setItems([doneButton], animated: true)
        
  
        
        dateTextField.inputAccessoryView = toolbar
        
       // assign button
        dateTextField.inputView = datePicker
        
        //just show the date
        datePicker.datePickerMode = .dateAndTime
        
        
    }
    //this function corresponds to the function above
    @objc func donePressedDate() {
        dateTextField.text = "\(datePicker.date)"
        self.view.endEditing(true)
        //formatter for the date text field.
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateTextField.text = formatter.string(from: datePicker.date)
        UserDefaults.standard.set(formatter.string(from: datePicker.date), forKey: "eventCreation:Date")
    }
    //for the time
    func createTimePicker() {
        
        datePicker.preferredDatePickerStyle = .wheels //we might wanna change this to the modern date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil , action: #selector(donePressedTime))
        toolbar.setItems([doneButton], animated: true)
        
        timeTextField.inputAccessoryView = toolbar
        
       // assign button
        timeTextField.inputView = datePicker
        
        //just show the time
        datePicker.datePickerMode =  .time //eventually we can merge date and time. For now, we riding solo.
        //like right now the datepicker is displaying both components. I literally have no idea why we don't have an individual time picker but whatever works is cool. This line of code is basically not needed. 
    }
    @objc func donePressedTime() {
        timeTextField.text = "\(datePicker.date)"
        self.view.endEditing(true)
        //formatter for the date text field.
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
       timeTextField.text = formatter.string(from: datePicker.date)
       UserDefaults.standard.set(formatter.string(from: datePicker.date), forKey: "eventCreation:Time")
        //this user default should be a placeholder for the text field
    
    }
    // This group of functions are in regards to saving the text fields
    @IBAction func createEventTextFieldDidStopEditing(_ sender: Any) {
        
        if let eventName = eventNameTextField.text , eventName.isEmpty  {
            return print("text field is empty, did not save")
            //in regards to creating hte event
        }
        else if let eventName = eventNameTextField.text{
            
            UserDefaults.standard.set(eventName, forKey: "eventCreation:Name")
           
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let eventName = UserDefaults.standard.string(forKey: "eventCreation:Name")
        let date = UserDefaults.standard.string(forKey: "eventCreation:Date")
        let time = UserDefaults.standard.string(forKey: "eventCreation:Time")
        
        eventNameTextField.text = eventName
        dateTextField.text = date
        timeTextField.text = time
        //this function is in regards to saving the text fields when the location VC is pushed. This saves all of the text even when exiting the app
        
        db.collection("users").document("\(currentUserEmail!)").collection("events").document("event-1").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
               
                let location = data?["location(name)"] as! String
                self.capacityTextField.text = location
                //retrieves the information from firebase. Eventually we want to have it so the label view controller send information directly into the text field. For now we are going to wait.
            
            }
        }
    }
}
extension createEventViewController : UITextFieldDelegate {
    
    @IBAction func transitionToLocationPicker(_ sender: Any) {
        
        self.instantiateLocationPicker()
    
    
    }
    func instantiateLocationPicker() {
        
        let locationPicker = self.storyboard?.instantiateViewController(identifier: "locationPickerVC")
        self.view.window?.rootViewController = locationPicker
        self.view.window?.makeKeyAndVisible()
    }
    
    
    
    
}
