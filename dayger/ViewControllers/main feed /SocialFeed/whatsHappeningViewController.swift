//
//  whatsHappeningViewController.swift
//  dayger
//
//  Created by Evan Wesley on 12/28/21.
//

import UIKit
import Firebase


class whatsHappeningViewController: UIViewController {

    var cellData = [GuestListDataModel]()
    var ticketArray = [ticketDataModel]()
    let db = Firestore.firestore()
    var friends : [String] = []
    
    let userID = (Auth.auth().currentUser?.uid)!
    let currentUserEmail = Auth.auth().currentUser!.email
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getFriends () {
        db.collection("users").document(currentUserEmail!).collection("friends").getDocuments { [self] (querySnapshot,error) in
            if let error = error {
               print("\(error)")
            } else{
                //works
                self.cellData =
                    querySnapshot!.documents.compactMap({GuestListDataModel(dictionary: $0.data())})
                var data : [String]  = self.cellData.map({ return ($0.email) })
                    //works
                    print("these are the invitations as of right now \(data)")
                //data is all of the documents where accepted equals true
                data.shuffle()
                //these are the emails
                    
                db.collection("active_events").whereField("email", in: data ).limit(to: 10).getDocuments {(querySnapshot,error) in
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
