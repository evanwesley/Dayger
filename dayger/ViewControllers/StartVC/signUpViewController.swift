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
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let borderColor : UIColor = UIColor(red: 230/255.0, green: 165/255.0, blue: 98/255.0, alpha: 0.8)

    //this is to continue to the snapchatview controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.backgroundColor = UIColor.white
        self.passwordTextField.backgroundColor = UIColor.white
        self.firstNameTextField.backgroundColor = UIColor.white
        self.lastNameTextField.backgroundColor = UIColor.white
        self.sexTextField.backgroundColor = UIColor.white
        
        self.emailTextField.layer.borderColor = borderColor.cgColor
        self.passwordTextField.layer.borderColor = borderColor.cgColor
        self.firstNameTextField.layer.borderColor = borderColor.cgColor
        self.lastNameTextField.layer.borderColor = borderColor.cgColor
        self.sexTextField.layer.borderColor = borderColor.cgColor
        
        self.emailTextField.layer.borderWidth = 1.5
        self.passwordTextField.layer.borderWidth = 1.5
        self.firstNameTextField.layer.borderWidth = 1.5
        self.lastNameTextField.layer.borderWidth = 1.5
        self.sexTextField.layer.borderWidth = 1.5
        
        self.emailTextField.layer.cornerRadius = 5
        self.passwordTextField.layer.cornerRadius = 5
        self.firstNameTextField.layer.cornerRadius = 5
        self.lastNameTextField.layer.cornerRadius = 5
        self.sexTextField.layer.cornerRadius = 5

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
                   if err != nil {
                       self.showError("Error creating user")
                    
                       
                   }
                   else {
                       
                       //store first name and last name under the userEmail document
                       let db = Firestore.firestore()
                       
                    db.collection("users").document("\(userEmail)").setData(["firstname":firstname, "lastname":lastname, "uid": result!.user.uid,"email address": email ]) { (error) in
                           
                      
                        
                           if error != nil {
                               self.showError("Email has already been used")
                            
                            db.collection("users").document("\(userEmail)").collection("profile").document("personal_information").setData(["firstname":firstname, "lastname":lastname, "uid": result!.user.uid])
                            //this sets data into the profile component
                            
                           }
                       }
                   }
               }
           
               //transition to home screen
             self.transitionToHome()
          
               
               
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
               self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? homeViewController
           
           self.view.window?.rootViewController = homeViewController
           self.view.window?.makeKeyAndVisible()
           
       }
    

   
}

