//
//  inboxDetailsViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/13/21.
//

import UIKit

class inboxDetailsViewController: UIViewController {

    var guestName = ""
    
    var guestUid  = ""
    //guest name
    var handle  = ""
    //social media
    var age  = ""
    
    var sex = "" // we are going to have to import those symbols
    
    @IBOutlet weak var sexLabel: UILabel!
    //Will display various sexes, however it will be boolean. Female, or not female.
    @IBOutlet weak var ageLabel: UILabel!
    //this will be determined from snapchat and permanent
    @IBOutlet weak var handleLabel: UILabel!
    //social media handle
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.detailView.layer.cornerRadius = 15
        self.detailView.layer.borderColor = UIColor.black.cgColor
        self.detailView.layer.borderWidth = 1.75
        
        self.backgroundView.alpha = 0.5
        // Do any additional setup after loading the view.
        
        self.retrieveData()
  
    }
    
    func retrieveData(){
        
        
        self.nameLabel.text = "\(guestName)"
        self.ageLabel.text = "Age: \(age)"
        self.handleLabel.text = "@\(handle)"
        self.sexLabel.text = "Sex: \(sex)"
        
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
