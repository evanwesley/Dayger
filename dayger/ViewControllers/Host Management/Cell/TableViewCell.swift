//
//  TableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 6/28/21.
//

import UIKit
import Firebase

class TableViewCell: UITableViewCell {
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
   
    var eventID = ""
    let db = Firestore.firestore()
    var cellData = [CoHostDataModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    
    self.collectionView.register(UINib(nibName: "coHostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "coHostCell")
   
        
    self.ticketView.layer.cornerRadius = 20
    
    self.ticketView.layer.shadowColor = UIColor.gray
        .cgColor
    self.ticketView.layer.shadowOpacity = 0.25
    self.ticketView.layer.shadowOffset = .zero
    self.ticketView.layer.shadowRadius = 2
       
        collectionView.dataSource = self
        collectionView.dataSource = self
    
        
  
    //self.subView.layer.borderColor = daygerColor.cgColor
     //   self.subView.layer.borderWidth = 1
   
 
        
        
      
        
        
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        
        // Configure the view for the selected state
    }
    
    func loadData() {
   
        
        //fuck this dumbass fucking fuction. I doesn't work and I hate it. Caused me so much pain for no fucking reason.
        db.collection("active_events").document(eventID).collection("promoters").getDocuments { (querySnapshot,error) in
            if let error = error {
               print("\(error) the data failed to load")
            } else {
                print(" from load data function!\(querySnapshot!.documents.count)")
                print("func loadData has loaded \(querySnapshot!.documents.count) documents")
                self.cellData = querySnapshot!.documents.compactMap({CoHostDataModel(dictionary: $0.data())})
                DispatchQueue.main.async {
                
                    self.collectionView.reloadData()
            
          //this query's a snapshot of documents. Now we must implement it from the inbox section.
                }
            }
        }
    }
    
    
}
extension TableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coHostCell", for: indexPath) as! coHostCollectionViewCell
    
    
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
