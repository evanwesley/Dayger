//
//  homeViewController.swift
//  dayger
//
//  Created by Evan Wesley on 12/29/20.
// All of this BS is for the home page cell
//It gets pretty complicated

import SideMenu //Cocaopod
import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import SCSDKLoginKit

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // in regards to the Side Menu
    
    let graphQLQuery = "{me{displayName, bitmoji{avatar}}}"
    let variables = ["page": "bitmoji"]
    
    
    
    
    

    let db = Firestore.firestore()
    
    var ticketArray = [ticketDataModel]() //data that holds the information in the tickets
    var inviteArray = [Invites] ()
    var requestArray = [Requests] () //both of these arrays are going to be stored in another array in the tableview function
    var invites : [String] = [] //the eventID's are going to be stored in either of these two variables
    var requests : [String] = []
    
    var menu: SideMenuNavigationController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var hostManagerButton: UIButton!

    @IBOutlet weak var queueLabel: UILabel!
    
    @IBOutlet weak var footerLabel: UILabel!
    //slogans n shit
    let userID = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = Auth.auth().currentUser!.email
    
    
    
    
    //oddly enough these became our slogans
    
    
    let passiveColor = UIColor(red: 231/255.0, green: 230/255.0, blue: 223/255.0, alpha: 1)
    
    let spacerTableViewCell = "spacerCell"
    
    let HomePageTableViewCell = "HomePageTableViewCell"
    
    //We will need to source this Data from Firebase. All data will be retrieved from cloud
    
    let manager = CLLocationManager()


    let slogan : [Int: String] = [ 1 : "Everyone loves Thursday 😌" , 2 : "The party never ends... except here 🥺" , 3 : "Have fun... responsibly" , 4 : "You only live once, do it 👍" , 5 : "It's like an Endless Summer ;)" , 6 : "Guys.. we aren't Fyre Fest!" , 7 : "Quarantine theme?" , 8 : "Dayger to the 🌙!" ]
    let randomInt = Int.random(in: 1..<9) //tickets in queue placeholder data.
    
    
    //this is for immediate location request
   
    //we are going to have to pull data from the firebase

    
    
    override func viewDidLoad() {
        //for cells we need to put them before super view // I forgot what this means but probably important
        tableView.delegate = self
        tableView.dataSource = self
        
       
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        // Do any additional set up
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        //ticketsInQueue.text = "Tickets in Queue: \(randomInt)"
        
    
        
        
      
       
        //self.loadData()
        self.getInvites()
        self.getRequests()
      

        
        print(self.inviteArray.count)
        print("view did load test \(self.invites)")
       
        //this is obviously the menu VC
        //correction we seriously don't know that and need to clean up our code
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
                data.append("filler")
                //we need to append this because the array cannot be empty.
                
                print(data.count)
                if data.count == 1{
                    
                    self.footerLabel.text = "Looks like you have no tickets right now 😒. Click the ➕ button to create one! "
                    
                } else {
                    
                    if data.count > 1 {
                        
                        footerLabel.text = slogan[Int.random(in: 1..<9)]
                        
                    }
                }
                print("Test \(data)")
                //Invites
                db.collection("active_events").whereField("docID", in: data).getDocuments {(querySnapshot,error) in
                    if let error = error {
                       print("\(error)")
                    } else{
                        print("\(String(describing: querySnapshot?.documents.count))")
                        //
                        self.ticketArray =
                            querySnapshot!.documents.compactMap({ticketDataModel(dictionary: $0.data())})
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            //print("\(self.ticketArray)")
                    }
                }
            }
                
            }
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
        }else {
            cell.liveLabel.alpha = 0
            cell.liveLine.alpha = 0
            cell.ticketView.backgroundColor = passiveColor
        }
        
        if atMax && live == true{
            //this makes sure that people can still see the maximum capacity label when the event is still live
            cell.liveLabel.text = "MAX CAPACITY"
            cell.liveLabel.textColor = UIColor.black
            cell.liveLabel.alpha = 1
            cell.liveLine.alpha = 0
            
        } else if atMax == true && live == false {
            
            cell.liveLabel.text = "END"
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
            
           destinationVC.likes = ticketArray[indexPath.row].likes
            destinationVC.shares = ticketArray[indexPath.row].shares
            //passing this on to retrieve the event info
            
            
            //Booleans needed
            
            //this is the shit that works for passing data from cell to view controller. It's all coming together. NOTE: use this to add more data to the view activities view controller scene. This is like step 4 in the process. I probably should connect these all together but irdc
        }
    }
    @IBAction func menuButtonTapped() {
        present(menu!, animated: true)
        //Self explanatory
        
    }
    @IBAction func createEventButtonTapped(_ sender: Any) {
        self.transitionToCreateEvent()
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
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //@IBAction func transitionToPartyManager(_ sender: Any) {
        
        //self.transitionToPartyManager()
    //}
    
}
class MenuListController: UITableViewController {
    //cocao pod
    var items = [" "," ","Past Events", "Refer a Friend","Payment", "Sponsored", "Socials","Privacy","Help","About"]
    // first two items are temporary spacers
    //need to figure out how to have this view controller operational
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    //daygerColor refers to the theme of the app as whole, this may change as we further develop UI
    //remember that we transpose the "dayger color" on this side menu because it is a little off. Original: 230, 165, 98 New: 240, 162, 87
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none

        tableView.backgroundColor = daygerColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = cell.backgroundColor
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = daygerColor
    
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // do something regards to the menu table
        
    }
}


