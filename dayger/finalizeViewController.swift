//
//  finalizeViewController.swift
//  dayger
//
//  Created by Evan Wesley on 6/7/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import MapKit
import CoreLocation





class finalizeViewController: UIViewController {

    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    private let mapViewManager = MKMapView()
   
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
    // all regarding Ticket View. The data in these strings are going to be sourced from same document in firebase
    
 
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var qrCodeView: UIView!
    
    //ticketView

    @IBOutlet weak var mapViewUI: UIView!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    //Map View in general
    @IBOutlet weak var toggleView: UIView!
    
    @IBOutlet weak var toggleQRCodeSwitch: UISwitch!
    @IBOutlet var toggleInviteCodeSwitch: UISwitch!
    
    @IBOutlet weak var finalizeButton: UIButton!
    
    @IBOutlet weak var hostLabel: UILabel!
    //FinalizeButton
    

    
    
    
    
    
    let ticketArray = [StoredTicketInfo]()
   
    var latitude : Double = 0
    var longitude : Double = 0
    var qrCodeConfig : Bool = true
    var inviteConfig : Bool = true
    var live : Bool = false
    var atCapacity = false
    var anonymous = false
    var userFirstname : String = ""
    var userLastname : String = ""
    
    let userID = (Auth.auth().currentUser?.uid)!
    
    
    private var db = Firestore.firestore()
    public let currentUserEmail = Auth.auth().currentUser!.email
    
    

    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderColor : UIColor = UIColor(red: 230/255.0, green: 165/255.0, blue: 98/255.0, alpha: 0.8)
        
        self.mapView.layer.cornerRadius = 5
        self.mapView.layer.borderColor = borderColor.cgColor
        self.mapView.layer.shadowColor = UIColor.black.cgColor
        self.mapView.layer.shadowOpacity = 0.25
        self.mapView.layer.shadowOffset = .zero
        self.mapView.layer.shadowRadius = 2
        //formatting the map view
        self.toggleView.layer.cornerRadius = 10
       // self.toggleView.layer.borderColor = UIColor.black.cgColor
        //self.toggleView.layer.borderWidth = 1.75
        self.toggleView.layer.shadowColor = UIColor.black.cgColor
        self.toggleView.layer.shadowOpacity = 0.25
        self.toggleView.layer.shadowOffset = .zero
        self.toggleView.layer.shadowRadius = 2
        
        
        
        //formatting map View UI
        self.mapViewUI.layer.cornerRadius = 10
        self.mapViewUI.layer.shadowColor = UIColor.black.cgColor
        self.mapViewUI.layer.shadowOpacity = 0.25
        self.mapViewUI.layer.shadowOffset = .zero
        self.mapViewUI.layer.shadowRadius = 2
     
        
        
        self.qrCodeView.layer.magnificationFilter = CALayerContentsFilter.nearest
        
        getUserFirstLastName()
        assignTicketDataLabels()
        displayMapCoordinates()
        formatTicketView()
        generateQRCode()
        
