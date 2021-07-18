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

    
    private let mapViewManager = MKMapView()
   
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // all regarding Ticket View. The data in these strings are going to be sourced from same document in firebase
    
    @IBOutlet weak var bitMojiImage: UIImageView!
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
    //FinalizeButton
    

    
    
    
    
    
    let ticketArray = [StoredTicketInfo]()
   
    var latitude : Double = 0
    var longitude : Double = 0
    var qrCodeConfig : Bool = true
    var inviteConfig : Bool = true
    var live : Bool = false
    var atCapacity = false
    var anonymous = false
    
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
      //formatting map View UI
        self.mapViewUI.layer.cornerRadius = 10
        self.mapViewUI.layer.shadowColor = UIColor.black.cgColor
        self.mapViewUI.layer.shadowOpacity = 0.25
        self.mapViewUI.layer.shadowOffset = .zero
        self.mapViewUI.layer.shadowRadius = 2
        
        
        
        assignTicketDataLabels()
        displayMapCoordinates()
        formatTicketView()
        generateQRCode()
       
    }
    
    func formatTicketView () {
        
        
        self.ticketView.layer.cornerRadius = 10
        self.ticketView.layer.borderWidth = 1.75
        self.ticketView.layer.borderColor = UIColor.black.cgColor
        // ticket
        
        self.qrCodeView.layer.cornerRadius = 5
        self.qrCodeView.layer.shadowOpacity = 0.25
        self.qrCodeView.layer.shadowOffset = .zero
        self.qrCodeView.layer.shadowRadius = 2
        
        
        
    }
    
    
    
    
    func assignTicketDataLabels() {
        
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
                   
                
               
                
                
                self.timeLabel.text = "@\(time)"
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
        
        
        
        db.collection("users").document("\(currentUserEmail!)").getDocument(source: .cache) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Cached document data: \(dataDescription)")
                
                
                let docData = document.data()
                let firstName : String  = docData?["firstname"] as! String
                let lastName : String = docData?["lastname"] as! String
                
                let userInformation = "\(firstName)-\(lastName)"
                
                //grabs document data
                //
                
                // all of this is for the qr code input
                let qrCodeInput = "\(self.userID)" + "-\(userInformation)"
               
                
                //this is going to be out first input for now: User ID + Name
                let data = qrCodeInput.data(using: .ascii , allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "inputMessage")
                    
                let img = UIImage(ciImage: (filter?.outputImage)!)
                
                self.QRImage.image = img
                
                
            } else
            
            {
             
            }
         }
    }
    
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.transitionToCreateEventVC()
    }
    
    func transitionToCreateEventVC () {
        
        let creatEventVC =
       
            self.storyboard?.instantiateViewController(identifier: "createEventVC")
        
        self.view.window?.rootViewController =  creatEventVC 
        self.view.window?.makeKeyAndVisible()
        //function for transitioning to Party Manager
    }
    
    func getCoordinates () {
        
        
        
        
    }
    
    
    
    @IBAction func finalizeButtonTapped(_ sender: Any) {
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
        let firstname = UserDefaults.standard.string(forKey: "First_Name")!
        let lastname = UserDefaults.standard.string(forKey: "Last_Name")!
            
            
       //for the bottom/////////// we wanna eventually store the data up top into the users own thing
        var ref:DocumentReference? = nil
   
        
        
        //let docData : [String : Any] = ["address": address , "date" : date ,"event_name" : name , "time" : time , "uid" : uid ]
            //all of this information will be stored in the "Active Events Collection"
            //we will retrieve this data later on when creating tickets
            
        //we need to implement a function that deletes the data 24 hours after the event time.
        
        
        
       // db.collection("active_events").document().setData(docData) //were gonna store this into a different route
        //print("data has been stored, but we still want this data somewhere else")
        ///------------------------------------
            let newEvent = StoredTicketInfo(name: name, date: date, time: time, address: address, firstname: firstname , lastname: lastname, location: GeoPoint(latitude: lat, longitude: lon), additionalInformation: additionalInfo, qrCode: self.qrCodeConfig, closed_invite: self.inviteConfig , live : self.live , atCapacity: self.atCapacity , anonymous: self.anonymous )
        //remember this part it is important!!!
 
        ref = self.db.collection("active_events").addDocument(data: newEvent.dictionary) {error in
            if let error = error {
                print("Error Adding Document \(error.localizedDescription)")
                
            }else{
                print("Document added with ID: \(ref!.documentID)")
                let docID = ref?.documentID
               
               
                
                self.db.collection("active_events").document(docID!).setData(["docID" : docID! as String , "uid" : "\(uid)"] , merge: true ){error in
                    if let error = error {
                        
                        print("Error Adding Document \(error.localizedDescription)")}else{
                            
                        print("documentID, document has been finalized")
                            //below data function is used to store data into users personal account info
                            self.db.collection("users").document("\(self.currentUserEmail!)").collection("active_events").document(docID!).setData(newEvent.dictionary)
                            //we could clean this up (added on data)
                            self.db.collection("users").document("\(self.currentUserEmail!)").collection("active_events").document(docID!).setData(["docID": docID!] , merge: true)
                    }
                }
            }
        }
            
            
         
        //self.transitionToHostManagementVC()
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
    
    
    func transitionToHostManagementVC () {
        
       let hostManagementVC =
        
        self.storyboard?.instantiateViewController(identifier: "hostManagementVC")
    
    self.view.window?.rootViewController = hostManagementVC
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
    
    
    
    

