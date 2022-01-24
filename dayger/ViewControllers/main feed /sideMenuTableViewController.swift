//
//  sideMenuTableViewController.swift
//  dayger
//
//  Created by Evan Wesley on 10/20/21.
//

import UIKit


class sideMenuTableViewController: UITableViewController {
    
    
    @IBOutlet weak var privacyCell: UITableViewCell!
    
    @IBOutlet weak var socialsButton: UIButton!
    
    @IBOutlet weak var loggoutCell: UITableViewCell!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet var sideTableView: UITableView!
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row == 2 && indexPath.section == 1 {
                //sponsered
                print("sponsored")
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

  
    @IBAction func privacyButton(_ sender: Any) {
        //tapped
        let url = URL(string:"https://www.dayger.co/privacy-policy")
        UIApplication.shared.open(url!)
        print("privacy")
        
    }
    
    @IBAction func aboutButtonTapped(_ sender: Any) {
        
        let url = URL(string:"https://www.dayger.co/about")
        UIApplication.shared.open(url!)
        
    }
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        let url = URL(string:"https://www.dayger.co/contact")
        UIApplication.shared.open(url!)
        }
        
    
    func setDay () -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        
        return day
    }
    
    func formatDay () {
        
        let number = setDay()
        
        if number == 1 {
            
            self.dayLabel.text = "Sunday"
            
        } else if number == 2 {
            
            self.dayLabel.text = "Monday"
            
        } else if number == 3 {
            
            self.dayLabel.text = "Tuesday"
            
        } else if number == 4 {
            
            self.dayLabel.text = "Wedenesday"
            
        } else if number == 5 {
            
            self.dayLabel.text = "Thursday"
            
        } else if number == 6 {
            
            self.dayLabel.text = "Friday"
            
        } else if number == 7 {
            
            self.dayLabel.text = "Saturday"
        }
        
    }

    @IBAction func logoutTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Would you like to Logout?", message: "Return to the start menu.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [self] action in
            
            
            UserDefaults.standard.set(false, forKey: "usersignedin")
            UserDefaults.standard.set(false, forKey: "profilecompleted")
            
            
            UserDefaults.standard.removeObject(forKey: "iceName")
            UserDefaults.standard.removeObject (forKey: "iceNumber")
            UserDefaults.standard.removeObject(forKey: "social_handle")
            UserDefaults.standard.removeObject(forKey: "nickname")
            UserDefaults().removeObject(forKey: "selfie_image")
            //removes user defaults
            
            self.transitionToStart()
            
            }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func transitionToStart() {
        //transition to profile
        let startVC =
            self.storyboard?.instantiateViewController(identifier: "startNavigationController")
        
        self.view.window?.rootViewController = startVC
        self.view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func socialsButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Social Media", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Instagram", style: .default, handler: { [self] action in
            
            
        
        }))
        
    }
    
    
    
}
