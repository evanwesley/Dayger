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

class homeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // in regards to the Side Menu
    

    let db = Firestore.firestore()
    var ticketArray = [ticketDataModel]() //data that holds the information in the tickets
    
    var menu: SideMenuNavigationController?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var hostManagerButton: UIButton!

    let userID = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = Auth.auth().currentUser!.email
    var cellData = [ticketDataModel]() //not needed
    
    @IBOutlet weak var ticketsInQueue: UILabel!
    
    
    let passiveColor = UIColor(red: 231/255.0, green: 230/255.0, blue: 223/255.0, alpha: 1)
    
    let spacerTableViewCell = "spacerCell"
    
    let HomePageTableViewCell = "HomePageTableViewCell"
    
    //We will need to source this Data from Firebase. All data will be retrieved from cloud
    
    let manager = CLLocationManager()


    let slogan : [Int: String] = [ 1 : "Everyone loves Thursday" , 2 : "The party doesn't stop... except here :(" , 3 : "PREGAME : (noun)" , 4 : "You only live once, do it :)" , 5 : "No matter what, atleast you still have a play" ]
    let randomInt = Int.random(in: 1..<6) //tickets in queue placeholder data.
    
    
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
        ticketsInQueue.text = slogan[Int.random(in: 1..<6)] //haha lets see
        self.loadData()
        
        
        //this is obviously the menu VC
        //correction we seriously don't know that and need to clean up our code
    }
    
  
    
    //function query's data with parameters from the struct we defined. Any future things need to be added to the Ticket model data struct within the main feed data file
    func loadData() {
        db.collection("active_events").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
                self.ticketArray = querySnapshot!.documents.compactMap({ticketDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                self.tableView.reloadData()
                    //print("\(self.ticketArray)")
            }
        }
    }
}
   public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
    return ticketArray.count
    //we can arrange this code into delegate
    //this is where we define the amount of cells showing up, then we populate accordingly
        
        //I can add more cells here
    // lets add "you've reached the end or something"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageTableViewCell",
                                                 for: indexPath) as! HomePageTableViewCell
        let ticket = ticketArray[indexPath.row]
        
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
            
            
            cell.hostNameLabel.text = "Host | Anonymous"
            cell.bitmoji.alpha = 0.25
            
        } else {
            
            cell.hostNameLabel.text = "Host | \(ticket.firstname) \(ticket.lastname)"
            cell.bitmoji.alpha = 1
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
        cell.timeLabel.text = "@\(ticket.time)"
        cell.eventIDLabel.text = ""//empty going to fill with docID eventually
        
        
        
        //populate data accordingly
        cell.accessoryType = .none
        return cell
        //formatting cell
        
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
    
    //@IBAction func transitionToPartyManager(_ sender: Any) {
        
        //self.transitionToPartyManager()
    //}
    
    
}



//Menu






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


