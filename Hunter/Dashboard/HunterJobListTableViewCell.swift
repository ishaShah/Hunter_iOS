//
//  HunterJobListTableViewCell.swift
//  Hunter
//
//  Created by Zubin Manak on 05/02/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterJobListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!

override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
}
}
