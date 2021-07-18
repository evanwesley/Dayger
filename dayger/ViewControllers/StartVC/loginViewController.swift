//
//  loginViewController.swift
//  dayger
//
//  Created by Evan Wesley on 12/29/20.
//

import UIKit
import FirebaseAuth
class loginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let borderColor : UIColor = UIColor(red: 230/255.0, green: 165/255.0, blue: 98/255.0, alpha: 0.8)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.backgroundColor = UIColor.white
        self.passwordTextField.backgroundColor = UIColor.white
       
        
        self.emailTextField.layer.borderColor = borderColor.cgColor
        self.passwordTextField.layer.borderColor = borderColor.cgColor
     
        
        self.emailTextField.layer.borderWidth = 1.5
        self.passwordTextField.layer.borderWidth = 1.5
     
     
        
        self.emailTextField.layer.cornerRadius = 5
        self.passwordTextField.layer.cornerRadius = 5
       
        
        
        
        
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        //validate text fields
        //create cleaned versions
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //sign in user
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let homeViewController =
                    self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? homeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                
                
                
            }
        }
    }
}
