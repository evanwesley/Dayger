//
//  snapchatViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/17/21.
//

import UIKit
import Firebase
import FirebaseAuth


class snapchatViewController: UIViewController {
// this whole view controller's purpose is to clean the users ticket array
    
    
    let userID = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = Auth.auth().currentUser!.email
    
   
   //fuck snapchat
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

        // Do any additional setup after loading the view.
    }
    
    
    
    
        
   
    
    func transitionToHome (){
        let homeViewController =
            self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? homeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
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
