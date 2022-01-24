//
//  verifiedViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/30/21.
//

import UIKit
import Firebase
import FirebaseStorage

class verifiedViewController: UIViewController {

    var firstname = ""
    var lastname = ""
    var uid = ""
    var social = ""
    let generator = UINotificationFeedbackGenerator()
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = 124
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        
        self.circleView.layer.cornerRadius = 125
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOpacity = 0.25
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
       
        
        self.assignLabels()
        self.displayHostSelfie()
        
        generator.notificationOccurred(.success)
        // Do any additional setup after loading the view.
    }
    
    func assignLabels(){
        
        
        self.nameLabel.text = "\(firstname) \(lastname)!"
        self.socialLabel.text = "\(social)"
        
        
    }
    func displayHostSelfie () {
        //guest
        let storageRef = Storage.storage().reference(withPath: "user_selfies/\(uid).jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                
                print("there was a problem fetching data: \(error.localizedDescription)")
            }
            if let data = data {
                self?.selfieImage.image = UIImage(data: data)
            }
        }
    }
}
