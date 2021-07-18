//
//  signUpViewController.swift
//  dayger
//
//  Created by Evan Wesley on 3/4/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class signUpViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    //we are trying to make this variable accesible throughout the project, that is why it is public.
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    //this is to continue to the snapchatview controller
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextButton.alpha = 0.25
        self.nextButton.isEnabled = false

        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
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
            UserDefaults.standard.set(firstNameTextField.text, forKey: "First_Name")
            
            
            UserDefaults.standard.set(lastNameTextField.text, forKey: "Last_Name")
              
               
               
               //transition to home screen
             //  self.transitionToHome()
            self.nextButton.alpha = 1
            self.nextButton.isEnabled = true 
           
               
               
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

