//
//  TableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 6/28/21.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    self.ticketView.layer.cornerRadius = 10
    self.ticketView.layer.borderWidth = 1.75
    self.ticketView.layer.borderColor = UIColor.black.cgColor
        
        
        
        
    self.subView.layer.cornerRadius = 10
        self.subView.layer.shadowColor = UIColor.black.cgColor
       self.subView.layer.shadowOpacity = 0.25
       self.subView.layer.shadowOffset = .zero
       self.subView.layer.shadowRadius = 2
        
        
        
        //self.ticketView.layer.shadowColor = UIColor.black.cgColor
       //self.ticketView.layer.shadowOpacity = 0.25
      // self.ticketView.layer.shadowOffset = .zero
      // self.ticketView.layer.shadowRadius = 4
        
        
        
        
        
        
      
        
        
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
