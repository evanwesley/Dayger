//
//  HomePageTableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 1/2/21.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
  
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var liveLine: UIView!
    
    @IBOutlet weak var bitmoji: UIImageView!
    @IBOutlet weak var hostNameLabel: UILabel!
    
    @IBOutlet weak var eventIDLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ticketView.layer.cornerRadius = 10
        self.ticketView.layer.borderWidth = 1.75
        self.ticketView.layer.borderColor = UIColor.black.cgColor
        
      
        // Initialization code
        

   }

}