        print("\(userLastname)")
        print("\(userFirstname)")
       
    }
    
    func formatTicketView () {
        //formats everything
        
        self.ticketView.layer.cornerRadius = 10
        self.ticketView.layer.borderWidth = 1.75
        self.ticketView.layer.borderColor = UIColor.orange.cgColor
        // ticket
        
        self.ticketView.layer.shadowColor = UIColor.black.cgColor
        self.ticketView.layer.shadowOpacity = 0.3
        self.ticketView.layer.shadowOffset = .zero
        self.ticketView.layer.shadowRadius = 2
        
        
        self.qrCodeView.layer.cornerRadius = 5
        self.qrCodeView.layer.shadowOpacity = 0.25
        self.qrCodeView.layer.shadowOffset = .zero
        self.qrCodeView.layer.shadowRadius = 2
        
        self.circleView.layer.cornerRadius = 25
        self.circleView.layer.shadowColor = UIColor.black.cgColor
        self.circleView.layer.shadowOpacity = 0.25
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
        self.view.layoutIfNeeded()
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        let image = UserDefaults.standard.object(forKey: "selfie_image") as? Data
        let defaultImage = UserDefaults.standard.object(forKey: "default_image") as! Data
        
        selfieImage.image = UIImage(data: image ?? defaultImage)
    
        //selfie
        
        
    }
    func getUserFirstLastName () {
        //getting users first and last name. Assigned below
        db.collection("users").document("\(currentUserEmail!)").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   let firstname = data?["firstname"] as! String
                   let lastname = data?["lastname"] as! String
               
                //we could move this line of code
                
                self.userFirstname = firstname
                self.userLastname = lastname
                
                self.hostLabel.text = "\(self.userFirstname) \(self.userLastname)"
                
           }
            
        }
        
    }
    
    
    
    
    func assignTicketDataLabels() {
        
        getUserFirstLastName()
   
        db.collection("users").document("\(currentUserEmail!)").collection("events").document("event-1").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   
                
                   //
                   let time = data?["time"] as! String
                   print ("\(time)")
                   //for the time label obviously
                   let date = data?["date"] as! String
                   print ("\(date)")
                   //date
                   let eventName = data?["event-name"] as! String
                   print ("\(eventName)")
                   //event name
                   
                
               
                
                
                self.timeLabel.text = "\(time)"
                self.dateLabel.text = date
                self.eventNameLabel.text = eventName
                
         
               } else {
                   print("Document does not exist")
               }
        }
        //This function works omg. I am so happy holy shit.
        // maybe we have to format like this from now on.
        
    }
    func displayMapCoordinates () {
        
        db.collection("users").document("\(currentUserEmail!)").collection("events").document("event-1").getDocument(source: .cache) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Cached document data: \(dataDescription)")
                
            //We need to put snapshots in the file scope. So we don't have to call them every time.
                
                let data = document.data()
                //grabs document data
                let coordinates = data?["location(coordinates)"]
                let point = coordinates as! GeoPoint
                //converts data from document into Longitude and latitude
                let lat = point.latitude
                let lon = point.longitude
                //centers the mapView on the specified location.
                let initialLocation = CLLocation(latitude: lat , longitude: lon )
                self.mapView.centerToLocation(initialLocation)
            //All in regards to structuring the map view.///////////////
                
                let location = data?["location(name)"] as! String
                self.locationLabel.text = "\(location)"
                //sets location label to the users inputted location
                //below sets the pin for the location on map
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                //we can maybe add a title
                self.mapView.addAnnotation(annotation)
                // yessir/////////////this is an object
                
            } else {
              print("Document does not exist in cache")
            }
        }
    }
    
    @IBAction func toggleQRCodePressed(_ sender: Any) {
        
        if toggleQRCodeSwitch.isOn {

            QRImage.alpha = 1
            qrCodeConfig = true
            //we are going to generate custom qr code for our user here
            //going to add boolean value to firebase
        } else{
            //turns off the value in firebase
            QRImage.alpha = 0.20
            qrCodeConfig = false
        }
        print(qrCodeConfig)
    }
    
    @IBAction func toggleInvitePressed(_ sender: Any) {
       if toggleInviteCodeSwitch.isOn {
            
           inviteConfig = true
            
       }else {
        
        inviteConfig = false
        
       }
     print(inviteConfig)
    }
   
    func generateQRCode () {
                
                // all of this is for the qr code input
                let qrCodeInput = "This is Your QR CODE!!"
        
                //this is going to be out first input for now: User ID + Name
                let data = qrCodeInput.data(using: .ascii , allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "inputMessage")
                    
                let img = UIImage(ciImage: (filter?.outputImage)!)
                
                self.QRImage.image = img
       }

    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "finalizeUW", sender: self)
    }
    
    func transitionToCreateEventVC () {
        
        let creatEventVC =
       
            self.storyboard?.instantiateViewController(identifier: "createEventVC")
        
        self.view.window?.rootViewController =  creatEventVC 
        self.view.window?.makeKeyAndVisible()
        //function for transitioning to Party Manager
    }
    
    
    @IBAction func finalizeButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Event Created", message: "Go to your clipboard to see your event and share it!.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {  [self] action in
        self.present(alert, animated: true, completion: nil)
        self.transitionToHomeVC()
        }))
        //this function is for pulling data from firebase, this may be the only way I know how to pull the information.
        db.collection("users").document("\(currentUserEmail!)").collection("events").document("event-1").getDocument(source: .cache) { (document, error) in
       
            
        if let document = document {
          let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
          print("Cached document data: \(dataDescription)")
            
        //We need to put snapshots in the file scope. So we don't have to call them every time.
            
            let data = document.data()
            //grabs document data
            let coordinates = data?["location(coordinates)"]
            let point = coordinates as! GeoPoint
            //converts data from document into Longitude and latitude
            let lat = point.latitude
            let lon = point.longitude
            
       
      
            let additionalInfo = data?["additionalInformation"] as! String
            let address = self.locationLabel.text!
            let date = self.dateLabel.text!
            let name = self.eventNameLabel.text!
            let time = self.timeLabel.text!
            let uid = "\(self.userID)"
            
            
            
            
            let userName = self.nameLabel.text!.components(separatedBy: " ")
            //separates the text. There is def a better way to do this but I am too lazy.
            print("\(userName)")
            let firstname = userName[0]
            let lastname = userName[1]
            
        var ref:DocumentReference? = nil
   
            let newEvent = StoredTicketInfo(name: name, date: date, time: time, address: address, firstname: firstname , lastname: lastname, location: GeoPoint(latitude: lat, longitude: lon), additionalInformation: additionalInfo, qrCode: self.qrCodeConfig, closed_invite: self.inviteConfig , live : self.live , atCapacity: self.atCapacity , anonymous: self.anonymous , likes: 0 , shares: 0  )
        //remember this part it is important!!!
 
        ref = self.db.collection("active_events").addDocument(data: newEvent.dictionary) {error in
            if let error = error {
                print("Error Adding Document \(error.localizedDescription)")
                
            }else{
                print("Document added with ID: \(ref!.documentID)")
                let docID = ref?.documentID
               
               
                
                self.db.collection("active_events").document(docID!).setData(["docID" : docID! as String , "uid" : "\(uid)", "email" : self.currentUserEmail!] , merge: true ){ [self]error in
                    if let error = error {
                        
                        print("Error Adding Document \(error.localizedDescription)")}else{
                            
                        print("documentID, document has been finalized")
                            //below data function is used to store data into users personal account info
                            self.db.collection("users").document("\(self.currentUserEmail!)").collection("active_events").document(docID!).setData(newEvent.dictionary)
                            
                            
                            //we could clean this up (added on data)
                            self.db.collection("users").document("\(self.currentUserEmail!)").collection("active_events").document(docID!).setData(["docID": docID! , "email" : self.currentUserEmail!] , merge: true)
                            
                          
                    }
                }
            }
        }
            self.transitionToHomeVC() //fuck this function I need an alert controller to pop up telling the user where their event is located.
            self.db.collection("users").document(self.currentUserEmail!).updateData(["clout" : FieldValue.increment(Int64(5))])
            
    }
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toYourEvents" {
                if let vc = segue.destination as? eventViewController{
                    vc.comingFromFinalizeVC = true
                }
          }
    }
    
    
    func transitionToHomeVC () {
        
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
            
            db.collection("users").document("\(currentUserEmail!)").collection("events").document("event-1").getDocument(source: .cache) { (document, error) in
                if let document = document {
                  let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                  print("Cached document data: \(dataDescription)")
                    
                    
                    let data = document.data()
                    //grabs document data
                    let coordinates = data?["location(coordinates)"]
                    let point = coordinates as! GeoPoint
                    //converts data from document into Longitude and latitude
                    let lat = point.latitude
                    let lon = point.longitude
                    print("\(lat)") //not necessary anymore
                    print("\(lon)") //not necessary anymore
                    //centers the mapView on the specified location.
                    let initialLocation = CLLocation(latitude: lat , longitude: lon )
                    self.mapView.centerToLocation(initialLocation)
                //All in regards to structuring the map view.///////////////
                    
                    let location = data?["location(name)"] as! String
                    self.locationLabel.text = "\(location)"
                    //sets location label to the users inputted location
                    //below sets the pin for the location on map
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    // yessir/////////////idk why this isn't working
                    //bro we need the pin. adding this to the todo list
                } else {
                  print("Document does not exist in cache")
      }
    }
  }
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
    
    
    
    

