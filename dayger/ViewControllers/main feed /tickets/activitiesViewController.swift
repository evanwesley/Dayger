//
//  activitiesViewController.swift
//  dayger
//
//  Created by Evan Wesley on 5/31/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDynamicLinks
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
    
    @IBOutlet weak var friendsView: UIView!
    
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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var capacityLabel: UILabel!
    
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet var inviteLabel: UILabel!
    @IBOutlet var qrCodeLabel: UILabel!

    @IBOutlet weak var friendsLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var funButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var buzzView: UIView!
    
    @IBOutlet weak var infoLabelTableView: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var qrButton: UIButton!
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
    var cellData = [GuestListDataModel]()
    var friendsData = [GuestListDataModel]()
    
    var guestListUid : [String] = []
    
    var messageData = [MessageDataModel]()
    
    
    
    let userID = (Auth.auth().currentUser?.uid)!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomView.layer.cornerRadius = 15
        self.bottomView.layer.borderColor = UIColor.white.cgColor
            
        self.bottomView.layer.borderWidth = 1.75
        self.bottomView.layer.shadowColor = UIColor.gray.cgColor
        self.bottomView.layer.shadowOpacity = 0.25
        self.bottomView.layer.shadowOffset = .zero
        self.bottomView.layer.shadowRadius = 3
       //bottom View
        self.topView.layer.cornerRadius = 10
        //self.topView.layer.borderColor = UIColor.black.cgColor
    
        //self.topView.layer.borderWidth = 1.75
        
       self.topView.layer.shadowColor = UIColor.gray.cgColor
       self.topView.layer.shadowOpacity = 0.25
       self.topView.layer.shadowOffset = .zero
       self.topView.layer.shadowRadius = 2
        
        
        
        self.buzzView.layer.cornerRadius = 15
        
        self.qrImage.layer.magnificationFilter = CALayerContentsFilter.nearest
        //allows the QRcode to render properly
    
        //top view
        
     
   
        
        
        //self.addressView.layer.shadowColor = UIColor.black.cgColor
        //self.addressView.layer.shadowOpacity = 0.25
        //self.addressView.layer.shadowOffset = .zero
        //self.addressView.layer.shadowRadius = 3
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        
        self.mapView.layer.cornerRadius = 15
        self.mapView.layer.masksToBounds = true
        
    self.buttonView.layer.cornerRadius = 30
        self.buttonView.layer.shadowColor = UIColor.orange.cgColor
        self.buttonView.layer.shadowOpacity = 0.25
       self.buttonView.layer.shadowOffset = .zero
       self.buttonView.layer.shadowRadius = 2
        
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
        
        self.circleView.layer.cornerRadius = circleView.bounds.width / 2
        
        self.friendsView.layer.cornerRadius = 15
        //self.friendsView.layer.shadowOpacity = 0.25
        //self.friendsView.layer.shadowOffset = .zero
        //self.friendsView.layer.shadowRadius = 3
        //Ωself.friendsView.layer.shadowColor = UIColor.black.cgColor
        
        
        //self.circleView.layer.shadowColor = UIColor.black.cgColor
       // self.circleView.layer.shadowOpacity = 0.25
       // self.circleView.layer.shadowOffset = .zero
       // self.circleView.layer.shadowRadius = 2
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "friendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendsCvCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "messageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageTvCell")
        
        loadMessages()
        getPeople()
        // address view
        self.displayMapCoordinates()
        self.displayHostSelfie()
        self.getUserLikes()
        self.getEventLikes()
        self.listenForSharesData()
        
        
        self.configureInviteState()
        self.configureQRCodeState()
        //migos reference
        // Do any additional setup after loading the view.
        self.assignData()
        self.generateQRCode()
       
        
       
        if live == false {
            
            infoLabelTableView.text = "Comments will be enabled once this event goes live"
            self.tableView.alpha = 0.3
            self.commentButton.isEnabled = false
            
        } else {
            self.commentButton.isEnabled = true
            infoLabelTableView.text = nil
        }
        //likes
       
        
        
        

        
    }
    
    
    

    
    
    
    func getEventLikes () {
        
        
        db.collection("active_events").document(eventID).getDocument(source: .cache) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Cached document data: \(dataDescription)")
                
            //We need to put snapshots in the file scope. So we don't have to call them every time.
                
                let data = document.data()
                
                let likesCount = data?["likes"] as! Int
                
               
                self.likesLabel.text = "\(likesCount)"
                
            }
        }
    }
    
    func createParticles() {
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.frame.width / 2.0, y: -50)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize =  CGSize(width: view.frame.width, height: 1)
        particleEmitter.renderMode = .oldestFirst
       // particleEmitter.duration = 2
        
        let cell = CAEmitterCell()
       
        cell.birthRate = 50
        cell.lifetime = 10
        cell.velocity = 200
        cell.emissionRange = .pi / 10
        cell.velocityRange = 50
        cell.emissionLongitude = 0
        cell.spinRange = 5
        cell.scale = 0.00001
        cell.scaleRange = 0.25
        cell.color = daygerColor.cgColor
        cell.alphaSpeed = -0.025
        cell.contents = UIImage(named: "confetti")?.cgImage
        particleEmitter.emitterCells = [cell]

        buttonView.layer.addSublayer(particleEmitter)
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
                let liveLikes = data["likes"] as! Int
                self.shares = liveShares
                
                
                self.likes = liveLikes
                
                print("Current shares: \(String(describing: data["shares"]))")
            }
        
        
        
        
    }
    func getUserLikes () {
        
        db.collection("users").document("\(currentUserEmail!)").collection("likes").document("\(eventID)").getDocument(source: .cache) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Cached document data: \(dataDescription)")
                
            //We need to put snapshots in the file scope. So we don't have to call them every time.
                
                let data = document.data()
                
                let liked = data?["liked"] as! Bool
                
                if liked == true {
                    
                   
                    self.likeButton.isSelected = true
                    
                } else {
                    
                    self.likeButton.isSelected = false
                    
                    
                }
            }
            
        }
        
    }
    
    func assignData() {
        //this function is going to be for all the data stuff
       
        
        self.timeLabel.text = "\(time)" //switching these bc Im too lazy ugh.
        self.dateLabel.text = "\(date)"
        self.addressTextView.text = "@ \(address)"
        self.InfoTextField.text = "\(additionalInfo)"
        ticketName.text = name
        
        self.sharesLabel.text = "\(shares)"
        //test
        
        if live == true {
          //for the live label and fun button which can only be enabled when the party is live!
            liveLabel.alpha = 1
            liveLine.alpha = 1
            
            
        } else {
            mainView.backgroundColor = UIColor.white
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
    
    func transitionToHome (){
        //back button
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
       
        
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
    
    
    @IBAction func qrButtonTapped(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Report Event", message: "If you believe this event is in violation of our terms of service, you can flag it to be put under review. ", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Reason..."
    
        })
        
        alert.addAction(UIAlertAction(title: "Flag", style: .destructive, handler: { [self] action in
      
            let textField = alert.textFields![0]
        
            db.collection("reports").document("\(hostFirstName)-\(hostLastName)-\(currentUserEmail!)").setData(["host" : "\(hostFirstName) \(hostLastName)" , "hostUID": uid , "reason" : textField.text!, "guestUID" : userID , "guestemail" : currentUserEmail!, "eventID" : eventID])
                
            }))
        
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Are you sure you'd like to leave?", message: "Leaving the event will remove you from the guest list.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { [self] action in
            
            db.collection("active_events").document(eventID).collection("guest_list").whereField("uid" , isEqualTo: userID).getDocuments {(querySnapshot,error) in
                if let error = error {
                   print("\(error)")
                } else{
                
                    let document = querySnapshot!.documents[0]
                    
                    let user = document.documentID
                    
                    self.db.collection("active_events").document(eventID).collection("guest_list").document(user).delete()
                    //deletes the user from guest list
                
                }
            }
            
            db.collection("users").document(currentUserEmail!).collection("requests").document(eventID).delete()
           
            //deletes the event from users requests
            self.transitionToHome()
        }))
        
        
        self.present(alert, animated: true, completion: nil)
        
    }


    @IBAction func likeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        let generator = UINotificationFeedbackGenerator()
       let likesRef = db.collection("users").document("\(currentUserEmail!)").collection("likes")
        let eventRef = db.collection("active_events").document("\(eventID)")
        
        

        //so the text labels initial value wont be mutated
        
        let liked = likeButton.isSelected
        //is selected means liked
        
        if liked == true {
            likesRef.document("\(eventID)").setData(["liked" : true])
            likesLabel.text = "\(likes + 1)"
            
            eventRef.updateData(["likes" : FieldValue.increment(Int64(1))])
            generator.notificationOccurred(.success)
           
         //not initial function
        } else{
           
            
            likesLabel.text = "\(likes - 1)"
            
            likesRef.document("\(eventID)").setData(["liked" : false])
            eventRef.updateData(["likes" : FieldValue.increment(Int64(-1))])
            
            print(likes)
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
     
        let linkParameter = URL(string: "https://www.dayger.co") // lazy way to do it but this might be all we need to share data to ppl
       // var components = URLComponents()
       // components.scheme = "https"
       //  components.host = "www.dayger.com"
       //  components.path = "/invites\(eventID)"
        
       
        print ("I am sharing \(String(describing: linkParameter))")
        
        //create big dynamic link
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter!, domainURIPrefix: "https://dayger.page.link/invitation/\(eventID)") else {
            
            print("Couldn't Create Share Link")
            return
        }
        
        
        if let myBundleId = Bundle.main.bundleIdentifier {
        shareLink.iOSParameters = DynamicLinkIOSParameters (bundleID: myBundleId)
       
        }
        shareLink.iOSParameters?.appStoreID = "962194608"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Ticket from Dayger..."
        
      
        
        //we can add share link parameters. We don't want those though yet. We will do this though
        guard let longUrl = shareLink.url else {return}
        print("long dynamic link : \(longUrl.absoluteString)")
        self.showShareSheet(url: longUrl)

    }
    
    @IBAction func funButtonTapped(_ sender: Any) {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { } //the button is going to vibrate
        
        
       // self.createParticles()
        
    }
    
    func showShareSheet(url: URL) {
        var promoText : String = ""
        
        if anonymous == false {
        promoText = "\(hostFirstName) \(hostLastName) is hosting: \(name). Click here to get your ticket!"
            
        }
        else if anonymous == true {
        promoText = "An Anonymous host is hosting: \(name). Click here to get your ticket! "
            
        }
        
        let activityVC = UIActivityViewController(activityItems: [promoText , url], applicationActivities: nil)
        
        present(activityVC, animated: true)
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
    
    func getFriends () {
        
        db.collection("users").document(currentUserEmail!).collection("friends").getDocuments { [self] (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                for document in querySnapshot!.documents {
                
                    let data = document.data()
                    
                    let uid = data["uid"] as! String

                    if self.cleanFriendsArray(uid) == true {
                    
                    self.cellData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                        
                        print("This is your cleaned Array\(self.cellData)")
                    } else {
                        //kill the fucking function at that point
                        return
                    }
                }
            }
        }
    }
    
    func getPeople () {
        
        db.collection("active_events").document(eventID).collection("guest_list").limit(to: 10).getDocuments { [self] (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                
                
                self.cellData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
              
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
            
          
                }
            }
        }
    }
    

    func cleanFriendsArray (_ uid: String) -> Bool{
        
        if self.guestListUid.contains(uid) {
            
            return true
        } else {
            return false
        }

    }

    func makeSumShake () {
        //lets get this bitch poppin
        let friends : Array = self.cellData.flatMap() {$0.uid}
        //actually so fucking clutch. FlatMap for the win
        
        print("From friends list:\(friends)")
    }
    
    func getCapacity () {
        if live == true {
            
            db.collection("active_events").document(eventID).getDocument(source: .cache) { (document, error) in
                if let error = error {
                    print(error)
                }
                
                if let document = document {
                  let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    
                //We need to put snapshots in the file scope. So we don't have to call them every time.
                    let data = document.data()
            }
        }
    }
        else {return}
    }
    
    func loadMessages () {
        
        db.collection("active_events").document(eventID).collection("messages").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                print("there are \(querySnapshot!.documents.count) messages for this event")
                
                self.messageData = querySnapshot!.documents.compactMap({MessageDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    print("there are \(querySnapshot!.documents.count) messages for this event")
                    
                    print("there are \(self.messageData.count) items in the message array")
                    
                    self.tableView.reloadData()
            //this is for all the messages for this particular event
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toMessageVC" {
        guard let destinationVC = segue.destination as? messageViewController
        else {return}
        
        destinationVC.eventID = self.eventID
        
        } else if segue.identifier == "toQR" {
            
            guard let destinationVC = segue.destination as? qrCodeViewController
            else {return}
            
            destinationVC.eventID = self.eventID
        }
    
    }
    @IBAction func unwindToContainerVC(segue: UIStoryboardSegue) {

        }
//to unwind back
    
    
    
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
extension activitiesViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
    
        
       return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCvCell" , for: indexPath) as! friendsCollectionViewCell
       
        let data = cellData[indexPath.row]
         
        
             let storageRef = Storage.storage().reference(withPath: "user_selfies/\(data.uid).jpg")
             storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                 if let error = error {
                     
                     print("there was a problem fetching data for the event \(error.localizedDescription)")
                 }
                 if let data = data {
                     cell.selfieImage.image = UIImage(data : data)
                 }
             }
        
        return cell
    }
    
}
extension activitiesViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

       return messageData.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTvCell", for: indexPath) as! messageTableViewCell
        
        
        let data =  messageData[indexPath.row]
        
        cell.messageLabel.text = "\(data.message)"
        cell.timeLabel.text = "@\(data.timeStamp)"
        
        cell.email = data.email
        cell.uid = data.uid
        
        return cell
    }
    
}




