//
//  guestListTableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 7/19/21.
//

import UIKit

class guestListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var selfieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var socialLabel: UILabel!
    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        self.selfieImage.layer.borderWidth = 1
        self.selfieImage.layer.borderColor = UIColor.orange.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
