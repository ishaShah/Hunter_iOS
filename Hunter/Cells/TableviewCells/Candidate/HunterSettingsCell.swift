//
//  HunterSettingsCell.swift
//  Hunter
//
//  Created by Ajith Kumar on 10/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterSettingsCell: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var switchChange: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
