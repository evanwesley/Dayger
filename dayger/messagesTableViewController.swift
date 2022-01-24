//
//  messagesTableViewController.swift
//  dayger
//
//  Created by Evan Wesley on 11/26/21.
//

import UIKit
import Firebase


class messagesTableViewController: UITableViewController {

    
    @IBOutlet weak var swipeLabel: UILabel!
    var eventID = ""
    var messageData = [MessageDataModel]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "messageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageTvCell")
        loadMessages()
        
        print("this is the eventID \(eventID)")
       
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return messageData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     let cell = tableView.dequeueReusableCell(withIdentifier: "messageTvCell", for: indexPath) as! messageTableViewCell
     
     
     let data =  messageData[indexPath.row]
     
     cell.messageLabel.text = "\(data.message)"
     cell.timeLabel.text = "@\(data.timeStamp)"
     
     cell.email = data.email
     cell.uid = data.uid
     
    cell.docID = data.docID
        
     return cell
 }
 


  
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let data = messageData[indexPath.row]
        
        if editingStyle == .delete {
            
            messageData.remove(at: indexPath.row)
            tableView.reloadData()
            // Delete the row from the data source
            
            
            db.collection("active_events").document(eventID).collection("messages").document(data.docID).delete()
            
            tableView.reloadData()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
