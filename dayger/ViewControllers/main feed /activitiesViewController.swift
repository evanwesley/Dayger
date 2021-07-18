//
//  activitiesViewController.swift
//  dayger
//
//  Created by Evan Wesley on 5/31/21.
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit
import CoreLocation

//Why the fuck did I call this the activities view controller? Who knows.
class activitiesViewController: UIViewController {
   
    @IBOutlet var mainView: UIView!
    //configured based on the state of the ticket
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var qrImage: UIImageView!
    
    @IBOutlet weak var bitMoji: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hostLabel: UILabel!
    
    @IBOutlet weak var addressTextView: UITextView!
    
    
    @IBOutlet weak var ticketName: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
   
    
    @IBOutlet weak var InfoTextField: UITextView!
    
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var liveLine: UIView!
    
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet var inviteLabel: UILabel!
    @IBOutlet var qrCodeLabel: UILabel!

    
    var isSelected:Bool = false
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var funButton: UIButton!
    
    
    
    
    
    var hostFirstName = ""
    var hostLastName = ""
   //we are going to append these together and display them on the ticket view
   
    var date = ""
    var time = ""
    var name = ""
    var address = ""
    var additionalInfo = ""
    
    var closedInvite: Bool = true
    var qrCode : Bool = true
    var live : Bool = true
    var anonymous : Bool = true

    
    var lat : Double = 0 //inital value until mutated
    var lon : Double = 0
    
    var eventID = "" //this is the docID //will be fed into a QR Code
    
   
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    let passiveColor = UIColor(red: 231/255.0, green: 230/255.0, blue: 223/255.0, alpha: 1)
    
    //Test Data
    let randomInt = Int.random(in: 100..<400) //likes
    let randomInt2 = Int.random(in: 500..<1200) //shares
    var sharesCount : Int = 0
    var fun : Int = 0
    
    
    let userID = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomView.layer.cornerRadius = 10
        
        self.bottomView.layer.borderColor = UIColor.black.cgColor
            
        self.bottomView.layer.borderWidth = 1.75
       // self.bottomView.layer.shadowColor = UIColor.black.cgColor
       // self.bottomView.layer.shadowOpacity = 0.25
       // self.bottomView.layer.shadowOffset = .zero
       // self.bottomView.layer.shadowRadius = 3
       //bottom View
        
        self.topView.layer.cornerRadius = 10
        //self.topView.layer.borderColor = UIColor.black.cgColor
    
        //self.topView.layer.borderWidth = 1.75
        
        self.topView.layer.shadowColor = UIColor.black.cgColor
       self.topView.layer.shadowOpacity = 0.25
       self.topView.layer.shadowOffset = .zero
       self.topView.layer.shadowRadius = 2
        
        //top view
        
        
        
        
        //self.addressView.layer.shadowColor = UIColor.black.cgColor
        //self.addressView.layer.shadowOpacity = 0.25
        //self.addressView.layer.shadowOffset = .zero
        //self.addressView.layer.shadowRadius = 3
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        self.mapView.layer.cornerRadius = 10
        self.mapView.layer.masksToBounds = true
        
        self.buttonView.layer.cornerRadius = 10
        self.buttonView.layer.shadowColor = UIColor.black.cgColor
       self.buttonView.layer.shadowOpacity = 0.25
       self.buttonView.layer.shadowOffset = .zero
       self.buttonView.layer.shadowRadius = 2
        
        
        
        // address view
        self.displayMapCoordinates()
  
