//
//  coHostCollectionViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 11/24/21.
//

import UIKit

class coHostCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var selfieImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selfieImage.layer.masksToBounds = true
        self.selfieImage.layer.cornerRadius = selfieImage.bounds.width / 2
       
        // Initialization code
    }

}
