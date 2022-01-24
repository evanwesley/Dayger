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
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var selfieImage: UIImageView!
    
    @IBOutlet weak var hostNameLabel: UILabel!
    
  
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ticketView.layer.cornerRadius = 15
       // self.ticketView.layer.borderWidth = 1.75
       // self.ticketView.layer.borderColor = UIColor.black.cgColor
        self.ticketView.layer.shadowColor = UIColor.gray.cgColor
        self.ticketView.layer.shadowOpacity = 0.3
        self.ticketView.layer.shadowOffset = .zero
        self.ticketView.layer.shadowRadius = 2
        
        
       
        self.circleView.layer.cornerRadius = 25
        self.circleView.layer.shadowColor = UIColor.gray.cgColor
        self.circleView.layer.shadowOpacity = 0.3
        self.circleView.layer.shadowOffset = .zero
        self.circleView.layer.shadowRadius = 2
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 2
        self.selfieImage.layer.borderColor = UIColor.white.cgColor
      
        // Initialization code
        

   }

}