        self.configureInviteState()
        self.configureQRCodeState()
        //migos reference
        // Do any additional setup after loading the view.
        self.assignData()
        self.generateQRCode()
        
        
        print("this shit works") //indeed it does
        print(generateQRCodeInput())
        print(seperateQRCodeInput())
        
    }
    
    func assignData() {
        //this function is going to be for all the data stuff
       
        
        self.timeLabel.text = "@\(time)" //switching these bc Im too lazy ugh.
        self.dateLabel.text = "\(date)"
        self.addressTextView.text = "@ \(address)"
        self.InfoTextField.text = "\(additionalInfo)"
        ticketName.text = name
        self.likesLabel.text = "\(randomInt)"
        self.sharesLabel.text = "\(randomInt2)"
        //test
        
        if live == true {
          //for the live label and fun button which can only be enabled when the party is live!
            liveLabel.alpha = 1
            liveLine.alpha = 1
            
            
        } else {
            mainView.backgroundColor = passiveColor
            funButton.alpha = 0.5
            funButton.isEnabled = false
            liveLabel.alpha = 0.1
            liveLine.alpha = 0.1
        }
        
        if anonymous == true {
            //for the bitmoji
            self.hostLabel.text = "Host | Anonymous"
            self.bitMoji.alpha = 0.25
            
        } else {
            
            self.hostLabel.text = "Host | \(hostFirstName) \(hostLastName)"
            self.bitMoji.alpha = 1
        }
        
        
        
    }
    
    
    
    
    
    func qualityControl () {
        //we'll call this when needed. Inactive for now
        print("This is longitude from activities controller \(lon)")
        print("This is latitude from activities controller \(lat)")
        
        
        print(name)
        print(date)
        print(time)
        
    }

    
    func displayMapCoordinates () {
        
        let eventLocation = CLLocation(
        latitude: lat, longitude: lon )
        
        self.mapView.centerToLocation(eventLocation)
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        let objectAnnotation = MKPointAnnotation()
          objectAnnotation.coordinate = pinLocation
          //objectAnnotation.title = "\(name)" //do we need this?
          self.mapView.addAnnotation(objectAnnotation)
        
        
        
    }
    
    func configureQRCodeState () {
        
        if qrCode == true {
            
            qrCodeLabel.text = "QR Code's Required"
            qrCodeLabel.textColor = UIColor.red
        } else{
            
            qrImage.alpha = 0.10
            
            qrCodeLabel.alpha = 0
        }
     
        
        
    }
    
    func configureInviteState () {
        
        if closedInvite == true {
            
            inviteLabel.text = "Invite Status: Closed"
        } else{
            
            inviteLabel.text = "Invite Status: Open"
        }
        
        
        
        
    }
    

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        //so the text labels initial value wont be mutated
        let liked = likeButton.isSelected
        //is selected means liked
        
        if liked == true {
            
            likesLabel.text = "\(randomInt + 1)"
         //not initial function
        } else{
            
            likesLabel.text = "\(randomInt)"
            //do not need to do -1 because that is initial value
        }
        return
        
        
        //gonna have to add boolean stuff
    }
    
    

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        
        sharesCount = sharesCount + 1
        print(sharesCount)
        
        self.sharesLabel.text = "\(randomInt2 + sharesCount)"
        return
        
    
        
       
        
        
    }
    
    func generateQRCodeInput() -> String {
        //the string for the qr code
    let qrCodeInput : String = "\(self.userID)" + "_\(self.eventID)"
        
       // let qrCodeItems = qrCodeInput.components(separatedBy: "_ ")
        return qrCodeInput
        
    }
    
    func generateQRCode() {
        
        let data = self.generateQRCodeInput().data(using: .ascii , allowLossyConversion: false)
         
         let filter = CIFilter(name: "CIQRCodeGenerator")
         filter?.setValue(data, forKey: "inputMessage")
             
         let img = UIImage(ciImage: (filter?.outputImage)!)
         
         
        self.qrImage.image = img
        
        // let qrCodeItems = qrCodeInput.components(separatedBy: "_ ")
        
        
        
    }
    func seperateQRCodeInput () -> Array<Any> {
    
         let qrCodeItems = generateQRCodeInput().components(separatedBy: "_")
         //works
        
        return qrCodeItems
    }
    
    
    
    
    /*     @IBAction func likeButtonTapped(_ sender: Any) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
