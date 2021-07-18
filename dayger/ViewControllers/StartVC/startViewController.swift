//
//  startViewController.swift
//  dayger
//
//  Created by Evan Wesley on 2/22/21.
//

import UIKit
import SCSDKLoginKit


class startViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var logoLabel: UILabel!
    
    @IBOutlet weak var snapChatButton: UIButton!
    

    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    let variables = ["page": "bitmoji"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func snapChatButtonTapped(_ sender: Any) {
        SCSDKLoginClient.login(from: self, completion: { success, error in

              if let error = error {
                  print(error.localizedDescription)
                  return
              }

              if success {
                  self.fetchSnapUserInfo() //example code
                //this code works. The user has not been logged in yet however.
              }
          })
        //for the custom login button
    }
    
    
    
    func fetchSnapUserInfo () {
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: variables, success: { (resources: [AnyHashable: Any]?) in
          guard let resources = resources,
            let data = resources["data"] as? [String: Any],
            let me = data["me"] as? [String: Any] else { return }

          let displayName = me["displayName"] as? String
          var bitmojiAvatarUrl: String?
          if let bitmoji = me["bitmoji"] as? [String: Any] {
            bitmojiAvatarUrl = bitmoji["avatar"] as? String
            
            print("\(displayName ?? "nil")")
            print("\(bitmojiAvatarUrl ?? "nil")")
            
          }
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
        })
        
    }
  
    
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
