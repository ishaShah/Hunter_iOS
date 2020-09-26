//
//  HunterChatHeaderTableViewCell.swift
//  Hunter
//
//  Created by Zubin Manak on 21/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterChatHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDesignation: UILabel!
    @IBOutlet weak var labelMatchedOn: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
