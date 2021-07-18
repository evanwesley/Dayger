//
//  snapchatViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/17/21.
//

import UIKit
import SCSDKLoginKit


class snapchatViewController: UIViewController {
// this whole view controller's purpose is to retrieve the users snapchat data.
    
    
    
    @IBOutlet weak var connectToSnapButton: UIButton!
//
    @IBOutlet weak var whySnapButton: UIButton!
    //explains to the user how snapchat is used with the app
    
    
    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    let variables = ["page": "bitmoji"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func snapchatButtonPressed(_ sender: Any) {
        
        
        SCSDKLoginClient.login(from: self, completion: { success, error in

              if let error = error {
                  print(error.localizedDescription)
                  return
              }

              if success {
                  self.fetchSnapUserInfo() //example code
                  self.transitionToHome() 
                //this code works. The user has not been logged in yet however.
              }
          })
        
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
