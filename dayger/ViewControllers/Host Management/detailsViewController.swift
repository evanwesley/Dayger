//
//  detailsViewController.swift
//  dayger
//
//  Created by Evan Wesley on 7/3/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class detailsViewController: UIViewController {
    var name : String = "" 
    var docID : String = ""
    
    var hostFirstName = ""
    var hostLastName = ""
    var capacity : Int = 0
    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 0.8)
    
    
    @IBOutlet weak var coHostDescription: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var friendsView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    
    @IBOutlet weak var buttonView: UIView!
    
    let currentUserEmail = Auth.auth().currentUser!.email
    let db = Firestore.firestore()
    //this is the event name
    
    var guestData = [GuestListDataModel]()
    var cellData = [CoHostDataModel]()
    //array
    
    @IBOutlet weak var sharesButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    //for guest list
    
    //for comments
    
    @IBOutlet weak var guestView: UIView!
    
    @IBOutlet weak var infoView: UIView!
   
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var docIDLabel: UILabel!
   
    @IBOutlet weak var sexCountLabel: UILabel!
    
    @IBOutlet weak var liveSwitch: UISwitch!
    
    @IBOutlet weak var atCapacitySwitch: UISwitch!
    
    @IBOutlet weak var hostBackgroundImage: UIImageView!
    
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var anonymousSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            // 3
        let blurView = UIVisualEffectView(effect: blurEffect)
            // 4
        scrollView.backgroundColor = daygerColor
        
        self.guestView.layer.cornerRadius = 15
       // self.guestView.layer.borderColor = UIColor.black.cgColor
       // self.guestView.layer.borderWidth = 1.75
        
        self.buttonView.layer.shadowColor = UIColor.orange.cgColor
        self.buttonView.layer.shadowOpacity = 0.25
        self.buttonView.layer.shadowOffset = .zero
        self.buttonView.layer.shadowRadius = 2
        self.buttonView.layer.cornerRadius = 20
        
        
        self.shareView.layer.cornerRadius = 15
    
        
        self.tableView.clipsToBounds = true
        self.friendsView.layer.cornerRadius = 15
        self.infoView.layer.cornerRadius = 15
        
        
        
        //self.infoView.layer.shadowColor = UIColor.black.cgColor
       // self.infoView.layer.shadowOpacity = 0.25
       // self.infoView.layer.shadowOffset = .zero
      //  self.infoView.layer.shadowRadius = 2
        
        
        //registerTableView Here
        
        self.tableView.register(UINib(nibName: "guestListTableViewCell", bundle: nil), forCellReuseIdentifier: "guestlistCell")
        tableView.delegate = self
        tableView.dataSource = self
   
        
        self.collectionView.register(UINib(nibName: "friendsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "friendsCvCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("\(docID)")
        print("\(currentUserEmail!)")
        
        
     
        //self.infoView.layer.borderColor = UIColor.black.cgColor
        //self.infoView.layer.borderWidth = 1.7
        
        loadCoHosts()
        retrieveData()
        configureSwitches()
      //  enableCapSwitch()
        //call this function to load data for the view controller
        
        getStats()
        getDocCount()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toGuestList" {
            guard let destinationVC = segue.destination as? guestlistViewController else {return}
        
            destinationVC.docID = docID
            destinationVC.eventName = name
    
        } else if segue.identifier == "toComments" {
            
            guard let destinationVC = segue.destination as? messagesTableViewController else {return}
            destinationVC.eventID = docID
            
        }
        
        }

    func configureSwitches () {
        
        db.collection("active_events").document(docID).getDocument(source: .cache) { (document, error) in
            if let document = document {
              let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              print("Cached document data: \(dataDescription)")
                
            //We need to put snapshots in the file scope. So we don't have to call them every time.
                
                let data = document.data()
                
                let firstname = data?["firstname"] as! String
                let lastname = data?["lastname"] as! String
                
                self.hostFirstName = firstname
                self.hostLastName = lastname
                
                
                let live = data?["live"] as! Bool
                let atMax = data?["atCapacity"] as! Bool
                let anonymous = data?["anonymous"] as! Bool
                
                //configuring the switches when loaded
                if live == true {
                    self.liveSwitch.isOn = true
                }else{
                    self.liveSwitch.isOn = false
                    
                }
                
                if atMax == true {
                    self.atCapacitySwitch.isOn = true
                } else {
                    self.atCapacitySwitch.isOn = false
                }
                if anonymous == true {
                    self.anonymousSwitch.isOn = true
                }else {
                    self.anonymousSwitch.isOn = false
                }
                
                
        
            }
        }
    
    }
    
    func getStats () {
        
        db.collection("active_events").document("\(docID)").getDocument { (document, error) in
            if let document = document, document.exists {
                   let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                   print("Document data: \(dataDescription)")
                   //this this is too retrieve data from the document.
                   let data = document.data()
                   
                   let likes = data?["likes"] as! Int
                   let shares = data?["shares"] as! Int 
               
                //we could move this line of code
                //we could also use this code to add the verified checkmark to certain users
                
                self.likesLabel.text = "\(likes)"
                self.sharesLabel.text = "\(shares)"
                
            
                
                
           }
            
        }
        
        
        
        
    }
    
    @IBAction func liveSwitchTapped(_ sender: Any) {
        var live : Bool = false
        if liveSwitch.isOn {
            
            live = true
            
            db.collection("active_events").document(docID).updateData(["live" : live ])
        }else {
            
            live = false
            
            db.collection("active_events").document(docID).updateData(["live" : live ])
        }
    }
    
    
    @IBAction func maxCapTapped(_ sender: Any) {
        var isMax : Bool = false
        
        if atCapacitySwitch.isOn {
            
            isMax = true
            
            db.collection("active_events").document(docID).updateData(["atCapacity" : isMax ])
        }else {
            
            isMax = false
           
            db.collection("active_events").document(docID).updateData(["atCapacity" : isMax ])
        }
    }
    
    
    @IBAction func anonTapped(_ sender: Any) {
        var anon : Bool = false
        
        if anonymousSwitch.isOn {
            anon = true
            
            db.collection("active_events").document(docID).updateData(["anonymous" : anon ])
            
        }else {
            
            anon = false
          
            db.collection("active_events").document(docID).updateData(["anonymous" : anon ])
        }
        
    }
    func enableCapSwitch(){
        //this function is going to ensure that the user only can interact with the capacity switch when the event is live.
        
        
        
        if liveSwitch.isOn == false {
            
            atCapacitySwitch.isEnabled = false
            
            
        } else if liveSwitch.isOn == true {
            
            atCapacitySwitch.isEnabled = true
            
        }
        
        
    }
    func loadData() {
        print("\(docID)")
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("active_events").document("\(docID)").collection("guest-list").getDocuments { [self] (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                
                
                
                print("func loadData has loaded \(querySnapshot!.documents.count) documents")
                self.capacityLabel.text = "\(querySnapshot!.documents.count)"
                
                self.guestData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
              
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
            
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
        }
    }
    
    @IBAction func guestListExpandButtonTapped(_ sender: Any) {
       
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    @IBAction func sharesButtonTapped(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let linkParameter = URL(string: "https://www.dayger.co") // lazy way to do it but this might be all we need to share data to ppl
       // var components = URLComponents()
       // components.scheme = "https"
       //  components.host = "www.dayger.com"
       //  components.path = "/invites\(eventID)"
        
       
        print ("I am sharing \(String(describing: linkParameter))")
        
        //create big dynamic link
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter!, domainURIPrefix: "https://dayger.page.link/invitation/\(docID)") else {
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
    
    func showShareSheet(url: URL) {
        var promoText : String = ""
        
        if anonymousSwitch.isOn == false {
        promoText = "\(hostFirstName) \(hostLastName) is hosting: \(name). Click here to get your ticket!"
            
        }
        else if anonymousSwitch.isOn == true {
        promoText = "An Anonymous host is hosting: \(name). Click here to get your ticket! "
            
        }
        
        let activityVC = UIActivityViewController(activityItems: [promoText , url], applicationActivities: nil)
        
        present(activityVC, animated: true)
    }
    
    func getDocCount () {
    //this function saved my life
        db.collection("active_events").document("\(docID)").collection("guest_list").getDocuments { (querySnapshot,error) in
                if let error = error {
                   print("\(error)")
                } else{
                    
                    print("\(String(describing: querySnapshot?.documents.count))")
                    self.capacity = (querySnapshot?.documents.count)!
                    
                    self.capacityLabel.text = "\(querySnapshot!.documents.count)"
                    
                    self.guestData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                    DispatchQueue.main.async {
                    
                        self.tableView.reloadData()
                    }
                }
            }
        }
    
    
    
    func retrieveData () {
        
      var guys = 0
      var girls = 0
        
        db.collection("active_events").document("\(docID)").collection("guest_list").whereField("sex" , isEqualTo: false).getDocuments {(querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
                
                guys = querySnapshot!.count
               
            }
        }
        db.collection("active_events").document("\(docID)").collection("guest_list").whereField("sex" , isEqualTo: true).getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
                
                girls = querySnapshot!.count
                
            }
            print("there are \(guys) guys")
            print("there are \(girls) girls")
            
            self.sexCountLabel.text = "M |\(guys)  F |\(girls)"
        }
    
        
        
        
         nameLabel.text = "\(name)" // this is the name label of the details vc
         docIDLabel.text = "Event ID: \(docID)"
         self.sexCountLabel.text = "M |  \(guys)    F |  \(girls)"
        
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        //this function cancels the event
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        let newCount = UserDefaults.standard.integer(forKey:  "events")
       
        let alert = UIAlertController(title: "Are you sure you'd like to archive this event?", message: "This event will end and it's statistics will be archived.", preferredStyle: .actionSheet)
       
       
       
        alert.addAction(UIAlertAction(title: "End ", style: .destructive, handler:  { [self] action in
        db.collection("users").document("\(currentUserEmail!)").collection("active_events").document("\(docID)").delete()
        db.collection("active_events").document("\(docID)").delete()
        db.collection("users").document(self.currentUserEmail!).updateData(["clout" : FieldValue.increment(Int64(1))])
        UserDefaults.standard.set(newCount - 1, forKey: "events")
            
            self.transitionToHome()
        }))
        
        alert.addAction(UIAlertAction(title: "Nevermind...", style: .cancel, handler: nil ))
        //we are going to add sublayer here that shows promt asking if user is sure about cancelling the event.
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        self.performSegue(withIdentifier: "eventUW", sender: self)
    }
    
    
    func transitionToHome (){
        //back button
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    func loadCoHosts() {
        print(docID)
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("active_events").document(docID).collection("promoters").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                self.cellData = querySnapshot!.documents.compactMap({CoHostDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    self.collectionView.reloadData()
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
        }
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
extension detailsViewController : UITableViewDelegate , UITableViewDataSource {
    
    
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    if guestData.count == 0 {
        
        headerLabel.text = "Looks like you have no guests. Tap the share button to send out invitations!"
        
    } else {
        
        headerLabel.text = nil
        
        
    }
    
  
    return guestData.count
    
    
        
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "guestlistCell" ,
                                                 
                                                 for: indexPath) as! guestListTableViewCell
        
       let data = guestData[indexPath.row]
        
            let storageRef = Storage.storage().reference(withPath: "user_selfies/\(data.uid).jpg")
            storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                if let error = error {
                    
                    print("there was a problem fetching data for the event \(error.localizedDescription)")
                }
                if let data = data {
                    cell.selfieImage.image = UIImage(data : data)
                }
            }
        
        cell.nameLabel.text = "\(data.firstname) \(data.lastname)" //firstname and lastname
        cell.socialLabel.text = "\(data.social)"
        cell.selectionStyle = .none
        
        return cell
    }
    func createParticles() {
        let particleEmitter = CAEmitterLayer()

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: view.center.y)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)

        particleEmitter.emitterCells = [red, green, blue]

        view.layer.addSublayer(particleEmitter)
    }
    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 10
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05

        cell.contents = UIImage(named: "confetti")?.cgImage
        return cell
    }
    

   
    
    
    
}

extension detailsViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if cellData.count < 1 {
            
            self.coHostDescription.text = "Add Co Hosts from your guest list"
            
        } else {
            
            self.coHostDescription.text = nil
            
        }
        
        
       return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCvCell" ,
                                                 
                                                 for: indexPath) as! friendsCollectionViewCell
        
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
