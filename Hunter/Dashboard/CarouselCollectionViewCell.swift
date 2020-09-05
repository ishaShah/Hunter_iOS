//
//  CarouselCollectionViewCell.swift
//  Hunter
//
//  Created by Zubin Manak on 10/12/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    static let identifier = "CarouselCollectionViewCell"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //        self.layer.cornerRadius = max(self.frame.size.width, self.frame.size.height) / 2
        //        self.layer.borderWidth = 10
        //        self.layer.borderColor = UIColor(red: 110.0/255.0, green: 80.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 25.0
        self.layer.masksToBounds = true
        
        
        self.contentView.layer.cornerRadius = 25.0
        //        self.contentView.layer.borderWidth = 1.0
        //        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
