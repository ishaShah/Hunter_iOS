//
//  HunterChatRecieverImageCell.swift
//  Hunter
//
//  Created by Shamseer on 20/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterChatRecieverImageCell: UITableViewCell {

    @IBOutlet weak var imgRecievedImage: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var viewChatCV: UIView!
    
    @IBOutlet weak var imgClick: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
