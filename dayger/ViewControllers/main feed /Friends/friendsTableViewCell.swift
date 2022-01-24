//
//  friendsTableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 11/18/21.
//

import UIKit

class friendsTableViewCell: UITableViewCell {
    @IBOutlet weak var selfieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
        
        self.selfieImage.layer.borderColor = UIColor.orange.cgColor
        self.selfieImage.layer.borderWidth = 1
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
