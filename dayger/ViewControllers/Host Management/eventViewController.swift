//
//  eventViewController.swift
//  dayger
//
//  Created by Evan Wesley on 6/28/21.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseDatabase

class eventViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
   
    @IBOutlet var tableView: UITableView!
    let tableCellId = "managerCell"
    let db = Firestore.firestore()
    

    @IBOutlet weak var toCreateEvent: UIButton!
    
    @IBOutlet var eventCapacitylabel: UILabel!
    
   
    var cellData = [ManagerDataModel]() //array
   
    var comingFromFinalizeVC : Bool = true
    
    let currentUserEmail = Auth.auth().currentUser!.email
    
    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
            let image = UIImage(named: "inAppIcon")
            imageView.image = image
            navigationItem.titleView = imageView
      
        
        //this assumes that the user will head to this view controller. We will need to iron this out later. Another failsafe.

        self.configureCreateEvent()
        self.tableView.register(UINib(nibName: "managerCell", bundle: nil), forCellReuseIdentifier: "managerCell")
        
       
        // Do any additional setup after loading the view.
        
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadData()
        self.createLayer()

        
      //Test Data
        
        
        
    }
    
    
    func createLayer(){
        
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: 0, y: 0)
        let cell = CAEmitterCell()
        cell.duration = 10
        cell.scale = 0.05
        cell.birthRate = 50
        cell.emissionRange = .pi * 2
        cell.lifetime = 20
        cell.velocity = 150
        cell.color = daygerColor.cgColor
        cell.contents = UIImage(named:"confetti")?.cgImage
        layer.emitterCells = [cell]
         
        view.layer.addSublayer(layer)
        
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.transitionToHome()
        
        self.comingFromFinalizeVC = false
        
    }
    
    
    @IBAction func toCreateEventPressed(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.transitionToCreateEvent()
    }
    
    func transitionToHome (){
        //back button
        let homeViewController =
        self.storyboard?.instantiateViewController(identifier: "homeNavController")
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
       
        
    }
    func transitionToCreateEvent (){
        let createEventViewController = self.storyboard?.instantiateViewController(identifier: "createEventVC")
        
        self.view.window?.rootViewController = createEventViewController
        self.view.window?.makeKeyAndVisible()
    }

    func loadData() {
        //need this to work
        db.collection("users").document("\(currentUserEmail!)").collection("active_events").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else{
                self.cellData = querySnapshot!.documents.compactMap({ManagerDataModel(dictionary: $0.data())})
                
                DispatchQueue.main.async {
                self.tableView.reloadData()
                    
            }
        }
    }
}
    func checkIfatEventCapacity() -> Bool {
        //keepsafe. The host can only generate five events for now for data's sake
       
        
        if UserDefaults.standard.integer(forKey: "events") >= 5 {
           
            return true

        } else {
            return false
        }
    
    }
    
    func configureCreateEvent() {
    
        if checkIfatEventCapacity() == true{
            
            self.toCreateEvent.isEnabled = false
            
        } else {
            
            return
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
extension eventViewController : UITableViewDelegate, UITableViewDataSource
{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        self.eventCapacitylabel.text = "Event Capacity (\(cellData.count)/5)"
        print("The amount of events: \(cellData.count)")
        UserDefaults.standard.set(cellData.count, forKey: "events")
        //this works. This view controller sucks but this works
        
        return cellData.count
        
        
           
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailsView", sender: indexPath.row)
        
        //perform this segue. Prepare for segue is down below.
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerCell",
                                                 
                                                 for: indexPath) as! TableViewCell
        
        //test data
       
        
        let data = cellData[indexPath.row]
        cell.nameLabel.text = "\(data.name)"
        cell.timeLabel.text = "\(data.date) | \(data.time)"
        cell.eventID = "\(data.docID)"
        

        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if let indexPath = tableView.indexPathForSelectedRow {
        
            guard let destinationVC = segue.destination as? detailsViewController else {return}
        
        destinationVC.name = cellData[indexPath.row].name
        destinationVC.docID = cellData[indexPath.row].docID
        
        }
        
      
    }
    @IBAction func unwindToEventVC(segue: UIStoryboardSegue) {

        }
    
}
