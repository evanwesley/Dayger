//
//  CollectionViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 7/20/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        self.subView.layer.masksToBounds = true
        self.subView.layer.cornerRadius = subView.bounds.height / 2

        
  
        
        
    
        // Initialization code
    }

}
