//
//  startViewController.swift
//  dayger
//
//  Created by Evan Wesley on 2/22/21.
//

import UIKit



class startViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var defaultImage: UIImageView!
    
    

    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    let variables = ["page": "bitmoji"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.defaultImage.alpha = 0
        let defaultImage = defaultImage.image!.pngData()
        UserDefaults().set(defaultImage, forKey: "default_image") //sets a user default for profile image

        // Do any additional setup after loading the view.
    }
    
    
   
    
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
