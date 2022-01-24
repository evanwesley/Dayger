//
//  startViewController.swift
//  dayger
//
//  Created by Evan Wesley on 2/22/21.
//

import UIKit
import FirebaseAuth


class startViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var defaultImage: UIImageView!
    
    

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaultImage.alpha = 0
        let defaultImage = defaultImage.image!.pngData()
        UserDefaults().set(defaultImage, forKey: "default_image") //sets a user default for profile image

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      let loggedInUserEmail =  UserDefaults.standard.string(forKey: "email")
      let loggedInUserPassword =  UserDefaults.standard.string(forKey: "password")
        
        
        if UserDefaults.standard.bool(forKey: "usersignedin") == true {
            Auth.auth().signIn(withEmail: loggedInUserEmail!, password: loggedInUserPassword!, completion: { result, error in
                
                        if error == nil {
                            UserDefaults.standard.set(true, forKey: "usersignedin")
                            UserDefaults.standard.synchronize()
                            print("\(String(describing: result?.user.email!))")
                            
                            let homeViewController =
                            self.storyboard?.instantiateViewController(identifier: "homeNavController")
                            
                            self.view.window?.rootViewController = homeViewController
                            self.view.window?.makeKeyAndVisible()
                            
                        } else {
                            if error != nil {
                                print("user is not logged in, they may need to signup")
                             
           }
        }
    }
)}
}
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
