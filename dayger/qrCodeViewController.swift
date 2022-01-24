//
//  qrCodeViewController.swift
//  dayger
//
//  Created by Evan Wesley on 12/12/21.
//

import UIKit
import Firebase



class qrCodeViewController: UIViewController {
    
    
    var eventID = ""
    let userID = (Auth.auth().currentUser?.uid)!
    
    
    @IBOutlet weak var eventLabel: UILabel!
    
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        self.eventLabel.text = "Event ID: \(eventID)"

        self.generateQRCode()
        // Do any additional setup after loading the view.
    }
    
    func generateQRCodeInput() -> String {
        //the string for the qr code
    let qrCodeInput : String = "\(self.userID)" + "_\(self.eventID)"
        
        return qrCodeInput
    }
    
    func generateQRCode() {
        
        let data = self.generateQRCodeInput().data(using: .ascii , allowLossyConversion: false)
         
         let filter = CIFilter(name: "CIQRCodeGenerator")
         filter?.setValue(data, forKey: "inputMessage")
             
         let img = UIImage(ciImage: (filter?.outputImage)!)
         
         
        self.qrImage.image = img
        
        // let qrCodeItems = qrCodeInput.components(separatedBy: "_ "
        
    }
    func seperateQRCodeInput () -> Array<Any> {
    
         let qrCodeItems = generateQRCodeInput().components(separatedBy: "_")
         //works
        
        return qrCodeItems
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
