//
//  homeViewController.swift
//  dayger
//
//  Created by Evan Wesley on 12/29/20.
// All of this BS is for the home page cell
//It gets pretty complicated

//Cocaopod
import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import SCSDKLoginKit
import FirebaseDynamicLinks

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    // in regards to the Side Menu
    
    @IBOutlet weak var sideButtonView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    let variables = ["page": "bitmoji"]
    let db = Firestore.firestore()
    var activeDocs : Int = 0
    
    var ticketArray = [ticketDataModel]() //data that holds the information in the tickets
    var inviteArray = [Invites] ()
    var requestArray = [Requests] () //both of these arrays are going to be stored in another array in the tableview function
    var invites : [String] = [] //the eventID's are going to be stored in either of these two variables
    var requests : [String] = []
    
   // var menu: SideMenuNavigationController?

    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var yourTicketsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var hostManagerButton: UIButton!

    @IBOutlet weak var queueLabel: UILabel!
    
    @IBOutlet weak var scannerButton: UIButton!
    
    @IBOutlet weak var footerLabel: UILabel!
    //slogans n shit
    let userID = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = Auth.auth().currentUser!.email
    
    
    
    
    //oddly enough these became our slogans
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    let passiveColor = UIColor(red: 231/255.0, green: 230/255.0, blue: 223/255.0, alpha: 1)
    
    let spacerTableViewCell = "spacerCell"
    
    let HomePageTableViewCell = "HomePageTableViewCell"
    
    //We will need to source this Data from Firebase. All data will be retrieved from cloud
    
    let manager = CLLocationManager()


    let slogan : [Int: String] = [ 1 : "Thursday 😌" , 2 : "The party never ends... except here 🥺" , 3 : "Have fun... responsibly" , 4 : "You only live once, make it count 👍" , 5 : "It's like an Endless Summer" , 6 : "Go get after it" , 7 : "Quarantine theme?" , 8 : "Dayger to the 🌙!", 9 : "Work Hard, Play Harder 🤩" ]
    let randomInt = Int.random(in: 1..<10) //tickets in queue placeholder data.
    
    
    //this is for immediate location request
   
    //we are going to have to pull data from the firebase

    
    
    override func viewDidLoad() {
        //for cells we need to put them before super view // I forgot what this means but probably important
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 1
        self.view.layer.shadowOffset = CGSize(width: 4, height: 4.0)
        
        self.headerView.layer.cornerRadius = 5
        
       self.sideButtonView.layer.shadowColor = UIColor.gray
            .cgColor
        self.sideButtonView.layer.shadowOpacity = 0.5
        
       self.sideButtonView.layer.shadowOffset = CGSize(width: 0, height: 0)
       self.sideButtonView.layer.shadowRadius = 1
       self.sideButtonView.layer.cornerRadius = 30
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "inAppIcon")
            imageView.image = image
            navigationItem.titleView = imageView
        
     
        
        tableView.delegate = self
        tableView.dataSource = self
       
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        // Do any additional set up
        //menu = SideMenuNavigationController(rootViewController: sideMenuTableViewController())
        
        
        //menu?.leftSide = true
        //menu?.setNavigationBarHidden(true, animated: false)
        
        //SideMenuManager.default.leftMenuNavigationController = menu
        //SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "backgroundFinal"))
        //ticketsInQueue.text = "Tickets in Queue: \(randomInt)"
    
        //self.loadData()
        self.getInvites()
        self.getRequests()
        

        
        print(self.inviteArray.count)
        print("view did load test \(self.invites)")
       
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        //this is obviously the menu VC
        //correction we seriously don't know that and need to clean up our code
    }
    
   override func viewDidAppear(_ animated: Bool) {
        
       let nav = self.navigationController?.navigationBar
      
       
       
       nav?.barStyle = UIBarStyle.default
       nav?.barTintColor = daygerColor
   
       
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "inAppIcon")
            imageView.image = image
            navigationItem.titleView = imageView
    }
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        self.transitionToProfile()
    }
    
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
        
       // SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    @IBAction func clipBoardButtonTapped(_ sender: Any) {
    
        self.transitionToEventManager()
        
    }
        
    

    
    func checkIfEventExists(event: String) -> String {
       
        let eventID = event
        return eventID
    }
    
    
    @objc private func didPullToRefresh () {
        //refetch data
        
        self.getInvites()
    }
    
    //function query's data with parameters from the struct we defined. Any future things need to be added to the Ticket model data struct within the main feed data file
    func getRequests () {
        //get all of the users requests
        db.collection("users").document(currentUserEmail!).collection("requests").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
                //works
                self.requestArray =
                    querySnapshot!.documents.compactMap({Requests(dictionary: $0.data())})
                let retrievedData : Array = self.requestArray.filter ({$0.accepted == false }).map({ return $0.docID })
                print("these are your request as of right now \(retrievedData)")
                
                self.queueLabel.text = "In Queue: \(retrievedData.count)"
            }
        }
    }
    
    func transitionToEventManager (){
        //back button
        let vc = self.storyboard?.instantiateViewController(identifier: "hostManagementVC")
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
       
        
    }
    
    func getInvites () {
        
        
        db.collection("users").document(currentUserEmail!).collection("requests").getDocuments { [self] (querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
                //works
                self.inviteArray =
                    querySnapshot!.documents.compactMap({Invites(dictionary: $0.data())})
                var data : [String]  = self.inviteArray.filter ({$0.accepted == true }).map({ return ($0.docID) })
                    //works
                    print("these are the invitations as of right now \(data)")
                //data is all of the documents where accepted equals true
                (data).forEach(cleanInviteArray(_:))
                print("Array of events being presented: \(data)")
                //works
                
                if data.count < 1 {
                data.append("u40fWhLlb4REcVJmJwSr")
                    //This document right here is the greeting document. It will never be deleted
                    
                    
                    db.collection("active_events").whereField("docID", in: data).getDocuments {(querySnapshot,error) in
                        if let error = error {
                           print("This document might not exist\(error)")
                        } else{
                            
                            print("\(String(describing: querySnapshot?.documents.count))")
                            //
                            self.ticketArray =
                                querySnapshot!.documents.compactMap({ticketDataModel(dictionary: $0.data())})
                            DispatchQueue.main.async {
                                self.tableView.refreshControl?.endRefreshing()
                                self.tableView.reloadData()
                                
                            }
                        }
                    }
                //we need to append this because the array cannot be empty.
                    //we'lll call a clear data function.
                    //we could also add a sample ticket here
                 
                    self.footerLabel.text = "Let's go to the moon."
                    yourTicketsLabel.text = "My Tickets (0/10)"
                    
                    
                
                } else {
                    
                    if data.count >= 1{
                       
                        UserDefaults.standard.set(data.count, forKey: "tickets")
                        //this is going to a fail safe for the app and database. If the user has 10 tickets and tries to recieve more they wont be able to and will have to delete some.
                        
                        print(data.count)
                        yourTicketsLabel.text = "My Tickets (\(data.count)/10)"
                        
                        footerLabel.text = slogan[Int.random(in: 1..<10)]
                       
                    }
                }
                
                db.collection("active_events").whereField("docID", in: data).getDocuments {(querySnapshot,error) in
                    if let error = error {
                       print("This document might not exist\(error)")
                    } else{
                        
                        print("\(String(describing: querySnapshot?.documents.count))")
                        //
                        self.ticketArray =
                            querySnapshot!.documents.compactMap({ticketDataModel(dictionary: $0.data())})
                        DispatchQueue.main.async {
                            self.tableView.refreshControl?.endRefreshing()
                            self.tableView.reloadData()
                            //print("\(self.ticketArray)")
                        }
                    }
                }
            }
        }
    }
    func cleanInviteArray ( _ invite: String) {
        db.collection("users").document(currentUserEmail!).collection("requests").document(invite).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                
                let data = document.data()
                let eventID = data?["docID"] as! String
                
                self.db.collection("active_events").document(eventID).getDocument { (document, error) in
                    if let document = document, document.exists {
                        //if document exists we loop through the other arrays
                        return
                        
                    } else {
                        
                        //deletes the document request from the array
                        if document?.exists == false {
                            db.collection("users").document(currentUserEmail!).collection("requests").document(eventID).delete()
                            print("document: \(String(describing: document)) deleted from request array")
                        }
                    }
                }
            }
        }
    }
    
    func checkIfatEventCapacity () -> Bool {
        //keepsafe. The host can only generate five events for now for data's sake
       
        
        if UserDefaults.standard.integer(forKey: "events") >= 5 {
           
            return true

        } else {
            return false
        }
    
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return ticketArray.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell",
                                                 for: indexPath) as! HomePageTableViewCell
        let ticket = ticketArray[indexPath.row]
        
        let storageRef = Storage.storage().reference(withPath: "user_selfies/\(ticket.uid).jpg")
        storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                
                print("there was a problem fetching data for the event \(ticket.name) : \(error.localizedDescription)")
            }
            if let data = data {
                cell.selfieImage.image = UIImage(data: data)
            }
        }
        cell.backgroundView?.backgroundColor = UIColor.clear
        let anon = ticket.anonymous
        let atMax = ticket.atCapacity
        let live = ticket.live
        
        if atMax == true {
            //disables ticket for index path
            cell.isUserInteractionEnabled = false
            cell.ticketView.alpha = 0.5
            cell.ticketView.layer.borderWidth = 0
            
            //in regards to the cell alpha
       
        } else {
            
            cell.isUserInteractionEnabled = true
            cell.ticketView.alpha = 1
        }
        if anon == true {
            
            
            cell.hostNameLabel.text = "Anonymous"
            cell.selfieImage.alpha = 0.05
            cell.circleView.backgroundColor = UIColor.white
            
        } else {
            
            cell.hostNameLabel.text = "\(ticket.firstname) \(ticket.lastname)"
            cell.selfieImage.alpha = 1.0
        }
        if live == true {
            cell.liveLabel.alpha = 1
            cell.liveLine.alpha = 1
          //  cell.ticketView.backgroundColor = UIColor.white
            //cell.ticketView.layer.borderWidth = 2
            //cell.ticketView.layer.borderColor = UIColor.orange.cgColor
            
        }else {
            cell.liveLabel.text = nil
            cell.liveLine.alpha = 0
            //cell.ticketView.backgroundColor = UIColor.white
            //cell.ticketView.layer.borderColor = UIColor.orange.cgColor
        }
        
        if atMax && live == true{
            //this makes sure that people can still see the maximum capacity label when the event is still live
            cell.liveLabel.text = "MAX CAPACITY"
            cell.liveLabel.textColor = UIColor.black
            cell.liveLabel.alpha = 1
            cell.liveLine.alpha = 0
            
            
        } else if atMax == true && live == false {
            
            cell.liveLabel.text = "MAX CAPACITY"
            cell.liveLabel.textColor = UIColor.black
            cell.liveLabel.alpha = 1
            cell.liveLine.alpha = 0
        }
        cell.hostLabel.text = "\(ticket.name)"
        cell.dateLabel.text = "\(ticket.date)"
        cell.timeLabel.text = "\(ticket.time)"
        
        
        cell.accessoryType = .none
        return cell
        //formatting cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let destinationVC = segue.destination as? activitiesViewController else {return}
            destinationVC.name = ticketArray[indexPath.row].name
            destinationVC.date = ticketArray[indexPath.row].date
            destinationVC.time = ticketArray[indexPath.row].time
            destinationVC.address = ticketArray[indexPath.row].address
            destinationVC.hostFirstName =
                ticketArray[indexPath.row].firstname
            destinationVC.hostLastName =
                ticketArray[indexPath.row].lastname
            destinationVC.uid = ticketArray[indexPath.row].uid
            //below is all for map view. I cannot believe I figured that out wow
            let location = ticketArray[indexPath.row].location //pulls that specific location from firestore in that specific path
            let point = location as GeoPoint
                let lat = point.latitude
                let lon = point.longitude
            destinationVC.lon = lon
            destinationVC.lat = lat
            destinationVC.additionalInfo = ticketArray[indexPath.row].additionalInformation
            
            destinationVC.qrCode = ticketArray[indexPath.row].qrCode
            destinationVC.closedInvite = ticketArray[indexPath.row].closed_invite
            
            destinationVC.live = ticketArray[indexPath.row].live
            destinationVC.anonymous = ticketArray[indexPath.row].anonymous
            
            destinationVC.eventID = ticketArray[indexPath.row].docID
            
           //destinationVC.likes = ticketArray[indexPath.row].likes
           destinationVC.shares = ticketArray[indexPath.row].shares
            //passing this on to retrieve the event info
            
            
            //Booleans needed
            
            //this is the shit that works for passing data from cell to view controller. It's all coming together. NOTE: use this to add more data to the view activities view controller scene. This is like step 4 in the process. I probably should connect these all together but irdc
        }
    }
    
    
    
    @IBAction func scannerButtonTapped(_ sender: Any) {
        
        self.transitionToScanner()
    }
    
    
   
    @IBAction func createEventButtonTapped(_ sender: Any) {
       //checkIfatEventCapacity()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        if checkIfProfileCompleted() == false {
            
            let alert = UIAlertController(title: "Profile not completed", message: "To continue with Dayger, please ensure that your personal profile is completed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Go to profile", style: .default, handler:  { [self] action in
                transitionToProfile()
                }))
            self.present(alert, animated: true, completion: nil)
            
            
        } else if checkIfatEventCapacity() == true {
            
            let alert = UIAlertController(title: "Event limit reached", message: "It seems you have reached the maximum number of events. Go to your clipboard and archive previous events to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil
                ))
            self.present(alert, animated: true, completion: nil)
        
        }
        
        else {
            print("The number of active events are: \(UserDefaults.standard.integer(forKey: "events"))")
            
            self.transitionToCreateEvent()
        }
        //lets add a little animation
    }
    func transitionToCreateEvent (){
        let createEventViewController = self.storyboard?.instantiateViewController(identifier: "createEventVC")
        
        self.view.window?.rootViewController = createEventViewController
        self.view.window?.makeKeyAndVisible()
    }

    func transitionToPartyManager() {
        let hostManagementViewController =
       
            self.storyboard?.instantiateViewController(identifier: "hostManagementVC")
        
        self.view.window?.rootViewController =  hostManagementViewController
        self.view.window?.makeKeyAndVisible()
        //function for transitioning to Party Manager
        
        
        
    }
    
    func transitionToProfile () {
        //transition to profile
        let profileViewController =
            self.storyboard?.instantiateViewController(identifier: "profileVC")
        
        self.view.window?.rootViewController = profileViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToScanner() {
        //transition to profile
        let scanner =
            self.storyboard?.instantiateViewController(identifier: "ScannerVC")
        
        self.view.window?.rootViewController = scanner
        self.view.window?.makeKeyAndVisible()
        
    }
    
    @IBAction func unwindToContainerVCScanner(segue: UIStoryboardSegue) {

       }
    
    //@IBAction func transitionToPartyManager(_ sender: Any) {
        
        //self.transitionToPartyManager()
    //}
    
    func checkIfProfileCompleted() -> Bool {
        if UserDefaults.standard.bool(forKey: "profilecompleted") == false {
            
            
            return false
            
        } else {
          
            return true
    }
        //this function returns value to function to see if the profile is completed
}

}

