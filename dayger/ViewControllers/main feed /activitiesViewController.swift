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
import AudioToolbox

//Why the fuck did I call this the activities view controller? Who knows.
class activitiesViewController: UIViewController {
   
    @IBOutlet var mainView: UIView!
    //configured based on the state of the ticket
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var qrImage: UIImageView!
    

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
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
    
    
    
    
    var uid = ""
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
    
    
    //for the likes and shares
    var sharesCount : Int = 0
    var fun : Int = 0

    var likes : Int = 0
    var shares : Int = 0
    
    
    let userID = (Auth.auth().currentUser?.uid)!
    let db = Firestore.firestore()
    
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
        
        self.qrImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        //allows the QRcode to render properly
    
        //top view
        
        
        
        
        //self.addressView.layer.shadowColor = UIColor.black.cgColor
        //self.addressView.layer.shadowOpacity = 0.25
        //self.addressView.layer.shadowOffset = .zero
        //self.addressView.layer.shadowRadius = 3
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        self.mapView.layer.cornerRadius = 10
        self.mapView.layer.masksToBounds = true
        
        self.buttonView.layer.cornerRadius = 30
        self.buttonView.layer.shadowColor = UIColor.black.cgColor
       self.buttonView.layer.shadowOpacity = 0.25
       self.buttonView.layer.shadowOffset = .zero
       self.buttonView.layer.shadowRadius = 2
        
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        
        self.circleView.layer.cornerRadius = circleView.bounds.width / 2
        
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOpacity = 0.25
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
        
        
        // address view
        self.displayMapCoordinates()
        self.displayHostSelfie()
        
        self.configureInviteState()
        self.configureQRCodeState()
        //migos reference
        // Do any additional setup after loading the view.
        self.assignData()
        self.generateQRCode()
        
        self.listenForSharesData()
        
        
        if isSelected == true {
            
            self.likeButton.isSelected = true
        } else {
            
            self.likeButton.isSelected = false
            
        }
        
        print("this shit works") //indeed it does
        print(generateQRCodeInput())
        print(seperateQRCodeInput())
        
    }
    
    func listenForSharesData () {
        
        db.collection("active_events").document("\(eventID)")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                
                let liveShares = data["shares"] as! Int
                
                self.shares = liveShares
                
                
                
                
                print("Current shares: \(String(describing: data["shares"]))")
            }
        
        
        
        
    }
    
    func assignData() {
        //this function is going to be for all the data stuff
       
        
        self.timeLabel.text = "\(time)" //switching these bc Im too lazy ugh.
        self.dateLabel.text = "\(date)"
        self.addressTextView.text = "@ \(address)"
        self.InfoTextField.text = "\(additionalInfo)"
        ticketName.text = name
        self.likesLabel.text = "\(likes)"
        self.sharesLabel.text = "\(shares)"
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
            self.selfieImage.alpha = 0.035
            self.circleView.backgroundColor = UIColor.white
            
        } else {
            
            self.hostLabel.text = "Host | \(hostFirstName) \(hostLastName)"
            self.selfieImage.alpha = 1
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
    
    func displayHostSelfie () {
        
        let storageRef = Storage.storage().reference(withPath: "user_selfies/\(uid).jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] data, error in
            if let error = error {
                
                print("there was a problem fetching data for the event \(self!.name) : \(error.localizedDescription)")
            }
            if let data = data {
                self?.selfieImage.image = UIImage(data: data)
            }
        }

        
        
        
        
        
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
        
        self.isSelected = true
        //so the text labels initial value wont be mutated
        let likesRef = db.collection("active_events").document("\(eventID)")
        
        let liked = likeButton.isSelected
        //is selected means liked
        
        if liked == true {
            
            likesLabel.text = "\(likes + 1)"
         //not initial function
        } else{
            self.isSelected = false
            likesLabel.text = "\(likes)"
            //do not need to do -1 because that is initial value
        }
        return
        
        
        //gonna have to add boolean stuff
    }
    
    

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        
        sharesCount = sharesCount + 1
        print(sharesCount)
        
        
        self.sharesLabel.text = "\(shares + 1)"
        
        let sharesRef = db.collection("active_events").document("\(eventID)")
        
        
        sharesRef.updateData(["shares": shares + 1])
        //updates the data when the button is tapped
        
        
        return
    
        
        
    }
    
    @IBAction func funButtonTapped(_ sender: Any) {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { } //the button is going to vibrate
        
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
