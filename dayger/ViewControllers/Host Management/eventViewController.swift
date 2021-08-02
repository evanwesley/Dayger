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
    @IBOutlet weak var tableView: UITableView!
    let tableCellId = "managerCell"
    let db = Firestore.firestore()
    
    
    var cellData = [ManagerDataModel]() //array
    var comingFromFinalizeVC : Bool = true
    
    let currentUserEmail = Auth.auth().currentUser!.email
    
    
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if comingFromFinalizeVC == true {
            
            self.createLayer()
            
         }
        
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
    func transitionToHome (){
        //back button
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC")
        
        self.view.window?.rootViewController = homeViewController
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
        let randomInt = Int.random(in: 100..<400) //likes
        let randomInt2 = Int.random(in: 500..<1200) //shares
        
        let data = cellData[indexPath.row]
        cell.nameLabel.text = "\(data.name)"
        cell.timeLabel.text = "\(data.date) | \(data.time)"
        cell.likesLabel.text = "\(randomInt)"
        cell.sharesLabel.text = "\(randomInt2)"
        
        
        
        
        if data.qrCode == false {
            cell.capacityLabel.text = "N/A"
        }else{
            cell.capacityLabel.text = "0"
        }
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if let indexPath = tableView.indexPathForSelectedRow {
        
            guard let destinationVC = segue.destination as? detailsViewController else {return}
        
        destinationVC.name = cellData[indexPath.row].name
        destinationVC.docID = cellData[indexPath.row].docID
        
        }
        
    }
    
    
}
