//
//  CollectionViewCell.swift
//  dayger
//
//  Created by Evan Wesley on 7/20/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    let daygerColor = UIColor(red: 240/255.0, green: 162/255.0, blue: 87/255.0, alpha: 1)
    
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        // 3
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 4
        blurView.translatesAutoresizingMaskIntoConstraints = false
        subView.insertSubview(blurView, at: 0)
        
        //contentView.layer.masksToBounds = true
        subView.layer.cornerRadius = subView.bounds.height / 2
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 25
        
        subView.layer.borderColor = UIColor.white.cgColor
        subView.layer.borderWidth = 1.5
        //subView.layer.masksToBounds = true
        //layer.cornerRadius = subView.bounds.height / 2
   
        NSLayoutConstraint.activate([
            
            
          blurView.topAnchor.constraint(equalTo: subView.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: subView.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: subView.widthAnchor)
        ])
        // Initialization code
    }

}
