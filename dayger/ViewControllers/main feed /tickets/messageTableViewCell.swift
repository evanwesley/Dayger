//
//  messageTableViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 11/26/21.
//

import UIKit

class messageTableViewCell: UITableViewCell {
    var docID = ""
    var date = ""
    var uid = ""
    var email = ""
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
