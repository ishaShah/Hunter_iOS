//
//  HunterAllJobsCollectionViewCell.swift
//  Hunter
//
//  Created by Shamzi on 19/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterAllJobsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lblJobHeader: UILabel!
    @IBOutlet weak var lblJobType: UILabel!
    
    @IBOutlet weak var lblJobFunction: UILabel!
    @IBOutlet weak var lblJobSalary: UILabel!
    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMatches: UILabel!
    @IBOutlet weak var lblPostedDate: UILabel!
    @IBOutlet weak var viewIsDraft: UIView!
    @IBOutlet weak var constrTopToView: NSLayoutConstraint!
    
    @IBOutlet weak var viewInner: UIView!
}
