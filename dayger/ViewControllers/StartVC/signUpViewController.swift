//
//  signUpViewController.swift
//  dayger
//
//  Created by Evan Wesley on 3/4/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class signUpViewController: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    //we are trying to make this variable accesible throughout the project, that is why it is public.
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sexTextField: UITextField!
    
    
    var female : Bool? = nil
    var pickerView = UIPickerView()
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let borderColor : UIColor = UIColor(red: 230/255.0, green: 165/255.0, blue: 98/255.0, alpha: 0.8)
    let data = ["Male" , "Female" , "Prefer not to say"]
    //this is to continue to the snapchatview controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        pickerView.delegate = self
        pickerView.dataSource = self
        sexTextField.inputView = pickerView
        
        self.emailTextField.backgroundColor = UIColor.white
        self.passwordTextField.backgroundColor = UIColor.white
        self.firstNameTextField.backgroundColor = UIColor.white
        self.lastNameTextField.backgroundColor = UIColor.white
        self.sexTextField.backgroundColor = UIColor.white
        
        self.emailTextField.layer.shadowColor = UIColor.black
            .cgColor
        self.emailTextField.layer.shadowOpacity = 0.20
        self.emailTextField.layer.shadowOffset = .zero
        self.emailTextField.layer.shadowRadius = 2
        
        
        self.sexTextField.layer.shadowColor = UIColor.black
            .cgColor
        self.sexTextField.layer.shadowOpacity = 0.20
        self.sexTextField.layer.shadowOffset = .zero
        self.sexTextField.layer.shadowRadius = 2
        
        
        self.passwordTextField.layer.shadowColor = UIColor.black
            .cgColor
        self.passwordTextField.layer.shadowOpacity = 0.20
        self.passwordTextField.layer.shadowOffset = .zero
        self.passwordTextField.layer.shadowRadius = 2
        
        self.firstNameTextField.layer.shadowColor = UIColor.black
            .cgColor
        self.firstNameTextField.layer.shadowOpacity = 0.20
        self.firstNameTextField.layer.shadowOffset = .zero
        self.firstNameTextField.layer.shadowRadius = 2
        
        self.lastNameTextField.layer.shadowColor = UIColor.black
            .cgColor
        self.lastNameTextField.layer.shadowOpacity = 0.20
        self.lastNameTextField.layer.shadowOffset = .zero
        self.lastNameTextField.layer.shadowRadius = 2
        
        self.sexTextField.layer.cornerRadius = 5
        self.emailTextField.layer.cornerRadius = 5
        self.passwordTextField.layer.cornerRadius = 5
        self.firstNameTextField.layer.cornerRadius = 5
        self.lastNameTextField.layer.cornerRadius = 5
        

        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        
    }
    func validateFields() -> String? {
           
           //check that all fields filled in
           
           if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           
               
               return "please fill in all fields"
           }
           
           return nil
           
           
           
       }
       
          
       

       @IBAction func signUpTapped(_ sender: Any) {
           
           let error = validateFields()
           
           let userEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //this is going to be used for the database. First level of Database "users" will be headlined with the user email. Eventually we will need to make this more secure. For now, we will assume most emails are unique. Additionally, we will use another level of snapchat verification
        
           if error != nil {
               //something is wrong with the code
               
              showError(error!)
           }
           else{
             
               let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
               
               
               //create user
               Auth.auth().createUser(withEmail:email, password: password) { [self] (result, err) in
                   //check for errors
                   //need to add a completion block
                   if err != nil {
                       self.showError("There was an error creating your account. Please contact customer support.")
                    return
                   }
                   
                   else {
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(password, forKey: "password")
                    UserDefaults.standard.set(true, forKey: "usersignedin")
                   
                    //This will be used to ensure that the user completes their profile before creating events.
                    UserDefaults.standard.set(false, forKey: "profilecompleted")
                    
                    //this is so the user automatically is logged into app if they have signed up before
                    
                       //store first name and last name under the userEmail document
                    let db = Firestore.firestore()
                       
                    db.collection("users").document("\(userEmail)").setData(["firstname":firstname, "lastname":lastname, "uid": result!.user.uid,"email address": email , "sex" : female!]) { (error) in
                           
                      
                        
                           if error != nil {
                            
                               self.showError("Email has already been used")
                            return
                            
                           }
                       }
                   }
               }
            
            
            
           
            let alert = UIAlertController(title: "Notice", message: "By continuing you are agreeing to our Terms of Service and Privacy Policy", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Decline", style: .destructive, handler: nil))
            
            
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler:{ [self] action in transitionToHome() }))

            self.present(alert, animated: true, completion: nil)
               //transition to home screen
             
           }
           //validate fields
           
           //create user
           
           //transition to home screen
       }
    
    
       func showError(_ message:String){
           
           errorLabel.text = message
           errorLabel.alpha = 1
               
               
               
           
       }
//deprecated
       func transitionToHome (){
           let homeViewController =
           self.storyboard?.instantiateViewController(identifier: "homeNavController")
           
           self.view.window?.rootViewController = homeViewController
           self.view.window?.makeKeyAndVisible()

           
       }
    

   
}
extension signUpViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        data[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        sexTextField.text = data[row]
        sexTextField.resignFirstResponder()
        
        if row != 1 {
            
            female = false
           
            print("You are a female : \(String(describing: female))")
            
        } else {
            
            if row == 1 {
            
            female = true
            
                print("You are a female : \(String(describing: female))")
            
        }
            
        }
        
        
    }
    
    
    
    
}

