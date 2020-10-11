//
//  HunterRecEditJobVC.swift
//  Hunter
//
//  Created by Zubin Manak on 10/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterRecEditJobVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var coll_jobs: UICollectionView!
    @IBOutlet weak var viewHeader: GradientView!
    var selectedJobsArr = ["Adobe XD" ,"Sketch" , "Invision","Full Time", "Adobe PhotoShop","USER RESEARCH",  "12 years Experience" , "CSS " , "HTML " , "Full Time", "Graphic Designer" , "12 years Experience" , "CSS " , "HTML"  , "Graphic Designer" , "12 years Experience" , "CSS" , "HTML","Full Time", "UX Designer" ,"3-4 years experience"  , ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return selectedJobsArr.count
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterRecEditJobCollectionCell", for: indexPath) as! HunterRecEditJobCollectionCell
            cell.titleLabel.text = selectedJobsArr[indexPath.row].capitalized
            return cell
        }
    
    
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            var label = UILabel(frame: CGRect.zero)
            label.text = selectedJobsArr[indexPath.row].uppercased()
            label.sizeToFit()
            return CGSize(width: label.frame.width, height: 25)
        }
    
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
         
        
    }
}
    class HunterRecEditJobCollectionCell: UICollectionViewCell {
        
        @IBOutlet weak var userImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 25/2
            
        }
        
    }



