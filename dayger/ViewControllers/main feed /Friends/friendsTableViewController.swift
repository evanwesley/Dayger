//
//  friendsTableViewController.swift
//  dayger
//
//  Created by Evan Wesley on 11/18/21.
//

import UIKit
import Firebase
class friendsTableViewController: UITableViewController
    {
    let db = Firestore.firestore()
    var cellData = [GuestListDataModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.loadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsSideCell", for: indexPath) as! friendsTableViewCell

        
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
    
    func loadData() {
   
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("users").document(currentUserEmail!).collection("friends").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                print(" from load data function!\(querySnapshot!.documents.count)")
                print("func loadData has loaded \(querySnapshot!.documents.count) documents")
                self.cellData = querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    self.tableView.reloadData()
            
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
        }
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
